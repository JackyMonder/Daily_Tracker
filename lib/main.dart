import 'package:flutter/material.dart';
// Primary app export for compatibility with refactored lib/ layout
import 'presentation/screens/home.dart';
import 'presentation/screens/login.dart';
import 'presentation/screens/signup.dart';
import 'presentation/screens/auth_intro.dart';
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
      initialRoute: Routes.authIntro,
      routes: {
        Routes.home: (_) => const HomeScreen(),
        Routes.login: (_) => const LoginScreen(),
        Routes.signup: (_) => const SignUpScreen(),
        Routes.authIntro: (_) => const AuthIntroScreen(),
      },
    );
  }
}