import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key, required this.textColor});

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // خلفية شفافة
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// الانيميشن في النص
              Lottie.asset(
                'asset/animation/intro1animation.json',
                width: 290,
                height: 290,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 30),

              /// النص الترحيبي
              Text(
                "Welcome to Mazid Store",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  shadows: const [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.orange,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              /// النص الفرعي
              Text(
                "Your first step into a smarter shopping experience.",
                style: TextStyle(
                  fontSize: 16,
                  color: textColor.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
