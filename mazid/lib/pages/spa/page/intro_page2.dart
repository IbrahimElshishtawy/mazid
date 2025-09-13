import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatelessWidget {
  final Color textColor;
  const IntroPage2({super.key, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // خلفية بيضاء
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// الانيميشن
              Lottie.asset(
                "asset/animation/intro2.json",
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 40),

              /// العنوان
              Text(
                "Feel the Vibe",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  shadows: const [
                    Shadow(
                      blurRadius: 6,
                      color: Colors.orangeAccent,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              /// النص الفرعي
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "A seamless blend of technology and lifestyle,\n designed just for you.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
