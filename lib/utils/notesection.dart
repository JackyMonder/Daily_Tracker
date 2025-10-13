import 'package:flutter/material.dart';

import 'package:expenses_app/common/widgets/index.dart';

class NotesSection extends StatelessWidget {
  const NotesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
            colors: [Color.fromARGB(255, 255, 155, 243), Color.fromARGB(255, 65, 191, 250)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
            child: Text(
              "My Notes",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white, // This color will be masked by the shader
              )
            )
          )
        ],
      )
    );
  }
}