
import 'package:flutter/material.dart';

class LogoTextWidget extends StatelessWidget {
  final Animation<double> animation;
  const LogoTextWidget({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: const Text(
        "Mazid Shop",
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }
}