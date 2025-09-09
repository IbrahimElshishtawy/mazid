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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// الخلفية (Orange × Yellow Waves) متحركة حسب accelerometer
          Positioned.fill(
            child: StreamBuilder<AccelerometerEvent>(
              stream: accelerometerEvents,
              builder: (context, snapshot) {
                final x = ((snapshot.data?.x ?? 0) / 20).clamp(-0.5, 0.5);
                final y = ((snapshot.data?.y ?? 0) / 20).clamp(-0.5, 0.5);

                return WaveWidget(
                  config: CustomConfig(
                    gradients: [
                      [Colors.orange, Colors.yellow],
                      [Colors.deepOrangeAccent, Colors.amber],
                    ],
                    durations: [35000, 19440],
                    heightPercentages: [0.20, 0.23],
                    blur: const MaskFilter.blur(BlurStyle.solid, 5),
                    gradientBegin: Alignment(-1 + x, 1 + y),
                    gradientEnd: Alignment(1 + x, -1 + y),
                  ),
                  backgroundColor: Colors.black,
                  size: const Size(double.infinity, double.infinity),
                  waveAmplitude: 0,
                );
              },
            ),
          ),

          /// المحتوى (الصورة + النصوص)
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 23),

                /// صورة اللوجو
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

                /// العنوان
                Text(
                  "Welcome to Mazid Store",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
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

                const SizedBox(height: 16),

                /// النص الفرعي
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Your first step into a smarter shopping experience.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: widget.textColor.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
