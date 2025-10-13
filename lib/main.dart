import 'package:flutter/material.dart';
// Primary app export for compatibility with refactored lib/ layout
import 'presentation/screens/Home.dart';

void main() {
  runApp(const MyExpensesApp());
}

class MyExpensesApp extends StatelessWidget {
  const MyExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}