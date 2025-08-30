import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  final String text;
  const BannerWidget(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Colors.orange, Colors.deepOrange],
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
