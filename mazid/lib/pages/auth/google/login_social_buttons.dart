// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hajzi/pages/auth/google/auth_service.dart';

class LoginSocialButtons extends StatelessWidget {
  final AuthService _authService = AuthService(); // عمل instance هنا

  LoginSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            try {
              await _authService.signInWithGoogle();
              Navigator.pushReplacementNamed(context, '/home');
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('فشل تسجيل الدخول بجوجل: $e')),
              );
            }
          },
          icon: const Icon(Icons.g_mobiledata),
          label: const Text("Google"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color.fromARGB(255, 209, 45, 45),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () {
            // TODO: Facebook Sign-In
          },
          icon: const Icon(Icons.facebook),
          label: const Text("Facebook"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color.fromARGB(255, 22, 7, 221),
          ),
        ),
      ],
    );
  }
}
