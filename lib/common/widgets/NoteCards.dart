// import 'dart:ffi';

import 'package:flutter/material.dart';

import '../../utils/notesection.dart';

class Notecards extends StatefulWidget {
  final DateTime? selectedDate;
  
  const Notecards({super.key, this.selectedDate});

  @override
  State<Notecards> createState() => _NotecardsState();
}
  class _NotecardsState extends State<Notecards> {
    // Sample data for cards with creation dates
    final List<Map<String, dynamic>> _allCardData = [
    {
      'title': 'Meeting Notes',
      'content': 'Discuss project timeline and deliverables.',
      'createdAt': DateTime.now(),
    },
    {
      'title': 'Grocery List',
      'content': 'Milk, Eggs, Bread, Butter, Fruits.',
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'title': 'Workout Plan',
      'content': 'Monday: Cardio, Wednesday: Strength Training, Friday: Yoga.',
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'title': 'Team Meeting',
      'content': 'Discuss project timeline and deliverables.',
      'createdAt': DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      'title': 'Dating',
      'content': 'Hang around with girl on Tinder',
      'createdAt': DateTime.now().add(const Duration(days: 1)),
    },
    {
      'title': 'Greeting',
      'content': 'Hello Youtube !',
      'createdAt': DateTime.now().add(const Duration(days: 2)),
    },
    {
      'title': 'Hello World !',
      'content': 'This is a sample note content',
      'createdAt': DateTime.now().add(const Duration(days: 3)),
    },
  ];

  List<Map<String, dynamic>> get _filteredCardData {
    if (widget.selectedDate == null) return _allCardData;
    
    return _allCardData.where((card) {
      DateTime createdAt = card['createdAt'] as DateTime;
      return createdAt.year == widget.selectedDate!.year &&
             createdAt.month == widget.selectedDate!.month &&
             createdAt.day == widget.selectedDate!.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = _filteredCardData;
    return SafeArea(
        child: filteredData.isEmpty
        ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.note_outlined,
                size: 64,
                color: Colors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                widget.selectedDate != null 
                    ? "No notes for ${_formatDate(widget.selectedDate!)}"
                    : "No Notes Available",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ) 
        : ListView.builder(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
          itemCount: filteredData.length,
          itemBuilder: (context, index) {
            return Notesection(
              noteTitle: (filteredData[index]['title'] as String?) ?? 'Untitled',
              noteContent: (filteredData[index]['content'] as String?) ?? 'No Content',
              // color: filteredData[index]['color'] as Color ?? ,
            );
          },
        ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}