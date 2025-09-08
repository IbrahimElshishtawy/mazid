// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:particles_flutter/component/particle/particle.dart';
import 'package:particles_flutter/particles_engine.dart';
import 'package:mazid/pages/spa/widget/bubbles.dart';

class IntroPage3 extends StatefulWidget {
  final Color textColor;

  const IntroPage3({super.key, required this.textColor});

  @override
  State<IntroPage3> createState() => _IntroPage3State();
}

class _IntroPage3State extends State<IntroPage3> with TickerProviderStateMixin {
  late AnimationController _titleController;
  late Animation<Color?> _colorAnimation;

  final String _title = "Your new best friend is just a swipe away!";

  // 🔹 الفقاعات
  List<Particle> _bubbles = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    /// Animation للعنوان (كتابة تدريجية + تغيير لون)
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _colorAnimation = ColorTween(begin: Colors.grey[300], end: Colors.grey[700])
        .animate(
          CurvedAnimation(parent: _titleController, curve: Curves.easeInOut),
        );

    _titleController.forward();

    /// 🔹 إنشاء الفقاعات البيضاء
    _bubbles = BubbleHelper.createBubbles(Colors.white);

    /// 🔹 تحريك الفقاعات بشكل مستمر
    _timer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (!mounted) return;
      setState(() => _bubbles.shuffle());
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          /// الخلفية
          Positioned.fill(
            child: Image.asset('asset/image/intro3.jpeg', fit: BoxFit.cover),
          ),

          /// Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                    Colors.black.withOpacity(0.4),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),

          /// 🔹 الفقاعات
          IgnorePointer(
            child: Particles(
              awayRadius: 120,
              particles: _bubbles,
              height: size.height,
              width: size.width,
              onTapAnimation: false,
              awayAnimationDuration: const Duration(milliseconds: 250),
              awayAnimationCurve: Curves.easeOut,
              enableHover: false,
              hoverRadius: 80,
              connectDots: false,
            ),
          ),

          /// النصوص
          Column(
            children: [
              const Spacer(flex: 5),

              /// العنوان المتحرك (تايب رايتر + لون متغير)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AnimatedBuilder(
                  animation: _titleController,
                  builder: (context, child) {
                    final textLength = (_title.length * _titleController.value)
                        .toInt()
                        .clamp(0, _title.length);
                    final displayText = _title.substring(0, textLength);

                    return Text(
                      displayText,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: _colorAnimation.value,
                        letterSpacing: 1.3,
                        shadows: const [
                          Shadow(
                            blurRadius: 8,
                            color: Colors.black87,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ),

              const Spacer(flex: 15),

              /// نصوص فرعية
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: const [
                    Text(
                      "Find the perfect match for your lifestyle",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 6,
                            color: Colors.black54,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Adopt, connect, and start your journey now",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                        shadows: [
                          Shadow(
                            blurRadius: 6,
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

              const Spacer(flex: 6),
            ],
          ),
        ],
      ),
    );
  }
}
