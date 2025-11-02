import 'package:flutter/material.dart';
import '../../shared/widgets/index.dart';
import '../state/login_state.dart';

class AuthIntroScreen extends StatefulWidget {
  const AuthIntroScreen({super.key});

  static const routeName = '/auth-intro';

  @override
  State<AuthIntroScreen> createState() => _AuthIntroScreenState();
}

class _AuthIntroScreenState extends State<AuthIntroScreen> {
  String? _googleClientId;

  @override
  void initState() {
    super.initState();
    _loadGoogleClientId();
  }

  /// Lấy Google Client ID
  /// 
  /// Lưu ý: Với mobile (Android/iOS), không cần clientId vì sẽ lấy từ google-services.json
  /// Với web, cần có clientId từ Google Cloud Console OAuth 2.0 Client ID
  void _loadGoogleClientId() {
    // Với mobile, google_sign_in tự động lấy config từ google-services.json
    // Với web, cần set clientId. Tạm thời để null để sử dụng auto-detect
    // TODO: Nếu cần cho web, lấy từ Google Cloud Console OAuth 2.0 Client ID (Web client)
    _googleClientId = null; // null = tự động detect cho mobile, cần set cho web
  }

  Future<void> _handleAnonymousLogin(BuildContext context) async {
    final loginState = LoginState();
    try {
      await loginState.handleAnonymousLogin(context);
    } catch (e) {
      // Error đã được xử lý trong handleAnonymousLogin
    } finally {
      // Delay dispose để đảm bảo error message được hiển thị (nếu có)
      Future.delayed(const Duration(seconds: 2), () {
        loginState.dispose();
      });
    }
  }

  Future<void> _handleGoogleLogin(BuildContext context) async {
    final loginState = LoginState();
    try {
      await loginState.handleGoogleLogin(context, _googleClientId);
    } catch (e) {
      // Error đã được xử lý trong handleGoogleLogin
    } finally {
      // Delay dispose để đảm bảo error message được hiển thị (nếu có)
      Future.delayed(const Duration(seconds: 2), () {
        loginState.dispose();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/mainBg.png'), 
          fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF09AA2), Color(0xFF6BB6DF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF09AA2).withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.note_alt_outlined, color: Colors.white, size: 40),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.center,
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFFF09AA2), Color(0xFF6BB6DF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(bounds),
                        blendMode: BlendMode.srcIn,
                        child: Text(
                          'Note Taker',
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Let's Get Started!",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 24),
                    _BrandFullButton(
                      icon: CommonWidgets().facebookCircle,
                      label: 'Continue with Facebook',
                      onPressed: () {},
                    ),
                    const SizedBox(height: 12),
                    _BrandFullButton(
                      icon: CommonWidgets().googleCircle,
                      label: 'Continue with Google',
                      onPressed: () => _handleGoogleLogin(context),
                    ),
                    const SizedBox(height: 12),
                    _BrandFullButton(
                      icon: CommonWidgets().appleCircle,
                      label: 'Continue with Apple',
                      onPressed: () {},
                    ),
                    const SizedBox(height: 12),
                    _BrandFullButton(
                      icon: CommonWidgets().twitterCircle,
                      label: 'Continue with X',
                      onPressed: () {},
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text('Or', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF09AA2), Color(0xFF6BB6DF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFF09AA2).withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(28),
                          onTap: () => Navigator.of(context).pushNamed('/login'),
                          child: Center(
                            child: Text(
                              'Sign in with password',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have a account?", style: theme.textTheme.bodyMedium),
                        TextButton(
                          onPressed: () => Navigator.of(context).pushNamed('/signup'),
                          child: Text('Sign up', style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFFD55C6A))),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () => _handleAnonymousLogin(context),
                      child: Text('Continue as a guest', style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFFD55C6A))),
                    ),
                    const Spacer(),
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
  }
}

class _BrandFullButton extends StatelessWidget {
  const _BrandFullButton({required this.icon, required this.label, this.onPressed});
  final Widget icon;
  final String label;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color.fromARGB(255, 181, 181, 181)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.white),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 12),
            Text(label, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
