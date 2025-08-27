// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hajzi/cubits/auth/auth_cubit.dart';
import 'package:hajzi/cubits/auth/auth_state.dart';
import 'package:hajzi/pages/auth/animation/login_animation.dart';
import 'package:hajzi/pages/auth/google/register_social_buttons.dart';
import 'package:hajzi/pages/auth/widget/from/register_form_fields.dart';

import 'package:hajzi/pages/auth/widget/header/register_header.dart';

import 'package:hajzi/pages/auth/widget/register_terms.dart';

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
  bool agreeTerms = false;

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
                if (state is AuthSuccess) {
                  Navigator.pushReplacementNamed(context, '/home');
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
                    children: [
                      const RegisterHeader(),
                      RegisterSocialButtons(),
                      SizedBox(height: 20),
                      RegisterFormFields(
                        nameController: nameController,
                        emailController: emailController,
                        passwordController: passwordController,
                      ),
                      const SizedBox(height: 10),
                      RegisterTerms(
                        agreeTerms: agreeTerms,
                        onChanged: (val) {
                          setState(() {
                            agreeTerms = val!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      state is AuthLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate() &&
                                    agreeTerms) {
                                  context.read<AuthCubit>().register(
                                    name: nameController.text.trim(),
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );
                                }
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
