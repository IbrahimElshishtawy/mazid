import 'package:flutter/material.dart';

class InrtoPage3 extends StatelessWidget {
  final Color textColor;

  const InrtoPage3({super.key, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Your text here',
            style: TextStyle(
              fontSize: 26,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
