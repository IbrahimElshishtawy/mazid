// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazid/core/cubit/auth/auth_cubit.dart';
import 'package:mazid/core/cubit/auth/auth_state.dart';
import 'package:mazid/core/data/admin_data.dart';
import 'package:mazid/pages/auth/OTP/Otp_Verification_Page.dart';
import 'package:mazid/pages/auth/animation/login_animation.dart';
import 'package:mazid/pages/auth/widget/from/login_form.dart';
import 'package:mazid/pages/auth/widget/header/login_header.dart';
import 'package:mazid/pages/auth/widget/login_footer.dart';
import 'package:mazid/pages/home/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final identifierController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _hideKeyboard() => FocusScope.of(context).unfocus();
  void _login() {
    final identifier = identifierController.text.trim();
    final password = passwordController.text.trim();

    // تسجيل دخول Admin
    if (identifier == AdminData.email && password == AdminData.password) {
      _hideKeyboard();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      _hideKeyboard();

      final isEmail = identifier.contains('@');

      if (isEmail) {
        // تسجيل الدخول عبر البريد
        context.read<AuthCubit>().loginWithEmail(
          email: identifier,
          password: password,
        );
      } else {
        // تسجيل الدخول عبر الهاتف
        context.read<AuthCubit>().loginWithPhone(identifier);

        // الاستماع لحالة AuthOtpSent للتوجه لشاشة إدخال الكود
        context.read<AuthCubit>().stream.listen((state) {
          if (state is AuthOtpSent) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OtpVerificationPage(phone: state.phone),
              ),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: GestureDetector(
        onTap: _hideKeyboard,
        child: BackgroundAnimation(
          child: SafeArea(
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is Authenticated) {
                  Navigator.pushReplacementNamed(context, '/home');
                } else if (state is AuthFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        const SizedBox(height: 50),
                        const LoginHeader(),
                        const SizedBox(height: 30),
                        LoginFormFields(
                          identifierController: identifierController,
                          passwordController: passwordController,
                          obscurePassword: _obscurePassword,
                          onTogglePassword: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        state is AuthLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.primaryColor,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text("Login"),
                              ),
                        const SizedBox(height: 15),
                        const LoginFooter(),
                      ],
                    ),
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
