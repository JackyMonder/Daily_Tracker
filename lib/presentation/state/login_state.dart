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
      final credential = await _authService.signInWithGoogle(clientId: clientId);
      
      // Navigate nếu đăng nhập thành công
      // Nếu credential == null, có thể là user đã hủy (không phải lỗi)
      if (credential != null && credential.user != null) {
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed('/');
        }
      } else if (credential == null) {
      } else {
        final errorMessage = 'Đăng nhập với Google thất bại. Vui lòng thử lại.';
        setSubmitError(errorMessage);
        if (context.mounted) {
          _showErrorSnackBar(context, errorMessage);
        }
      }
    } catch (e) {
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

  /// Hiển thị snackbar lỗi
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

  /// Hiển thị snackbar thành công
  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
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
        backgroundColor: const Color(0xFF2E7D32),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// Quên mật khẩu: gửi email đặt lại mật khẩu
  Future<void> handleForgotPassword(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final email = _emailController.text.trim();

    if (!email.contains('@')) {
      _showErrorSnackBar(context, 'Vui lòng nhập email hợp lệ để đặt lại mật khẩu.');
      return;
    }

    try {
      // Kiểm tra tài khoản có tồn tại trước khi gửi email reset
      // final exists = await _authService.doesEmailExist(email: email);
      // if (!exists) {
      //   _showErrorSnackBar(context, 'Email này chưa được đăng ký. Vui lòng tạo tài khoản mới.');
      //   return;
      // }

      await _authService.sendPasswordResetEmail(email: email);
      if (context.mounted) {
        _showSuccessSnackBar(
          context,
          'Email đặt lại mật khẩu đã được gửi.',
        );
      }
    } catch (e) {
      _showErrorSnackBar(context, e.toString());
    }
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
