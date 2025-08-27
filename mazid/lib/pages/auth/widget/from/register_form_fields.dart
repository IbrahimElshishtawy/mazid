import 'package:flutter/material.dart';

class RegisterFormFields extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const RegisterFormFields({
    super.key,
    required this.phoneController,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: phoneController,
          decoration: const InputDecoration(
            labelText: "Phone",
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: "Name",
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) => value!.isEmpty ? "Enter your name" : null,
        ),
        const SizedBox(height: 15),

        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: "Email",
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) => value!.isEmpty ? "Enter your email" : null,
        ),
        const SizedBox(height: 15),

        TextFormField(
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: "Password",
            filled: true,
            fillColor: Colors.white,
          ),
          obscureText: true,
          validator: (value) => value!.isEmpty ? "Enter your password" : null,
        ),
        const SizedBox(height: 15),

        TextFormField(
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: "Confirm Password",
            filled: true,
            fillColor: Colors.white,
          ),
          obscureText: true,
          validator: (value) => value!.isEmpty ? "Confirm your password" : null,
        ),
      ],
    );
  }
}
