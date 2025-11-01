import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/models/user_model.dart';

class LoginState extends ChangeNotifier {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final UserRepository _userRepository = UserRepository();
  
  bool _obscure = true;
  bool _rememberMe = true;
  String? _submitError;
  bool _isLoading = false;

  // Getters
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  bool get obscure => _obscure;
  bool get rememberMe => _rememberMe;
  String? get submitError => _submitError;
  bool get isLoading => _isLoading;

  bool get canSubmit =>
      _emailController.text.contains('@') && 
      _passwordController.text.length >= 6 &&
      !_isLoading;

  LoginState() {
    _emailController.addListener(_onTextChanged);
    _passwordController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    notifyListeners();
  }

  void toggleObscure() {
    _obscure = !_obscure;
    notifyListeners();
  }

  void toggleRememberMe(bool? value) {
    _rememberMe = value ?? false;
    notifyListeners();
  }

  void setSubmitError(String? error) {
    _submitError = error;
    notifyListeners();
  }

  void clearSubmitError() {
    _submitError = null;
    notifyListeners();
  }

  /// Xử lý đăng nhập với Firebase Auth
  Future<void> handleLogin(BuildContext context) async {
    FocusScope.of(context).unfocus();
    
    // Clear error trước
    clearSubmitError();
    
    // Validate input
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || !email.contains('@')) {
      setSubmitError('Please enter a valid email address.');
      return;
    }

    if (password.isEmpty) {
      setSubmitError('Please enter your password.');
      return;
    }

    // Set loading state
    _isLoading = true;
    notifyListeners();

    try {
      // Đăng nhập với Firebase Auth
      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Đăng nhập thành công, chuyển đến màn hình home NGAY (không chờ check/tạo user profile)
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/');
      }

      // Kiểm tra và tạo user profile trong BACKGROUND (không block UI)
      final currentUser = _authService.currentUser;
      if (currentUser != null) {
        _ensureUserProfileInBackground(currentUser, email);
      }
    } catch (e) {
      // Xử lý lỗi
      setSubmitError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Gửi email reset password
  Future<void> sendPasswordReset(BuildContext context) async {
    final email = _emailController.text.trim();
    
    if (email.isEmpty || !email.contains('@')) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid email address.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    try {
      await _authService.sendPasswordResetEmail(email);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent! Please check your inbox.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Đảm bảo user có profile trong database (chạy trong background)
  void _ensureUserProfileInBackground(dynamic firebaseUser, String email) {
    // Chạy trong microtask để không block main thread
    Future.microtask(() async {
      try {
        // Kiểm tra nếu user chưa có trong Realtime Database thì tạo mới
        final existingUser = await _userRepository.getUserById(firebaseUser.uid).timeout(
          const Duration(seconds: 3),
          onTimeout: () {
            print('⚠ Timeout checking user - assuming not exists');
            return null;
          },
        );
        
        if (existingUser == null) {
          // User chưa có trong database, tạo mới với format khớp firebase_sample_data.json
          print('Background: Creating user profile in Realtime Database');
          final newUser = UserModel.fromFirebaseAuth(
            uid: firebaseUser.uid,
            email: firebaseUser.email,
            displayName: firebaseUser.displayName ?? email.split('@')[0],
            photoURL: firebaseUser.photoURL,
            phoneNumber: firebaseUser.phoneNumber,
          );
          
          try {
            await _userRepository.createUser(newUser);
            print('✓ Background: User profile created in Realtime Database');
          } catch (e) {
            print('⚠ Background: Could not create user profile: $e');
            // Không ảnh hưởng - user đã đăng nhập thành công
          }
        } else {
          print('✓ User profile already exists in database');
        }
      } catch (e) {
        print('⚠ Background: Error ensuring user profile: $e');
        // Không ảnh hưởng - user đã đăng nhập thành công
      }
    });
  }

  @override
  void dispose() {
    _emailController.removeListener(_onTextChanged);
    _passwordController.removeListener(_onTextChanged);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
