import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'presentation/screens/home.dart';
import 'presentation/screens/login.dart';
import 'presentation/screens/signup.dart';
import 'presentation/screens/auth_intro.dart';
import 'presentation/screens/note_editor.dart';
import 'presentation/screens/settings.dart';
import 'core/routes/routes.dart';
import 'firebase_options.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const DailyTrackerApp());
}

class DailyTrackerApp extends StatelessWidget {
  const DailyTrackerApp({super.key});

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
        Routes.noteEditor: (context) => const NoteEditorScreen(),
        Routes.settings: (_) => const SettingsScreen(),
      },
    );
  }
}
