import 'package:flutter/material.dart';
import 'package:mazid/pages/spa/widget/intro_animation.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: IntroAnimation(), // استدعاء الانيميشن كله من ملف مستقل
    );
  }
}
