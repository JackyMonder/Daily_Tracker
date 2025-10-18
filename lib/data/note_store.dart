import 'package:flutter/material.dart';

/// Simple in-memory note store using a ValueNotifier so widgets can listen
/// for changes. This is intentionally small and dependency-free for demo.
class NoteStore {
  NoteStore._internal();
  static final NoteStore instance = NoteStore._internal();

  /// Each note: { 'title': String, 'blocks': List<Map<String,String>> }
  /// block: { 'type': 'text'|'image', 'data': '...' }
  final ValueNotifier<List<Map<String, dynamic>>> notes = ValueNotifier([
    {
      'title': 'Meeting Notes',
      'blocks': [
        {'type': 'text', 'data': 'Discuss project timeline and deliverables.'},
        {'type': 'image', 'data': ''},
      ],
    },
    {
      'title': 'Grocery List',
      'blocks': [
        {'type': 'text', 'data': 'Milk, Eggs, Bread, Butter, Fruits.'},
      ],
    },
    {
      'title': 'Workout Plan',
      'blocks': [
        {'type': 'text', 'data': 'Monday: Cardio, Wednesday: Strength Training, Friday: Yoga.'},
      ],
    },
  ]);

  void addNote(Map<String, dynamic> note) {
    final current = List<Map<String, dynamic>>.from(notes.value);
    current.add(note);
    notes.value = current;
  }

  void updateNote(int index, Map<String, dynamic> note) {
    final current = List<Map<String, dynamic>>.from(notes.value);
    if (index >= 0 && index < current.length) {
      current[index] = note;
      notes.value = current;
    }
  }

  void removeNote(int index) {
    final current = List<Map<String, dynamic>>.from(notes.value);
    if (index >= 0 && index < current.length) {
      current.removeAt(index);
      notes.value = current;
    }
  }
}
