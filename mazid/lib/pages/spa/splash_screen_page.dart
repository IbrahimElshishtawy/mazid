import 'package:flutter/material.dart';
import 'package:mazid/pages/home/home_page.dart';
import 'package:mazid/pages/spa/widget/LogoPrintWidget.dart';
import 'package:mazid/pages/spa/widget/LogoTextWidget';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // بعد انتهاء الأنيميشن → يروح على الهوم
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// رسم اللوجو M
            LogoPainterWidget(animation: _animation),

            const SizedBox(height: 30),

            /// النص Mazid Shop
            LogoTextWidget(animation: _animation),
          ],
        ),
      ),
    );
  }
}
