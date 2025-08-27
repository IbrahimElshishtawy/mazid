import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hajzi/pages/auth/animation/login_animation.dart';
import 'package:hajzi/pages/auth/google/login_social_buttons.dart';
import 'package:hajzi/pages/auth/widget/login_footer.dart';
import 'package:hajzi/pages/auth/widget/from/login_form.dart';
import 'package:hajzi/pages/auth/widget/header/login_header.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/auth/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true;

  void _hideKeyboard() => FocusScope.of(context).unfocus();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    }
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(value)) {
      return "Invalid email format";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundAnimation(
        child: SafeArea(
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
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      const SizedBox(height: 50),
                      const LoginHeader(),
                      const SizedBox(height: 30),
                      LoginSocialButtons(),
                      const SizedBox(height: 20),
                      LoginForm(
                        emailController: emailController,
                        passwordController: passwordController,
                        obscurePassword: _obscurePassword,
                        onTogglePassword: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        validateEmail: _validateEmail,
                      ),
                      const SizedBox(height: 20),
                      LoginFooter(
                        onLogin: () {
                          if (_formKey.currentState!.validate()) {
                            _hideKeyboard();
                            context.read<AuthCubit>().login(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );
                          }
                        },
                        isLoading: state is AuthLoading,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
