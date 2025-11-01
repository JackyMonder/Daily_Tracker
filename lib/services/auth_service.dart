import 'package:firebase_auth/firebase_auth.dart';
import '../data/models/user_model.dart';

/// Service quản lý Firebase Authentication
/// Xử lý đăng nhập, đăng ký, đăng xuất và quản lý session
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Lấy user hiện tại đang đăng nhập
  User? get currentUser => _auth.currentUser;

  /// Lấy UID của user hiện tại
  String? get currentUserId => _auth.currentUser?.uid;

  /// Stream theo dõi trạng thái đăng nhập
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Đăng nhập với email và password
  /// 
  /// [email] - Email của user
  /// [password] - Password của user
  /// 
  /// Trả về UserCredential nếu thành công, throw exception nếu lỗi
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      // Xử lý các lỗi cụ thể từ Firebase
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many requests. Please try again later.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        default:
          errorMessage = 'An error occurred: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  /// Đăng ký tài khoản mới với email và password
  /// 
  /// [email] - Email của user
  /// [password] - Password của user
  /// [displayName] - Tên hiển thị (optional)
  /// 
  /// Trả về UserCredential nếu thành công, throw exception nếu lỗi
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Cập nhật displayName nếu có
      if (displayName != null && displayName.isNotEmpty && credential.user != null) {
        try {
          await credential.user!.updateDisplayName(displayName);
          await credential.user!.reload();
          // Đợi một chút để đảm bảo update đã hoàn tất
          await Future.delayed(const Duration(milliseconds: 300));
        } catch (e) {
          // Log nhưng không throw vì đăng ký đã thành công
          print('Warning: Could not update displayName: $e');
        }
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      // Xử lý các lỗi cụ thể từ Firebase
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists for that email.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        default:
          errorMessage = 'An error occurred: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  /// Đăng xuất
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  /// Gửi email reset password
  /// 
  /// [email] - Email của user cần reset password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        default:
          errorMessage = 'An error occurred: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }

  /// Lấy thông tin UserModel từ Firebase Auth User
  UserModel? getCurrentUserModel() {
    final user = currentUser;
    if (user == null) return null;

    return UserModel.fromFirebaseAuth(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoURL: user.photoURL,
      phoneNumber: user.phoneNumber,
    );
  }

  /// Kiểm tra user đã đăng nhập chưa
  bool get isSignedIn => currentUser != null;
}

