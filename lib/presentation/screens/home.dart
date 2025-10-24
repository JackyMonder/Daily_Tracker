// Presentation home exports
import 'package:expenses_app/common/widgets/HorizontalWeekView.dart';
import 'package:flutter/material.dart';

import 'package:expenses_app/common/widgets/index.dart';
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
            const SizedBox(height: 16),
            Expanded(
              child: HorizontalWeekView(
                selectedDate: _selectedDate,
                onDateSelected: _onDateSelected,
                notesDates: _notesDates,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CommonWidgets().newNote,
    );
  }
}