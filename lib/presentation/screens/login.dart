import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../state/login_state.dart';
import '../../common/widgets/rounded_field.dart';
import '../../common/widgets/gradient_button.dart';
import '../../common/widgets/social_login_buttons.dart';
import '../../utils/form_validators.dart';
import '../../common/widgets/index.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final LoginState _loginState;

  @override
  void initState() {
    super.initState();
    _loginState = LoginState();
  }

  @override
  void dispose() {
    _loginState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

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
                            backgroundColor: color.surfaceContainerHighest.withValues(alpha: 0.4),
                            shape: const CircleBorder(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Login to your',
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
                    if (_loginState.submitError != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _loginState.submitError!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFFD55C6A),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    RoundedField(
                      controller: _loginState.emailController,
                      hintText: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: FormValidators.emailValidator,
                    ),
                    const SizedBox(height: 12),
                    RoundedField(
                      controller: _loginState.passwordController,
                      hintText: 'Password',
                      icon: Icons.lock_outline,
                      obscureText: _loginState.obscure,
                      trailing: IconButton(
                        onPressed: _loginState.toggleObscure,
                        icon: Icon(_loginState.obscure ? Icons.visibility_off : Icons.visibility),
                      ),
                      validator: FormValidators.passwordValidator,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: _loginState.rememberMe,
                          onChanged: _loginState.toggleRememberMe,
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
                    GradientButton(
                      text: 'Sign in',
                      enabled: _loginState.canSubmit,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _loginState.handleLogin(context);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot the password?',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFFD55C6A),
                          ),
                        ),
                      ),
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
                        FacebookCircle(),
                        SizedBox(width: 16),
                        GoogleCircle(),
                        SizedBox(width: 16),
                        AppleCircle(),
                        SizedBox(width: 16),
                        TwitterCircle(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?',
                            style: theme.textTheme.bodyMedium),
                        TextButton(
                          onPressed: () => Navigator.of(context).pushNamed('/signup'),
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



