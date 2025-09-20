import 'package:flutter/material.dart';

class RegisterTerms extends StatelessWidget {
  final bool agreeTerms;
  final ValueChanged<bool?> onChanged;

  const RegisterTerms({
    super.key,
    required this.agreeTerms,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: agreeTerms, onChanged: onChanged),
        const Expanded(
          child: Text(
            "I agree with the Terms of Service & Privacy Policy",
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
