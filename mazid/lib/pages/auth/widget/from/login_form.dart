import 'package:flutter/material.dart';

class LoginFormFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;

  const LoginFormFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required String? Function(String? value) validateEmail,
  });

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter your email";
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Email
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: "Email",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          validator: _validateEmail,
        ),
        const SizedBox(height: 15),

        // Password
        TextFormField(
          controller: passwordController,
          obscureText: obscurePassword,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: "Password",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: onTogglePassword,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter your password";
            } else if (value.length < 6) {
              return "Password must be at least 6 characters";
            }
            return null;
          },
        ),
      ],
    );
  }
}
