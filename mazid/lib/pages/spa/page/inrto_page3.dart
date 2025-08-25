import 'package:flutter/material.dart';

class IntroPage3 extends StatefulWidget {
  final Color textColor;

  const IntroPage3({super.key, required this.textColor});

  @override
  State<IntroPage3> createState() => _IntroPage3State();
}

class _IntroPage3State extends State<IntroPage3>
    with SingleTickerProviderStateMixin {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    // نفعل الحركة بعد قليل عند ظهور الصفحة
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
          // 🔹 خلفية الصورة تغطي الشاشة كاملة
          SizedBox.expand(
            child: Image.asset(
              'asset/image/intro3.jpeg', // ضع مسار الصورة هنا
              fit: BoxFit.cover,
            ),
          ),

          // 🔹 طبقة للنصوص مع تأثير الحركة
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Spacer(flex: 1),
                  AnimatedSlide(
                    offset: _visible ? Offset.zero : const Offset(0, 0.3),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOut,
                    child: AnimatedOpacity(
                      opacity: _visible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 1000),
                      child: Text(
                        "Your new best friend is just a swipe away!",
                        style: TextStyle(
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
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Spacer(flex: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
