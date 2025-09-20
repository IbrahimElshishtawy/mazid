// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazid/core/cubit/auth/auth_cubit.dart';
import 'package:mazid/core/cubit/auth/auth_state.dart';
import 'package:mazid/pages/auth/animation/login_animation.dart';
import 'package:mazid/pages/auth/widget/from/register_form_fields.dart';
import 'package:mazid/pages/auth/widget/header/register_header.dart';
import 'package:mazid/pages/auth/widget/widget/register_terms.dart';
import 'package:mazid/pages/auth/widget/widget/success_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  bool agreeTerms = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _hideKeyboard() => FocusScope.of(context).unfocus();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: BackgroundAnimation(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is Authenticated) {
                  _hideKeyboard();
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => SuccessDialog(
                      onContinue: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                    ),
                  );
                } else if (state is AuthFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 20),
                    children: [
                      const RegisterHeader(),

                      RegisterFormFields(
                        nameController: nameController,
                        emailController: emailController,
                        passwordController: passwordController,
                        confirmPasswordController: confirmPasswordController,
                        phoneController: phoneController,
                      ),
                      const SizedBox(height: 10),
                      RegisterTerms(
                        agreeTerms: agreeTerms,
                        onChanged: (val) {
                          setState(() {
                            agreeTerms = val ?? false;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      state is AuthLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: () {
                                _hideKeyboard();
                                if (!_formKey.currentState!.validate()) return;

                                if (!agreeTerms) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("You must agree to terms"),
                                    ),
                                  );
                                  return;
                                }

                                if (passwordController.text.trim() !=
                                    confirmPasswordController.text.trim()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Passwords do not match"),
                                    ),
                                  );
                                  return;
                                }

                                context.read<AuthCubit>().register(
                                  name: nameController.text.trim(),
                                  email: emailController.text.trim(),
                                  phone: phoneController.text.trim(),
                                  password: passwordController.text.trim(),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text("Sign up"),
                            ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Text(
                          "Have an account? Log in",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
