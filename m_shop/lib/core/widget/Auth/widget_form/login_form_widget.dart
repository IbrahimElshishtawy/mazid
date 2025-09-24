import 'package:flutter/material.dart';
import 'package:m_shop/core/widget/Auth/widget_form/login_form.dart';
import 'package:m_shop/core/widget/Auth/widget_header/login_footer.dart';
import 'package:m_shop/core/widget/Auth/widget_header/login_header.dart';

class LoginFormWidget extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onLoginPressed;
  final bool isLoading;
  final AnimationController animController;

  const LoginFormWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onLoginPressed,
    required this.isLoading,
    required this.animController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        child: ListView(
          children: [
            const SizedBox(height: 50),
            const LoginHeader(),
            const SizedBox(height: 30),
            LoginFormFields(
              emailController: emailController,
              passwordController: passwordController,
              obscurePassword: obscurePassword,
              onTogglePassword: onTogglePassword,
            ),
            const SizedBox(height: 20),
            AnimatedLoginButton(
              animController: animController,
              onPressed: onLoginPressed,
              isLoading: isLoading,
              theme: Theme.of(context),
            ),
            const SizedBox(height: 15),
            const LoginFooter(),
          ],
        ),
      ),
    );
  }
}
