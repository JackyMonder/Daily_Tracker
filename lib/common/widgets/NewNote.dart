import 'package:flutter/material.dart';
import 'package:expenses_app/core/routes/routes.dart';
import 'package:expenses_app/presentation/screens/note_editor.dart';

class NewNote extends StatelessWidget {
  const NewNote({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const NoteEditorScreen(),
            settings: const RouteSettings(name: Routes.noteEditor),
          ),
        );
      },
      child: SizedBox(
        width: 55,
        height: 55,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Gradient background applied only to the circular container
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Color(0xFFF09AA2), Color(0xFF6BB6DF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
            // Icon placed above, not affected by ShaderMask
            Icon(
              Icons.create,
              color: Colors.white,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}