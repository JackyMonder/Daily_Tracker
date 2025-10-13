// Presentation home exports
import 'package:flutter/material.dart';

import 'package:expenses_app/common/widgets/index.dart';
import 'package:expenses_app/utils/notesection.dart';

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
          children: [
            NotesSection(),
          ],
        ),
      ),
    );
  }
}