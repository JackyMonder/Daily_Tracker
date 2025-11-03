import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';

class SignUpState extends ChangeNotifier {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;
  bool _rememberMe = true;
  String? _submitError;
  bool _isLoading = false;

  final AuthService _authService = AuthService();

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

  /// Đăng ký với email và password
  Future<void> handleSignUp(BuildContext context) async {
    FocusScope.of(context).unfocus();
    
    if (!canSubmit) return;

    _isLoading = true;
    clearSubmitError();
    notifyListeners();

    try {
      // Lấy tên từ email (phần trước @) làm tên mặc định
      final email = _emailController.text.trim();
      final name = email.split('@').first;
      
      final credential = await _authService.signUpWithEmailAndPassword(
        email: email,
        password: _passwordController.text,
        name: name,
      );

      // Chỉ navigate khi đăng ký thành công và có credential
      if (credential != null && credential.user != null && context.mounted) {
        Navigator.of(context).pushReplacementNamed('/');
      } else {
        // Nếu không có credential, đây là trường hợp bất thường
        setSubmitError('Đăng ký thất bại. Vui lòng thử lại.');
      }
    } catch (e) {
      final errorMessage = e.toString();
      setSubmitError(errorMessage);
      
      if (context.mounted) {
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
                    errorMessage,
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
    } finally {
      _isLoading = false;
      notifyListeners();
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
