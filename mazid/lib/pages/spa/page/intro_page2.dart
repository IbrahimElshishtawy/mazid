// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';

class IntroPage2 extends StatefulWidget {
  final Color textColor;
  const IntroPage2({super.key, required this.textColor});

  @override
  State<IntroPage2> createState() => _IntroPage2State();
}

class _IntroPage2State extends State<IntroPage2> {
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
          /// خلفية موجات متحركة (برتقالي + أصفر) تتحرك مع الجهاز
          Positioned.fill(
            child: WaveWidget(
              config: CustomConfig(
                gradients: [
                  [Colors.orange, Colors.yellow],
                  [Colors.deepOrangeAccent, Colors.amber],
                ],
                durations: [30000, 19000],
                heightPercentages: [0.20, 0.23],
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
                    "Enjoy the Experience",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: widget.textColor.withOpacity(0.95),
                      shadows: const [
                        Shadow(
                          blurRadius: 12,
                          color: Colors.deepOrange,
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
                  child: Text(
                    "Smooth orange & yellow waves that move with you",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: widget.textColor.withOpacity(0.9),
                      shadows: const [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.orangeAccent,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
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
