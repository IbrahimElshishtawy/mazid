// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';

class IntroPage3 extends StatefulWidget {
  final Color textColor;
  const IntroPage3({super.key, required this.textColor});

  @override
  State<IntroPage3> createState() => _IntroPage3State();
}

class _IntroPage3State extends State<IntroPage3> {
  double x = 0.0;
  double y = 0.0;
  StreamSubscription? _gyroscopeSubscription;

  @override
  void initState() {
    super.initState();

    try {
      _gyroscopeSubscription = accelerometerEvents.listen((event) {
        setState(() {
          x = (event.x / 20).clamp(-0.5, 0.5);
          y = (event.y / 20).clamp(-0.5, 0.5);
        });
      });
    } catch (e) {
      debugPrint("Accelerometer not available: $e");
    }
  }

  @override
  void dispose() {
    _gyroscopeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// خلفية موجات (بنفسجي/أزرق) تتحرك مع الجهاز
          Positioned.fill(
            child: WaveWidget(
              config: CustomConfig(
                gradients: [
                  [Colors.deepPurple, Colors.indigo],
                  [Colors.blueAccent, Colors.purpleAccent],
                ],
                durations: [25000, 18000],
                heightPercentages: [0.18, 0.22],
                blur: const MaskFilter.blur(BlurStyle.solid, 5),
                gradientBegin: Alignment(-1 + x, 1 + y),
                gradientEnd: Alignment(1 + x, -1 + y),
              ),
              backgroundColor: Colors.black,
              size: const Size(double.infinity, double.infinity),
              waveAmplitude: 0,
            ),
          ),

          /// النصوص
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 4),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Your new best friend is just a swipe away!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: widget.textColor.withOpacity(0.95),
                      letterSpacing: 1.3,
                      shadows: const [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black87,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        "Find the perfect match for your lifestyle",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: widget.textColor.withOpacity(0.9),
                          shadows: const [
                            Shadow(
                              blurRadius: 8,
                              color: Colors.black54,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Adopt, connect, and start your journey now",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: widget.textColor.withOpacity(0.85),
                          shadows: const [
                            Shadow(
                              blurRadius: 8,
                              color: Colors.black54,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
