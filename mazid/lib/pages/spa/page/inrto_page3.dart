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
  StreamSubscription? _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      setState(() {
        x = (event.x / 20).clamp(-0.5, 0.5);
        y = (event.y / 20).clamp(-0.5, 0.5);
      });
    });
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
          /// خلفية (Purple × Blue)
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

          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 5),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 140,
                      color: Colors.deepPurple, // لون الخلفية اللي انت عايزه
                      child: Image.asset(
                        "asset/image/intro3.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// النصوص
                Text(
                  "Start Your Journey",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Connect, explore, and enjoy shopping like never before.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: widget.textColor.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const Spacer(flex: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
