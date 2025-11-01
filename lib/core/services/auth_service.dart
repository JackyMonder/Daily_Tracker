import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';
import '../../data/repositories/user_repository.dart';
import 'auth_preferences_service.dart';

/// Service quản lý Firebase Authentication
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository _userRepository = UserRepository();
  final AuthPreferencesService _authPreferences = AuthPreferencesService();

  /// Stream lắng nghe thay đổi auth state
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Lấy user hiện tại
  User? get currentUser => _auth.currentUser;

  /// Đăng nhập với email và password
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      // Xóa logout state và anonymous user ID khi đăng nhập thành công
      if (credential.user != null) {
        await _authPreferences.clearLogoutState();
        await _authPreferences.clearAnonymousUserId(); // Xóa anonymous ID nếu có
      }
      
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Đã xảy ra lỗi: ${e.toString()}';
    }
  }

  /// Đăng ký với email và password
  /// 
  /// Tự động lưu user profile vào Realtime Database sau khi đăng ký thành công
  Future<UserCredential?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Sau khi đăng ký thành công, lưu user profile vào Realtime Database
      if (credential.user != null) {
        try {
          await _userRepository.saveUserProfile(
            credential.user!,
            name: name ?? email.split('@').first, // Dùng phần trước @ làm tên mặc định
          );
        } catch (e) {
          // Nếu lưu profile thất bại, vẫn cho đăng ký thành công
          // (user đã được tạo trong Firebase Auth)
          print('Warning: Failed to save user profile: $e');
        }
        
        // Xóa logout state và anonymous user ID khi đăng ký thành công
        await _authPreferences.clearLogoutState();
        await _authPreferences.clearAnonymousUserId(); // Xóa anonymous ID nếu có
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Đã xảy ra lỗi: ${e.toString()}';
    }
  }

  /// Đăng nhập ẩn danh (Anonymous)
  /// 
  /// Đảm bảo mỗi thiết bị chỉ có 1 tài khoản anonymous duy nhất.
  /// Nếu đã có anonymous user, sẽ sử dụng lại thay vì tạo mới.
  /// Nếu có anonymous user ID đã lưu (từ lần logout trước), sẽ kiểm tra và xóa nó.
  /// Tự động lưu user profile vào Realtime Database sau khi đăng nhập ẩn danh thành công
  /// 
  /// Return null nếu đã có anonymous user (để báo là không cần tạo mới)
  Future<UserCredential?> signInAnonymously() async {
    try {
      final currentUser = _auth.currentUser;
      
      // Nếu đã có anonymous user, sử dụng lại user đó (không tạo mới)
      if (currentUser != null && currentUser.isAnonymous) {
        // User đã là anonymous, chỉ cần đảm bảo profile được lưu
        try {
          await _userRepository.saveUserProfile(
            currentUser,
            name: 'Guest User',
          );
        } catch (e) {
          print('Warning: Failed to save anonymous user profile: $e');
        }
        
        // Xóa logout state và anonymous user ID khi đăng nhập thành công
        await _authPreferences.clearLogoutState();
        await _authPreferences.clearAnonymousUserId();
        
        // Trả về null để báo là đã có user, không cần tạo mới
        // Nơi gọi sẽ check currentUser trực tiếp thay vì credential
        return null;
      }
      
      // Nếu có user khác (email/password), cần đăng xuất trước
      if (currentUser != null && !currentUser.isAnonymous) {
        await _auth.signOut();
      }

      // Chưa có anonymous user, tạo mới
      final credential = await _auth.signInAnonymously();

      // Sau khi đăng nhập ẩn danh thành công, lưu user profile vào Realtime Database
      if (credential.user != null) {
        try {
          await _userRepository.saveUserProfile(
            credential.user!,
            name: 'Guest User',
          );
        } catch (e) {
          // Nếu lưu profile thất bại, vẫn cho đăng nhập thành công
          print('Warning: Failed to save anonymous user profile: $e');
        }
        
        // Xóa logout state và anonymous user ID (nếu có) khi đăng nhập thành công
        await _authPreferences.clearLogoutState();
        await _authPreferences.clearAnonymousUserId();
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Đã xảy ra lỗi: ${e.toString()}';
    }
  }

  /// Đăng nhập với Google
  /// 
  /// Sử dụng google_sign_in kết hợp với Firebase Auth để xử lý OAuth flow
  /// [clientId] - Google OAuth Client ID (optional cho Android/iOS, required cho web)
  /// Tự động lưu user profile vào Realtime Database sau khi đăng nhập thành công
  Future<UserCredential?> signInWithGoogle({String? clientId}) async {
    try {
      print('Starting Google Sign In...');
      
      // Khởi tạo GoogleSignIn
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        // Với Android/iOS: null = tự động lấy từ google-services.json
        // Với Web: cần clientId từ Google Cloud Console OAuth 2.0 Client ID
        clientId: clientId,
      );

      // Kiểm tra xem có đang đăng nhập với tài khoản khác không
      try {
        await googleSignIn.signOut(); // Sign out khỏi Google account cũ nếu có
      } catch (e) {
        // Ignore nếu chưa có account nào đăng nhập
        print('No previous Google sign in to sign out from');
      }

      print('Triggering Google Sign In flow...');
      // Trigger Google Sign In flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // Kiểm tra nếu user hủy đăng nhập
      if (googleUser == null) {
        print('User cancelled Google Sign In');
        return null; // User đã hủy đăng nhập
      }

      print('Google user signed in: ${googleUser.email}');
      
      // Lấy authentication details từ Google
      print('Getting Google authentication details...');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Kiểm tra tokens
      if (googleAuth.accessToken == null && googleAuth.idToken == null) {
        throw 'Không thể lấy thông tin xác thực từ Google. Vui lòng thử lại.';
      }

      print('Creating Firebase credential...');
      // Tạo credential cho Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('Signing in to Firebase with Google credential...');
      // Đăng nhập vào Firebase với Google credential
      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw 'Đăng nhập thành công nhưng không nhận được thông tin user.';
      }

      print('Google Sign In successful: ${userCredential.user!.email}');

      // Sau khi đăng nhập thành công, lưu user profile vào Realtime Database
      try {
        print('Saving user profile to database...');
        await _userRepository.saveUserProfile(
          userCredential.user!,
          name: userCredential.user!.displayName ?? 
                userCredential.user!.email?.split('@').first ?? 
                'User',
        );
        print('User profile saved successfully');
      } catch (e) {
        // Nếu lưu profile thất bại, vẫn cho đăng nhập thành công
        print('Warning: Failed to save Google user profile: $e');
      }

      // Xóa logout state và anonymous user ID khi đăng nhập thành công
      await _authPreferences.clearLogoutState();
      await _authPreferences.clearAnonymousUserId(); // Xóa anonymous ID nếu có

      return userCredential;
    } on PlatformException catch (e) {
      // Xử lý PlatformException từ Google Sign In
      print('PlatformException during Google Sign In: ${e.code} - ${e.message}');
      
      if (e.code == 'sign_in_failed' && e.message != null && e.message!.contains('10')) {
        // ApiException 10 = DEVELOPER_ERROR
        throw 'Lỗi cấu hình Google Sign In. Vui lòng:\n'
              '1. Thêm SHA-1 fingerprint vào Firebase Console\n'
              '2. Tải lại google-services.json\n'
              '3. Đảm bảo Google Sign-In đã được bật trong Firebase Authentication\n'
              'Chi tiết: ${e.message}';
      }
      
      throw 'Lỗi đăng nhập với Google: ${e.message ?? e.code}';
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Exception: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } on Exception catch (e) {
      print('Exception during Google Sign In: $e');
      throw 'Đã xảy ra lỗi khi đăng nhập với Google: ${e.toString()}';
    } catch (e) {
      print('Unexpected error during Google Sign In: $e');
      throw 'Đã xảy ra lỗi không mong đợi: ${e.toString()}';
    }
  }

  /// Đăng xuất
  /// 
  /// Đăng xuất khỏi Firebase Auth và lưu logout state để ngăn tự động đăng nhập lại
  /// Đối với anonymous user: KHÔNG signOut() để giữ session và cho phép reuse khi đăng nhập lại
  /// Đối với real user: signOut() và lưu logout state
  Future<void> signOut() async {
    try {
      final currentUser = _auth.currentUser;
      
      // Nếu là anonymous user, KHÔNG signOut để giữ session
      // Firebase Auth sẽ tự động persist anonymous session, cho phép reuse khi đăng nhập lại
      if (currentUser != null && currentUser.isAnonymous) {
        // Không lưu logout state - cho phép reuse
        // Không signOut() - giữ session trong Firebase Auth để có thể reuse
        print('Anonymous user logout: keeping session for reuse');
        return; // Chỉ return, không signOut() để giữ session
      }
      
      // Đối với real user, signOut() và lưu logout state
      // Sign out khỏi Google nếu có
      try {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
      } catch (e) {
        // Ignore nếu không có Google account đăng nhập
        print('No Google account to sign out from: $e');
      }
      
      // Sign out khỏi Firebase Auth
      await _auth.signOut();
      
      // Lưu logout state để ngăn tự động đăng nhập lại
      await _authPreferences.setUserLoggedOut(true);
    } catch (e) {
      throw 'Lỗi khi đăng xuất: ${e.toString()}';
    }
  }

  /// Xử lý Firebase Auth Exception và trả về message tiếng Việt với suggestions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Mật khẩu quá yếu. Vui lòng chọn mật khẩu có ít nhất 6 ký tự, bao gồm chữ cái và số.';
      case 'email-already-in-use':
        return 'Email này đã được sử dụng. Bạn có muốn đăng nhập thay vì đăng ký không?';
      case 'user-not-found':
        return 'Không tìm thấy tài khoản với email này. Bạn có thể cần đăng ký tài khoản mới.';
      case 'wrong-password':
        return 'Mật khẩu không chính xác. Vui lòng kiểm tra lại hoặc sử dụng tính năng "Quên mật khẩu".';
      case 'invalid-email':
        return 'Địa chỉ email không hợp lệ. Vui lòng nhập email đúng định dạng (ví dụ: user@example.com).';
      case 'user-disabled':
        return 'Tài khoản của bạn đã bị vô hiệu hóa. Vui lòng liên hệ bộ phận hỗ trợ để được trợ giúp.';
      case 'too-many-requests':
        return 'Bạn đã thử quá nhiều lần. Vui lòng đợi vài phút trước khi thử lại để bảo vệ tài khoản của bạn.';
      case 'operation-not-allowed':
        return 'Phương thức đăng nhập này tạm thời không khả dụng. Vui lòng thử phương thức khác hoặc liên hệ hỗ trợ.';
      case 'network-request-failed':
        return 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối internet của bạn và thử lại.';
      case 'invalid-credential':
        return 'Thông tin đăng nhập không chính xác. Vui lòng kiểm tra lại email và mật khẩu.';
      case 'account-exists-with-different-credential':
        return 'Email này đã được đăng ký với phương thức đăng nhập khác. Vui lòng sử dụng phương thức đó.';
      default:
        return 'Đã xảy ra lỗi không mong muốn. Vui lòng thử lại sau hoặc liên hệ hỗ trợ nếu vấn đề vẫn tiếp diễn.';
    }
  }
}

