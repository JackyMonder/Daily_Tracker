import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import '../../common/widgets/index.dart';
class AuthIntroScreen extends StatelessWidget {
  const AuthIntroScreen({super.key});

  static const routeName = '/auth-intro';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(image: AssetImage('assets/images/mainBg.png'), 
        //   fit: BoxFit.cover),
        // ),
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
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF09AA2), Color(0xFF6BB6DF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.note_alt_outlined, color: Colors.white, size: 36),
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
                      onPressed: () {},
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
                    SizedBox(
                      height: 52,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF09AA2), Color(0xFF6BB6DF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
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
                      onPressed: () => Navigator.of(context).pushNamed('/'),
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
  const _BrandFullButton({required this.icon, required this.label, required this.onPressed});
  final Widget icon;
  final String label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final color = theme.colorScheme;
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: theme.colorScheme.surface,
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
