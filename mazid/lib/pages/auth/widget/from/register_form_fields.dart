import 'package:flutter/material.dart';
import 'package:mazid/core/models/user_model.dart';

class RegisterFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const RegisterFormFields({
    super.key,
    required this.formKey,
    required TextEditingController emailController,
    required TextEditingController nameController,
    required TextEditingController passwordController,
  });

  @override
  State<RegisterFormFields> createState() => _RegisterFormFieldsState();
}

class _RegisterFormFieldsState extends State<RegisterFormFields> {
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  UserModel getUserModel() {
    return UserModel(
      id: UniqueKey().toString(),
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      avatar: "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          // Phone
          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: "Phone", filled: true),
            validator: (value) => value == null || value.isEmpty
                ? "Enter your phone number"
                : null,
          ),
          const SizedBox(height: 15),

          // Name
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Name", filled: true),
            validator: (value) =>
                value == null || value.isEmpty ? "Enter your name" : null,
          ),
          const SizedBox(height: 15),

          // Email
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: "Email", filled: true),
            validator: (value) {
              if (value == null || value.isEmpty) return "Enter your email";
              final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
              if (!emailRegex.hasMatch(value)) {
                return "Invalid email format";
              }
              return null;
            },
          ),
          const SizedBox(height: 15),

          // Password
          TextFormField(
            controller: passwordController,
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
            controller: confirmPasswordController,
            decoration: const InputDecoration(
              labelText: "Confirm Password",
              filled: true,
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Confirm your password";
              }
              if (value != passwordController.text) {
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
