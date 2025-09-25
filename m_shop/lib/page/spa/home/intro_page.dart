import 'package:flutter/material.dart';
import 'package:m_shop/core/Animation/SPA/intro_animation.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: IntroAnimation());
  }
}
