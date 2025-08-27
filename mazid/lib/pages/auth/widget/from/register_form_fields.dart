import 'package:flutter/material.dart';
import 'package:mazid/core/models/user_model.dart';

// الفورم
class RegisterFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const RegisterFormFields({super.key, required this.formKey});

  @override
  State<RegisterFormFields> createState() => _RegisterFormFieldsState();
}

class _RegisterFormFieldsState extends State<RegisterFormFields> {
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // دالة بتكوّن userModel
  UserModel getUserModel() {
    return UserModel(
      id: UniqueKey().toString(), // مؤقت لحد ما يجي ID من Firebase
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      avatar: "", // ممكن تحط لينك صورة افتراضي
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
            decoration: const InputDecoration(
              labelText: "Phone",
              filled: true,
              fillColor: Colors.white,
            ),
            validator: (value) =>
                value!.isEmpty ? "Enter your phone number" : null,
          ),
          const SizedBox(height: 15),

          // Name
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

          // Email
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

          // Password
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

          // Confirm Password
          TextFormField(
            controller: confirmPasswordController,
            decoration: const InputDecoration(
              labelText: "Confirm Password",
              filled: true,
              fillColor: Colors.white,
            ),
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) return "Confirm your password";
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
