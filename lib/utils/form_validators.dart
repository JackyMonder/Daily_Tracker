class FormValidators {
  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter email';
    if (!value.contains('@')) return 'Invalid email';
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.length < 6) return 'Minimum 6 characters';
    return null;
  }
}
