// Presentation home exports
import 'package:flutter/material.dart';

import 'package:expenses_app/common/widgets/index.dart';
import 'package:expenses_app/common/widgets/NoteCards.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 100,
        leadingWidth: 100,
        backgroundColor: Colors.transparent, // This setted to show the measurent of the AppBar (otherwise it's transparent)
        leading: Padding (
          padding: const EdgeInsets.only(left: 20.0), 
          child: Row (
            children: [
              CommonWidgets().menuIconButton,
            ],
          )
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              children: [
                CommonWidgets().mailIconButton,
                SizedBox(width: 10),
                CommonWidgets().settingIconButton,
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
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
                    color: Colors.white, // This color will be masked by the shader (To MASK, the color must be white)
                  )
                )
              ),
            CommonWidgets().searchBar,
            Expanded(
              child: Notecards()
            )
          ],
        ),
      ),
    );
  }
}