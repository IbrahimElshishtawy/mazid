import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final String? Function(String?) validateEmail;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.validateEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: emailController,
          validator: validateEmail,
          decoration: const InputDecoration(
            labelText: "Email",
            prefixIcon: Icon(
              Icons.email,
              color: Color.fromARGB(212, 254, 254, 255),
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: passwordController,
          obscureText: obscurePassword,
          validator: (v) => v!.isEmpty ? "Please enter your password" : null,
          decoration: InputDecoration(
            labelText: "Password",
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: onTogglePassword,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/forgot-password');
            },
            child: const Text(
              "Forgot password",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
