import 'package:flutter/material.dart';
import 'package:journal_app/network/dio_client.dart';
import 'package:journal_app/presentation/ui/home_screen.dart';
import 'package:journal_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:journal_app/routes.dart';
import 'package:journal_app/theme.dart';
import 'package:journal_app/presentation/ui/login_screen.dart';
import 'package:journal_app/presentation/ui/signup_screen.dart';
import 'package:journal_app/util.dart';
import 'package:provider/provider.dart';

import 'data/repositories/auth_repository.dart';
import 'data/services/auth_api_service.dart';

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

    return MultiProvider(
      providers: [
        Provider(create: (_) => createDioClient()),
        Provider<AuthApiService>(
          create: (context) => AuthApiService(context.read()),
        ),
        Provider<AuthRepository>(
          create: (context) => AuthRepository(context.read()),
        ),
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) => AuthViewModel(context.read()),
        ),
      ],
      child: MaterialApp(
        routes: {
          Routes.login: (context) => const LoginScreen(),
          Routes.signUp: (context) => const SignupScreen(),
          Routes.home : (context) => const HomeScreen(),
        },
        theme: brightness == Brightness.light
            ? materialTheme.light()
            : materialTheme.light(),
        home: const LoginScreen(),
      ),
    );
  }
}
