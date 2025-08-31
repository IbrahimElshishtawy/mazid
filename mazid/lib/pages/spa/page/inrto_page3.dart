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
  late final AnimationController _controller;
  late final AnimationController _textController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;
  late Animation<Color?> _colorAnimation;

  final String _title = "Your new best friend is just a swipe away!";

  // 🔹 الفقاعات
  List<Particle> _bubbles = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Animation لظهور النصوص
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Animation للعنوان (تايب رايتر + تغيير لون تدريجي)
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _colorAnimation =
        ColorTween(
          begin: Colors.grey[400], // رمادي فاتح
          end: Colors.grey[700], // رمادي غامق
        ).animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
        );

    _controller.forward();
    _textController.forward();

    // 🔹 إنشاء الفقاعات البيضاء
    _bubbles = BubbleHelper.createBubbles(Colors.white);

    // 🔹 حركة الفقاعات
    _timer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (!mounted) return;
      setState(() => _bubbles.shuffle());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // الخلفية
          SizedBox.expand(
            child: Image.asset('asset/image/intro3.jpeg', fit: BoxFit.cover),
          ),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          // 🔹 الفقاعات
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

          // النصوص
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(flex: 3),

                  // تايب رايتر + Fade + Slide + تغيير لون
                  AnimatedBuilder(
                    animation: Listenable.merge([_textController, _controller]),
                    builder: (context, child) {
                      final textLength = (_title.length * _textController.value)
                          .toInt()
                          .clamp(0, _title.length);
                      final displayText = _title.substring(0, textLength);

                      return SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            displayText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color:
                                  _colorAnimation.value, // لون متغير تدريجياً
                              height: 1.4,
                              letterSpacing: 1.2,
                              shadows: const [
                                Shadow(
                                  blurRadius: 8,
                                  color: Colors.black87,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const Spacer(flex: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
