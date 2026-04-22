import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:journal_app/app_strings.dart';
import 'package:journal_app/routes.dart';
import 'package:provider/provider.dart';

import '../viewmodels/auth_viewmodel.dart';
import 'widgets/circular_progress.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObscurePassword = true;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final vm = context.watch<AuthViewModel>();

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.welcome,
                    style: textTheme.bodyLarge?.copyWith(fontSize: 30.0),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    AppStrings.settle,
                    style: textTheme.bodyMedium?.copyWith(fontSize: 18),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: _userNameController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                      labelText: AppStrings.usernameOrEmail,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: _passwordController,
                    obscureText: isObscurePassword,
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                      labelText: AppStrings.password,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isObscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () => {
                          setState(() {
                            isObscurePassword = !isObscurePassword;
                          }),
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: FilledButton(
                      onPressed: vm.isLoginApiLoading
                          ? null
                          : () async {
                              final userName = _userNameController.text.trim();
                              final password = _passwordController.text;

                              if (userName.isEmpty || password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Username and password are required',
                                    ),
                                  ),
                                );
                                return;
                              }

                              final isSuccess = await vm.login(
                                userName: userName,
                                password: password,
                              );

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isSuccess
                                        ? ('Login Successful!')
                                        : (vm.loginErrorMessage ??
                                              'Login failed'),
                                  ),
                                ),
                              );

                              if (isSuccess) {
                                Navigator.pushReplacementNamed(context, Routes.home);
                              }
                            },
                      child: Text(AppStrings.login),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Text(AppStrings.or),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: AppStrings.newHere,
                        style: textTheme.bodyMedium?.copyWith(fontSize: 15),
                        children: [
                          TextSpan(
                            text: "  ${AppStrings.createAnAccount}",
                            style: textTheme.bodyMedium?.copyWith(
                              color: colors.primary,
                              fontSize: 15,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, Routes.signUp);
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Full-screen blocking loader
            if (vm.isLoginApiLoading) const CircularProgress(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

@Preview()
Widget loginScreenPreview() {
  return const MaterialApp(home: Scaffold(body: LoginScreen()));
}
