import 'package:flutter/material.dart';

class MailIconButton extends StatelessWidget {
  const MailIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 65, 191, 250),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(Icons.mail, color: Colors.white, size: 30),
        onPressed: () {
          // Handle mail button press
        },
      ),
    );
  }
}