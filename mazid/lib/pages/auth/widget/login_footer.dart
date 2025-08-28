import 'package:flutter/material.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({
    super.key,
    required Null Function() onLogin,
    required bool isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
