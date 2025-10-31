import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.enabled = true,
  });

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
                    const Color(0xFFF09AA2).withValues(alpha: 0.5),
                    const Color(0xFF6BB6DF).withValues(alpha: 0.5),
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
                  color: enabled ? Colors.white : Colors.white.withValues(alpha: 0.7),
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
