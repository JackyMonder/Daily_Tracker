import 'package:flutter/material.dart';

class SignUpState extends ChangeNotifier {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;
  bool _rememberMe = true;
  String? _submitError;

  // Getters
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  bool get obscure => _obscure;
  bool get rememberMe => _rememberMe;
  String? get submitError => _submitError;

  bool get canSubmit =>
      _emailController.text.contains('@') && _passwordController.text.length >= 6;

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

  void handleSignUp(BuildContext context) {
    FocusScope.of(context).unfocus();
    
    // Demo submit: nếu email chứa 'x' thì giả lập lỗi
    if (_emailController.text.contains('x')) {
      setSubmitError('Please check your email or password and try again.');
    } else {
      clearSubmitError();
      Navigator.of(context).pushReplacementNamed('/');
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
