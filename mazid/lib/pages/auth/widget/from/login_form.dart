import 'package:flutter/material.dart';

class LoginFormFields extends StatelessWidget {
  final TextEditingController emailController; // للإيميل فقط
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;

  const LoginFormFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
  });

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Enter your email";

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return "Enter a valid email";

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Enter your password";
    if (value.length < 6) return "Password must be at least 6 characters";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      labelStyle: const TextStyle(color: Colors.white70),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),

        // Email
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          style: const TextStyle(color: Colors.white),
          decoration: inputDecoration.copyWith(labelText: "Email"),
          validator: _validateEmail,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),

        const SizedBox(height: 20),

        // Password
        TextFormField(
          controller: passwordController,
          obscureText: obscurePassword,
          textInputAction: TextInputAction.done,
          style: const TextStyle(color: Colors.white),
          decoration: inputDecoration.copyWith(
            labelText: "Password",
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.white70,
              ),
              onPressed: onTogglePassword,
            ),
          ),
          validator: _validatePassword,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }
}
