import 'package:flutter/material.dart';
// Primary app export for compatibility with refactored lib/ layout
import 'presentation/screens/Home.dart';
import 'presentation/screens/note_editor.dart';
import 'core/routes/routes.dart';

void main() {
  runApp(const MyExpensesApp());
}

class MyExpensesApp extends StatelessWidget {
  const MyExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.home,
      routes: {
        Routes.home: (context) => HomeScreen(),
        Routes.noteEditor: (context) => const NoteEditorScreen(),
      },
    );
  }
}