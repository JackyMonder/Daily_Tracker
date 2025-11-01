import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/models/user_model.dart';

class SignUpState extends ChangeNotifier {
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

  SignUpState() {
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

  /// Xử lý đăng ký với Firebase Auth và lưu user vào Realtime Database
  Future<void> handleSignUp(BuildContext context) async {
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

    if (password.length < 6) {
      setSubmitError('Password must be at least 6 characters.');
      return;
    }

    // Set loading state
    _isLoading = true;
    notifyListeners();

    try {
      // Đăng ký với Firebase Auth
      // Lấy tên từ email (phần trước @) làm displayName mặc định
      final displayName = email.split('@')[0];
      
      final userCredential = await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );

      // Đợi một chút để đảm bảo Firebase Auth đã hoàn tất
      await Future.delayed(const Duration(milliseconds: 200));

      // Đăng ký thành công, chuyển đến màn hình đăng nhập NGAY (không chờ lưu database)
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully! Please sign in.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pushReplacementNamed('/login');
      }

      // Lưu user vào Realtime Database trong BACKGROUND (fire and forget)
      // Không block UI flow, sẽ tự retry khi đăng nhập nếu thất bại
      if (userCredential.user != null) {
        final firebaseUser = userCredential.user!;
        final newUser = UserModel.fromFirebaseAuth(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? email,
          displayName: firebaseUser.displayName ?? displayName,
          photoURL: firebaseUser.photoURL,
          phoneNumber: firebaseUser.phoneNumber,
        );

        // Lưu trong background - không await để không block
        _saveUserInBackground(newUser);
      }
    } catch (e) {
      // Xử lý lỗi
      setSubmitError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Lưu user vào database trong background (không block UI)
  void _saveUserInBackground(UserModel user) {
    // Chạy trong isolate riêng để không block main thread
    Future.microtask(() async {
      try {
        print('=== Background: Saving user to Realtime Database ===');
        print('UID: ${user.id}');
        print('Email: ${user.email}');
        
        await _userRepository.createUser(user);
        print('✓ Background: User saved to Realtime Database successfully!');
      } catch (e) {
        print('⚠ Background: Failed to save user (will retry on login): $e');
        // Không hiển thị error vì đã chuyển màn hình
        // Sẽ tự động retry khi user đăng nhập
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
