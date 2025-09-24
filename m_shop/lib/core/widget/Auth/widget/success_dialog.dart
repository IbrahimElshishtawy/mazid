import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final VoidCallback onContinue;

  const SuccessDialog({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 4, 3, 3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.check_circle, color: Colors.green, size: 80),
          SizedBox(height: 20),
          Text(
            "Account created successfully!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 254, 254, 255),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onContinue,
          child: const Text("Continue", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
