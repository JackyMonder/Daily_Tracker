// Presentation home exports
import 'package:flutter/material.dart';

import 'package:expenses_app/common/widgets/index.dart';
import 'package:expenses_app/common/widgets/NoteCards.dart';
import 'package:expenses_app/common/widgets/SidebarDrawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const SidebarDrawer(), // Thêm drawer vào Scaffold
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 75,
        leadingWidth: 100,
        backgroundColor: Colors.white, // Keep AppBar stable color when scrolling
        leading: Padding (
          padding: const EdgeInsets.only(left: 20.0, top: 20), 
          child: Row (
            children: [
              CommonWidgets().menuIconButton,
            ],
          )
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 20),
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
              colors: [Color(0xFFF09AA2), Color(0xFF6BB6DF)],
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
              child: Notecards(),
            ),
          ],
        ),
      ),
      floatingActionButton: CommonWidgets().newNote,
      
        
      );
  }
}