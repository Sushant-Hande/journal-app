import 'package:flutter/material.dart';
import 'package:journal_app/theme.dart';
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
      theme: brightness == Brightness.light ? materialTheme.light() : materialTheme.dark(),
      home: Scaffold(
        body: Center(
          child: FilledButton(
            onPressed: () => {print('Button Clicked')},
            child: const Text('Hello World!'),
          ),
        ),
      ),
    );
  }
}
