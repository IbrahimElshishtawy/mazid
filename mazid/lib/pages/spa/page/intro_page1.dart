// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';

class IntroPage1 extends StatefulWidget {
  final Color textColor;
  const IntroPage1({super.key, required this.textColor});

  @override
  State<IntroPage1> createState() => _IntroPage1State();
}

class _IntroPage1State extends State<IntroPage1> {
  double x = 0.0;
  double y = 0.0;
  StreamSubscription? _accelerometerSubscription;

  @override
  void initState() {
    super.initState();

    try {
      _accelerometerSubscription = accelerometerEvents.listen((event) {
        setState(() {
          // نخلي القيم صغيرة عشان تكون حركة ناعمة
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
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// خلفية موجات متحركة مع ألوان برتقالي وأصفر + تتحرك مع الجهاز
          Positioned.fill(
            child: WaveWidget(
              config: CustomConfig(
                gradients: [
                  [Colors.orange, Colors.yellow],
                  [Colors.deepOrangeAccent, Colors.amber],
                ],
                durations: [35000, 19440],
                heightPercentages: [0.20, 0.23],
                blur: const MaskFilter.blur(BlurStyle.solid, 5),
                // نخلي الجريدينت يتحرك مع الجهاز
                gradientBegin: Alignment(-1 + x, 1 + y),
                gradientEnd: Alignment(1 + x, -1 + y),
              ),
              backgroundColor: Colors.black,
              size: const Size(double.infinity, double.infinity),
              waveAmplitude: 0,
            ),
          ),

          /// النصوص والعناصر
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),

                // أيقونة أو صورة
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'asset/icon/iconimage.jpg',
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // العنوان
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Welcome to Mazid Store",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: widget.textColor.withOpacity(0.95),
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
                ),

                const SizedBox(height: 12),

                // النص الفرعي
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "your step one more and enjoy to pay",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: widget.textColor.withOpacity(0.9),
                      shadows: const [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.orangeAccent,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const Spacer(flex: 3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
