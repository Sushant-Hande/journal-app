import 'package:flutter/material.dart';
import 'package:journal_app/data/repositories/home_repository.dart';
import 'package:journal_app/network/dio_client.dart';
import 'package:journal_app/data/services/local_storage_service.dart';
import 'package:journal_app/presentation/ui/homescreen/home_screen.dart';
import 'package:journal_app/presentation/ui/profile_screen.dart';
import 'package:journal_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:journal_app/presentation/viewmodels/home_viewmodel.dart';
import 'package:journal_app/routes.dart';
import 'package:journal_app/theme.dart';
import 'package:journal_app/presentation/ui/login_screen.dart';
import 'package:journal_app/presentation/ui/signup_screen.dart';
import 'package:journal_app/util.dart';
import 'package:provider/provider.dart';

import 'data/repositories/auth_repository.dart';
import 'data/services/auth_api_service.dart';
import 'data/services/home_api_service.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Montserrat", "Montserrat");
    MaterialTheme materialTheme = MaterialTheme(textTheme);

    return MultiProvider(
      providers: [
        Provider<LocalStorageService>(create: (_) => LocalStorageService()),
        Provider(
          create: (context) =>
              createDioClient(context.read<LocalStorageService>()),
        ),
        Provider<AuthApiService>(
          create: (context) => AuthApiService(context.read()),
        ),
        Provider<AuthRepository>(
          create: (context) => AuthRepository(context.read()),
        ),
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) => AuthViewModel(
            context.read<AuthRepository>(),
            context.read<LocalStorageService>(),
          ),
        ),
        Provider<HomeApiService>(
          create: (context) => HomeApiService(context.read()),
        ),
        Provider<HomeRepository>(
          create: (context) => HomeRepository(context.read()),
        ),
        ChangeNotifierProvider<HomeViewmodel>(
          create: (context) => HomeViewmodel(
            context.read<HomeRepository>(),
            context.read<LocalStorageService>(),
          ),
        ),
      ],
      child: MaterialApp(
        routes: {
          Routes.login: (context) => const LoginScreen(),
          Routes.signUp: (context) => const SignupScreen(),
          Routes.home: (context) => const HomeScreen(),
          Routes.profile: (context) => const ProfileScreen(),
        },
        theme: brightness == Brightness.light
            ? materialTheme.light()
            : materialTheme.light(),
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Future<String?> _authTokenFuture;

  @override
  void initState() {
    super.initState();
    _authTokenFuture = context.read<LocalStorageService>().getAuthToken();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _authTokenFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final token = snapshot.data;
        if (token != null && token.isNotEmpty) {
          return const HomeScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
