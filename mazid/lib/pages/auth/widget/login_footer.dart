import 'package:flutter/material.dart';

class LoginFooter extends StatelessWidget {
  final VoidCallback onLogin;
  final bool isLoading;

  const LoginFooter({
    super.key,
    required this.onLogin,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                onPressed: onLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Login", style: TextStyle(fontSize: 16)),
              ),
        const SizedBox(height: 35),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't have an account? ",
              style: TextStyle(color: Colors.black87),
            ),

            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text(
                "Join us",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline, // خط ت
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
