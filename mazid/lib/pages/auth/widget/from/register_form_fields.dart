import 'package:flutter/material.dart';
import 'package:mazid/core/models/user_model.dart';

class RegisterFormFields extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController nameController;
  final TextEditingController passwordController;
  final TextEditingController phoneController;
  final TextEditingController confirmPasswordController;

  const RegisterFormFields({
    super.key,
    required this.emailController,
    required this.nameController,
    required this.passwordController,
    required this.phoneController,
    required this.confirmPasswordController,
  });

  @override
  State<RegisterFormFields> createState() => _RegisterFormFieldsState();
}

class _RegisterFormFieldsState extends State<RegisterFormFields> {
  UserModel getUserModel() {
    return UserModel(
      id: UniqueKey().toString(),
      name: widget.nameController.text.trim(),
      email: widget.emailController.text.trim(),
      phone: widget.phoneController.text.trim(),
      avatar: "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Phone
        TextFormField(
          controller: widget.phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(labelText: "Phone", filled: true),
          validator: (value) =>
              value == null || value.isEmpty ? "Enter your phone number" : null,
        ),
        const SizedBox(height: 15),

        // Name
        TextFormField(
          controller: widget.nameController,
          decoration: const InputDecoration(labelText: "Name", filled: true),
          validator: (value) =>
              value == null || value.isEmpty ? "Enter your name" : null,
        ),
        const SizedBox(height: 15),

        // Email
        TextFormField(
          controller: widget.emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: "Email", filled: true),
          validator: (value) {
            if (value == null || value.isEmpty) return "Enter your email";
            final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
            if (!emailRegex.hasMatch(value)) return "Invalid email format";
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
          ),
          obscureText: true,
          validator: (value) =>
              value == null || value.isEmpty ? "Enter your password" : null,
        ),
        const SizedBox(height: 15),

        // Confirm Password
        TextFormField(
          controller: widget.confirmPasswordController,
          decoration: const InputDecoration(
            labelText: "Confirm Password",
            filled: true,
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) return "Confirm your password";
            if (value != widget.passwordController.text) {
              return "Passwords do not match";
            }
            return null;
          },
        ),
      ],
    );
  }
}
