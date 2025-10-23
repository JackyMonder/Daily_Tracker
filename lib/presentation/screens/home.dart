// Presentation home exports
import 'package:expenses_app/common/widgets/HorizontalWeekView.dart';
import 'package:flutter/material.dart';

import 'package:expenses_app/common/widgets/index.dart';
import 'package:expenses_app/common/widgets/NoteCards.dart';
import 'package:expenses_app/common/widgets/SidebarDrawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  
  // Sample data for notes dates - trong thực tế sẽ lấy từ database
  final List<DateTime> _notesDates = [
    DateTime.now(),
    DateTime.now().subtract(const Duration(days: 1)),
    DateTime.now().subtract(const Duration(days: 3)),
    DateTime.now().add(const Duration(days: 2)),
  ];

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

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
                // child: Text(
                //   "My Notes",
                //   style: TextStyle(
                //     fontSize: 36,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.white, // This color will be masked by the shader (To MASK, the color must be white)
                //   )
                // )
            ),
            const SizedBox(height: 16),
            // Horizontal Week View
            HorizontalWeekView(
              selectedDate: _selectedDate,
              onDateSelected: _onDateSelected,
              notesDates: _notesDates,
            ),
            const SizedBox(height: 20),
            // CommonWidgets().searchBar,
            Expanded(
              child: Notecards(selectedDate: _selectedDate),
            ),
          ],
        ),
      ),
      floatingActionButton: CommonWidgets().newNote,
      
        
      );
  }
}