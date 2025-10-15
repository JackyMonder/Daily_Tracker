import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const routeName = '/signup';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;
  bool _rememberMe = true;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final bool canSubmit =
        _emailController.text.contains('@') && _passwordController.text.length >= 6;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 12,
                bottom: 12 + bottomInset,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.arrow_back),
                          style: IconButton.styleFrom(
                            backgroundColor: color.surfaceVariant.withOpacity(0.4),
                            shape: const CircleBorder(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Create your',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      'Account',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    if (_submitError != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _submitError!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFFD55C6A),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    _RoundedField(
                      controller: _emailController,
                      hintText: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Please enter email';
                        if (!v.contains('@')) return 'Invalid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    _RoundedField(
                      controller: _passwordController,
                      hintText: 'Password',
                      icon: Icons.lock_outline,
                      obscureText: _obscure,
                      trailing: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                      ),
                      validator: (v) => (v == null || v.length < 6)
                          ? 'Minimum 6 characters'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (v) => setState(() => _rememberMe = v ?? false),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          side: BorderSide(color: color.outlineVariant),
                          fillColor: const WidgetStatePropertyAll(Color(0xFFF09AA2)),
                          checkColor: color.onPrimary,
                        ),
                        const SizedBox(width: 8),
                        Text('Remember me', style: theme.textTheme.bodyMedium),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _GradientButton(
                      text: 'Sign up',
                      enabled: canSubmit,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          if (_emailController.text.contains('x')) {
                            setState(() => _submitError =
                                'Please check your email or password and try again.');
                          } else {
                            setState(() => _submitError = null);
                            Navigator.of(context).pushReplacementNamed('/');
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: Divider(color: color.outlineVariant)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'or continue with',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: color.outlineVariant)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        _FacebookCircle(),
                        SizedBox(width: 16),
                        _GoogleCircle(),
                        SizedBox(width: 16),
                        _BrandCircle(icon: FontAwesomeIcons.apple, color: Colors.black),
                        SizedBox(width: 16),
                        _BrandCircle(icon: FontAwesomeIcons.xTwitter, color: Colors.black),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?',
                            style: theme.textTheme.bodyMedium),
                        TextButton(
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed('/login'),
                          child: Text(
                            'Sign in',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFFD55C6A),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        TextButton(onPressed: null, child: Text('Privacy Policy')),
                        TextButton(onPressed: null, child: Text('Term of Service')),
                      ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RoundedField extends StatelessWidget {
  const _RoundedField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
    this.trailing,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        suffixIcon: trailing,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({required this.text, required this.onPressed, this.enabled = true});

  final String text;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: enabled
                ? const [Color(0xFFF09AA2), Color(0xFF6BB6DF)]
                : [
                    const Color(0xFFF09AA2).withOpacity(0.5),
                    const Color(0xFF6BB6DF).withOpacity(0.5),
                  ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: enabled ? onPressed : null,
            child: Center(
              child: Text(
                text,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: enabled ? Colors.white : Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandCircle extends StatelessWidget {
  const _BrandCircle({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colorScheme.outlineVariant),
        color: theme.colorScheme.surface,
      ),
      child: Center(
        child: FaIcon(icon, size: 22, color: color),
      ),
    );
  }
}

class _FacebookCircle extends StatelessWidget {
  const _FacebookCircle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF1877F2),
      ),
      child: const Center(
        child: FaIcon(FontAwesomeIcons.facebookF, size: 22, color: Colors.white),
      ),
    );
  }
}

class _GoogleCircle extends StatelessWidget {
  const _GoogleCircle();

  static const String _gSvg =
      '<svg width="22" height="22" viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg">'
      '<path fill="#FFC107" d="M43.611 20.083H42V20H24v8h11.303C33.932 31.91 29.393 35 24 35c-6.627 0-12-5.373-12-12s5.373-12 12-12c3.059 0 5.842 1.154 7.961 3.039l5.657-5.657C33.584 5.053 28.971 3 24 3 12.954 3 4 11.954 4 23s8.954 20 20 20 19-8.954 19-20c0-1.341-.138-2.653-.389-3.917z"/>'
      '<path fill="#FF3D00" d="M6.306 14.691l6.571 4.814C14.464 16.103 18.86 13 24 13c3.059 0 5.842 1.154 7.961 3.039l5.657-5.657C33.584 5.053 28.971 3 24 3 16.318 3 9.656 7.337 6.306 14.691z"/>'
      '<path fill="#4CAF50" d="M24 43c5.313 0 10.155-2.037 13.79-5.351l-6.363-5.375C29.402 33.447 26.895 34 24 34c-5.37 0-9.897-3.053-12.072-7.497l-6.56 5.05C8.681 38.556 15.814 43 24 43z"/>'
      '<path fill="#1976D2" d="M43.611 20.083H42V20H24v8h11.303c-1.087 3.109-3.293 5.558-6.074 7.017l.001-.001 6.363 5.375C33.117 41.346 38 38 40.95 33.05 42.262 30.773 43 27.995 43 24c0-1.341-.138-2.653-.389-3.917z"/>'
      '</svg>';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.outlineVariant),
        color: theme.colorScheme.surface,
      ),
      child: Center(child: SvgPicture.string(_gSvg, width: 22, height: 22)),
    );
  }
}


