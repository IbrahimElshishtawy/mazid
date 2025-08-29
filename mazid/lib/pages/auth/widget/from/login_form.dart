import 'package:flutter/material.dart';

class LoginFormFields extends StatelessWidget {
  final TextEditingController identifierController; // للإيميل أو الهاتف
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;

  const LoginFormFields({
    super.key,
    required this.identifierController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
  });

  String? _validateIdentifier(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter your email or phone number";
    }

    if (value.contains('@')) {
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
      if (!emailRegex.hasMatch(value)) {
        return "Enter a valid email";
      }
    } else {
      final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
      if (!phoneRegex.hasMatch(value)) {
        return "Enter a valid phone number";
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        // Email or Phone
        TextFormField(
          controller: identifierController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: "Email or Phone",
            labelStyle: const TextStyle(color: Colors.white70),
            filled: true,
            fillColor: const Color(0xFF2C2C2C),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          validator: _validateIdentifier,
        ),
        const SizedBox(height: 40),

        // Password
        TextFormField(
          controller: passwordController,
          obscureText: obscurePassword,
          textInputAction: TextInputAction.done,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: "Password",
            labelStyle: const TextStyle(color: Colors.white70),
            filled: true,
            fillColor: const Color(0xFF2C2C2C),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.white70,
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
