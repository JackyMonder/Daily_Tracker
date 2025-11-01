import 'package:flutter/material.dart';
import 'package:daily_tracker/core/routes/routes.dart';

class SettingIconButton extends StatelessWidget {
  const SettingIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 163, 153, 250),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(Icons.settings, color: Colors.white, size: 30),
        onPressed: () {
          Navigator.pushNamed(context, Routes.settings);
        },
      ),
    );
  }
}