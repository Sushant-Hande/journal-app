import 'package:flutter/material.dart';
import 'package:journal_app/routes.dart';
import 'package:journal_app/theme.dart';
import 'package:journal_app/ui/login_screen.dart';
import 'package:journal_app/ui/signup_screen.dart';
import 'package:journal_app/util.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Roboto", "Montserrat");

    MaterialTheme materialTheme = MaterialTheme(textTheme);

    return MaterialApp(
      routes: {
        Routes.login: (context) => const LoginScreen(),
        Routes.signUp: (context) => const SignupScreen(),
      },
      theme: brightness == Brightness.light ? materialTheme.light() : materialTheme.light(),
      home: const LoginScreen(),
    );
  }
}
