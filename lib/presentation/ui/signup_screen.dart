import 'package:flutter/material.dart';
import 'package:journal_app/presentation/ui/widgets/circular_progress.dart';
import 'package:provider/provider.dart';
import '../../app_strings.dart';
import '../viewmodels/auth_viewmodel.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
                    AppStrings.createAccount,
                    style: textTheme.bodyLarge?.copyWith(fontSize: 30.0),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    AppStrings.stepInto,
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
                      onPressed: vm.isSignUpApiLoading
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

                              final isSuccess = await vm.signUp(
                                userName: userName,
                                password: password,
                              );

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isSuccess
                                        ? ('Account has been created!')
                                        : (vm.signUpErrorMessage ??
                                              'Signup failed'),
                                  ),
                                ),
                              );

                              if (isSuccess) {
                                Navigator.pop(context);
                              }
                            },
                      child: Text(AppStrings.signUp),
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
                    child: GestureDetector(
                      child: Text(
                        AppStrings.alreadyHaveAccount,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.primary,
                          fontSize: 15,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Full-screen blocking loader
            if (vm.isSignUpApiLoading) const CircularProgress(),
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
