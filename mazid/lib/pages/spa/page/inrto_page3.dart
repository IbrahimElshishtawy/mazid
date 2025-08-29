import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class IntroPage3 extends StatefulWidget {
  final Color textColor;

  const IntroPage3({super.key, required this.textColor});

  @override
  State<IntroPage3> createState() => _IntroPage3State();
}

class _IntroPage3State extends State<IntroPage3> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// الخلفية
          SizedBox.expand(
            child: Image.asset('asset/image/intro3.jpeg', fit: BoxFit.cover),
          ),

          /// النص المتحرك
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Spacer(flex: 1),
                  AnimatedOpacity(
                    opacity: _visible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 800),
                    child: AnimatedTextKit(
                      totalRepeatCount: 1,
                      pause: Duration.zero,
                      animatedTexts: [
                        TypewriterAnimatedText(
                          "Your new best friend is just a swipe away!",
                          textAlign: TextAlign.center,
                          textStyle: TextStyle(
                            fontSize: 20,
                            color: widget.textColor,
                            fontWeight: FontWeight.bold,
                            shadows: const [
                              Shadow(
                                blurRadius: 6,
                                color: Colors.black54,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          speed: const Duration(milliseconds: 200),
                        ),
                      ],
                    ),
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
