import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../common/widgets/index.dart';
class AuthIntroScreen extends StatelessWidget {
  const AuthIntroScreen({super.key});

  static const routeName = '/auth-intro';
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/Background_01.png'), fit: BoxFit.cover),
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
                    icon: const _GoogleCircle(),
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
                    onPressed: () => Navigator.of(context).pushNamed(''),
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
    ));
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
    final color = theme.colorScheme;
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: theme.colorScheme.surface,
          side: BorderSide(color: color.outlineVariant),
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

// class _BrandCircle extends StatelessWidget {
//   const _BrandCircle({required this.icon, required this.color});
//   final IconData icon;
//   final Color color;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 24,
//       height: 24,
//       decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.transparent),
//       child: Center(child: FaIcon(icon, size: 20, color: color)),
//     );
//   }
// }

// class _FacebookCircle extends StatelessWidget {
//   const _FacebookCircle();
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 24,
//       height: 24,
//       decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF1877F2)),
//       child: const Center(child: FaIcon(FontAwesomeIcons.facebookF, size: 14, color: Colors.white)),
//     );
//   }
// }

class _GoogleCircle extends StatelessWidget {
  const _GoogleCircle();
  static const String _gSvg =
      '<svg width="20" height="20" viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg">'
      '<path fill="#FFC107" d="M43.611 20.083H42V20H24v8h11.303C33.932 31.91 29.393 35 24 35c-6.627 0-12-5.373-12-12s5.373-12 12-12c3.059 0 5.842 1.154 7.961 3.039l5.657-5.657C33.584 5.053 28.971 3 24 3 12.954 3 4 11.954 4 23s8.954 20 20 20 19-8.954 19-20c0-1.341-.138-2.653-.389-3.917z"/>'
      '<path fill="#FF3D00" d="M6.306 14.691l6.571 4.814C14.464 16.103 18.86 13 24 13c3.059 0 5.842 1.154 7.961 3.039l5.657-5.657C33.584 5.053 28.971 3 24 3 16.318 3 9.656 7.337 6.306 14.691z"/>'
      '<path fill="#4CAF50" d="M24 43c5.313 0 10.155-2.037 13.79-5.351l-6.363-5.375C29.402 33.447 26.895 34 24 34c-5.37 0-9.897-3.053-12.072-7.497l-6.56 5.05C8.681 38.556 15.814 43 24 43z"/>'
      '<path fill="#1976D2" d="M43.611 20.083H42V20H24v8h11.303c-1.087 3.109-3.293 5.558-6.074 7.017l.001-.001 6.363 5.375C33.117 41.346 38 38 40.95 33.05 42.262 30.773 43 27.995 43 24c0-1.341-.138-2.653-.389-3.917z"/>'
      '</svg>';
  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(_gSvg, width: 20, height: 20);
  }
}


