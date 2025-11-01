import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:firebase_core/firebase_core.dart';
import 'presentation/screens/login.dart';
import 'presentation/screens/signup.dart';
import 'presentation/screens/auth_intro.dart';
import 'presentation/screens/note_editor.dart';
import 'presentation/screens/settings.dart';
import 'presentation/widgets/auth_wrapper.dart';
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
      home: const AuthWrapper(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('vi', 'VN'),
      ],
      routes: {
        Routes.login: (_) => const LoginScreen(),
        Routes.signup: (_) => const SignUpScreen(),
        Routes.authIntro: (_) => const AuthIntroScreen(),
        Routes.noteEditor: (context) => const NoteEditorScreen(),
        Routes.settings: (_) => const SettingsScreen(),
      },
    );
  }
}
