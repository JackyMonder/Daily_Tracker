import 'package:flutter/material.dart';

class MenuIconButton extends StatelessWidget {
  const MenuIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF09AA2),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(Icons.menu, color: Colors.white, size: 30),
        onPressed: () {
          // Handle menu button press
        },
      ),
    );
  }
}