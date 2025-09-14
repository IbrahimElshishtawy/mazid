import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatelessWidget {
  final Color textColor;
  const IntroPage3({super.key, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0), // خلفية بروفيشنال
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ),
            Positioned(
              top: -70,
              right: -70,
              child: Container(
                width: 180,
                height: 180,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.pinkAccent,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    "asset/animation/intro3.json",
                    width: 330,
                    height: 330,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 40),

                  Text(
                    "Start Your Journey",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // ابيض
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.deepPurpleAccent,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "Connect, explore, and enjoy shopping like never before.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
