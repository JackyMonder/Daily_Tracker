import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/services/auth_service.dart';

class LoginState extends ChangeNotifier {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;
  bool _rememberMe = true;
  String? _submitError;
  bool _isLoading = false;

  final AuthService _authService = AuthService();

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
    if (_submitError != null) {
      clearSubmitError();
    }
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

  /// Đăng nhập với email và password
  Future<void> handleLogin(BuildContext context) async {
    FocusScope.of(context).unfocus();
    
    if (!canSubmit) return;

    _isLoading = true;
    clearSubmitError();
    notifyListeners();

    try {
      final credential = await _authService.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Chỉ navigate khi đăng nhập thành công và có credential
      if (credential != null && credential.user != null && context.mounted) {
        Navigator.of(context).pushReplacementNamed('/');
      } else {
        // Nếu không có credential, đây là trường hợp bất thường
        final errorMessage = 'Đăng nhập thất bại. Vui lòng thử lại.';
        setSubmitError(errorMessage);
        _showErrorSnackBar(context, errorMessage);
      }
    } catch (e) {
      // Xử lý lỗi và hiển thị thông báo
      final errorMessage = e.toString();
      setSubmitError(errorMessage);
      _showErrorSnackBar(context, errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Đăng nhập ẩn danh
  /// 
  /// Nếu đã có anonymous user, sẽ sử dụng lại user đó thay vì tạo mới
  Future<void> handleAnonymousLogin(BuildContext context) async {
    _isLoading = true;
    clearSubmitError();
    notifyListeners();

    try {
      final credential = await _authService.signInAnonymously();
      
      // Nếu credential == null, có nghĩa là đã có anonymous user và đang sử dụng lại
      // Kiểm tra currentUser trực tiếp
      final currentUser = FirebaseAuth.instance.currentUser;
      
      // Navigate nếu:
      // 1. Có credential mới (vừa tạo anonymous user mới), HOẶC
      // 2. credential == null nhưng có currentUser và là anonymous (đang reuse user cũ)
      if ((credential != null && credential.user != null) ||
          (credential == null && currentUser != null && currentUser.isAnonymous)) {
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed('/');
        }
      } else {
        final errorMessage = 'Đăng nhập ẩn danh thất bại. Vui lòng thử lại.';
        setSubmitError(errorMessage);
        _showErrorSnackBar(context, errorMessage);
      }
    } catch (e) {
      // Xử lý lỗi và hiển thị thông báo
      final errorMessage = e.toString();
      setSubmitError(errorMessage);
      _showErrorSnackBar(context, errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Đăng nhập với Google
  Future<void> handleGoogleLogin(BuildContext context, String? clientId) async {
    _isLoading = true;
    clearSubmitError();
    notifyListeners();

    try {
      print('LoginState: Starting Google login...');
      final credential = await _authService.signInWithGoogle(clientId: clientId);
      
      // Navigate nếu đăng nhập thành công
      // Nếu credential == null, có thể là user đã hủy (không phải lỗi)
      if (credential != null && credential.user != null) {
        print('LoginState: Google login successful, navigating to home...');
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed('/');
        }
      } else if (credential == null) {
        // User đã hủy đăng nhập, không hiển thị lỗi
        print('LoginState: User cancelled Google login');
        // Chỉ reset loading state - không hiển thị error
      } else {
        final errorMessage = 'Đăng nhập với Google thất bại. Vui lòng thử lại.';
        print('LoginState: Google login failed - $errorMessage');
        setSubmitError(errorMessage);
        if (context.mounted) {
          _showErrorSnackBar(context, errorMessage);
        }
      }
    } catch (e) {
      // Xử lý lỗi và hiển thị thông báo
      print('LoginState: Error during Google login: $e');
      final errorMessage = e.toString();
      setSubmitError(errorMessage);
      if (context.mounted) {
        _showErrorSnackBar(context, errorMessage);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Hiển thị snackbar lỗi chuyên nghiệp với icon và action
  void _showErrorSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFD55C6A),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
        action: SnackBarAction(
          label: 'Đóng',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
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
