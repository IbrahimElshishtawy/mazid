import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mazid/core/models/user_model.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

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
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  UserModel getUserModel() {
    return UserModel(
      id: UniqueKey().toString(),
      name: widget.nameController.text.trim(),
      email: widget.emailController.text.trim(),
      phone: widget.phoneController.text.trim(),
      avatar: "",
      password: '',
      imageUrl: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Name
        TextFormField(
          controller: widget.nameController,
          decoration: const InputDecoration(
            labelText: "Full Name ",
            filled: true,
          ),
          validator: (value) =>
              value == null || value.isEmpty ? "Enter your name" : null,
        ),
        const SizedBox(height: 30),

        // Phone
        IntlPhoneField(
          controller: widget.phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone',
            border: OutlineInputBorder(),
            filled: true,
          ),
          initialCountryCode: 'EG', // الدولة الافتراضية، ممكن تغيرها
          onChanged: (phone) {
            if (kDebugMode) {
              print(phone.completeNumber);
            } // الرقم كامل مع كود الدولة
          },
          validator: (value) {
            if (value == null || value.number.isEmpty) {
              return 'Enter your phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

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
        const SizedBox(height: 20),

        // Password
        TextFormField(
          controller: widget.passwordController,
          decoration: InputDecoration(
            labelText: "Password",
            filled: true,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          obscureText: _obscurePassword,
          validator: (value) =>
              value == null || value.isEmpty ? "Enter your password" : null,
        ),
        const SizedBox(height: 20),

        // Confirm Password
        TextFormField(
          controller: widget.confirmPasswordController,
          decoration: InputDecoration(
            labelText: "Confirm Password",
            filled: true,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ),
          obscureText: _obscureConfirmPassword,
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
