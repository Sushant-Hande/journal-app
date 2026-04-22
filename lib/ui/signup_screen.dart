import 'package:flutter/material.dart';
import '../app_strings.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    bool isObscurePassword = true;

    return SafeArea(
      child: Scaffold(
        body: Padding(
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
                  onPressed: () => {},
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
                    style: textTheme.bodyMedium?.copyWith(color: colors.primary, fontSize: 15),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
