// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mazid/pages/spa/widget/CurvedTopClipper.dart';

class IntroPage2 extends StatelessWidget {
  final Color textColor;
  const IntroPage2({super.key, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 240,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0D47A1), Color(0xFF4A148C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),

            Positioned(
              top: 20,
              right: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.deepPurple.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.indigo.withOpacity(0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  const Icon(Icons.nights_stay, color: Colors.white, size: 90),
                ],
              ),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    "asset/animation/intro2.json",
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Experience Next-Level Trading",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A148C),
                      shadows: [
                        Shadow(
                          blurRadius: 6,
                          color: Colors.black45,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "Smart, fast, and secure auctions.",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0D47A1),
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
