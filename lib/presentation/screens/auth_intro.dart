import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import '../../shared/widgets/index.dart';

class AuthIntroScreen extends StatelessWidget {
  const AuthIntroScreen({super.key});

  static const routeName = '/auth-intro';

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
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
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Let's Get Started!",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                      ),
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
                    // Wrap để tránh tràn trên màn hình nhỏ
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text("Don't have a account?", style: theme.textTheme.bodyMedium),
                        TextButton(
                          onPressed: () => Navigator.of(context).pushNamed('/signup'),
                          child: Text('Sign up', style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFFD55C6A))),
                        ),
                      ],
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pushNamed('/'),
                        child: Text('Continue as a guest', style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFFD55C6A))),
                      ),
                    ),
                    // Thêm khoảng trống nhỏ thay vì Spacer để tránh tràn màn hình
                    const SizedBox(height: 24),
                    // Wrap để tránh tràn trên màn hình nhỏ
                    Wrap(
                      alignment: WrapAlignment.spaceEvenly,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
