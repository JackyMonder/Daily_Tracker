// Missing Search Methods

import 'package:flutter/material.dart';

class Searchbar extends StatelessWidget {
  const Searchbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ShaderMask(shaderCallback: (bounds) => LinearGradient(
        colors: [Color.fromARGB(255, 255, 155, 243),
          Color.fromARGB(255, 65, 191, 250)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
            border: BoxBorder.all(
              color: Colors.white,
              width: 1,
            ),
          ),
          child: Row (children: [
            Icon(
              Icons.search,
              color: Colors.white,
              size: 36,
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Notes',                  
                  hintStyle: TextStyle(fontSize: 20, color: Colors.grey[200]),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
          ],)
        )
      ),
    );
  }
}