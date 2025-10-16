// import 'dart:ffi';

import 'package:flutter/material.dart';

import '../../utils/notesection.dart';

class Notecards extends StatefulWidget {
  const Notecards({super.key});

  @override
  State<Notecards> createState() => _NotecardsState();
}
  class _NotecardsState extends State<Notecards> {
    // Sample data for cards
    final List<Map<String, dynamic>> _cardData = [
    {
      'title': 'Meeting Notes',
      'content': 'Discuss project timeline and deliverables.',
    },
    {
      'title': 'Grocery List',
      'content': 'Milk, Eggs, Bread, Butter, Fruits.',
    },
    {
      'title': 'Workout Plan',
      'content': 'Monday: Cardio, Wednesday: Strength Training, Friday: Yoga.',
    },
    {
      'title': 'Team Meeting',
      'content': 'Discuss project timeline and deliverables.',
    },
    {
      'title': 'Dating',
      'content': 'Hang around with girl on Tinder',
    },
    {
      // 'title': 'Greeting _1',
      'content': 'Hello Youtube !',
    },
    {
      'title': 'Hello World !',
      // 'content': 'Content _1'
    },
    {},
    {},
    {},
    {},
    {},
    {},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: _cardData.isEmpty
        ? const Center(
          child: Text("No Notes Available")
        ) 
        : GridView.builder(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: _cardData.length,
          itemBuilder: (context, index) {
            return Notesection(
              noteTitle: (_cardData[index]['title'] as String?) ?? 'Untitled',
              noteContent: (_cardData[index]['content'] as String?) ?? 'No Content',
              // color: _cardData[index]['color'] as Color ?? ,
            );
          },
        ),
    );
  }
}