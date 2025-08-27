import 'package:flutter/material.dart';

class RegisterFormFields extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  const RegisterFormFields({
    super.key,

    required this.emailController,
    required this.passwordController,

    required this.formKey,
  });

  @override
  State<RegisterFormFields> createState() => _RegisterFormFieldsState();
}

class _RegisterFormFieldsState extends State<RegisterFormFields> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          // Email
          TextFormField(
            controller: widget.emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Email",
              filled: true,
              fillColor: Colors.white,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Enter your email";
              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return "Enter a valid email";
              }
              return null;
            },
          ),
          const SizedBox(height: 15),

          // Password
          TextFormField(
            controller: widget.passwordController,
            decoration: const InputDecoration(
              labelText: "Password",
              filled: true,
              fillColor: Colors.white,
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Enter your password";
              } else if (value.length < 6) {
                return "Password must be at least 6 characters";
              }
              return null;
            },
          ),
          const SizedBox(height: 15),

          // Confirm Password
          TextFormField(
            controller: widget.confirmPasswordController,
            decoration: const InputDecoration(
              labelText: "Confirm Password",
              filled: true,
              fillColor: Colors.white,
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Confirm your password";
              } else if (value != widget.passwordController.text) {
                return "Passwords do not match";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
