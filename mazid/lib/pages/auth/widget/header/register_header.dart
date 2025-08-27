import 'package:flutter/material.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 50),
        Text(
          "Join us to start searching",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          "You can search courses, apply courses and find scholarship for abroad studies",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70),
        ),
        SizedBox(height: 50),
      ],
    );
  }
}
