// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:mazid/pages/spa/widget/M_Painter.dart';

class LogoPainterWidget extends StatelessWidget {
  final Animation<double> animation;
  const LogoPainterWidget({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          painter: MPainter(progress: animation.value),
          size: const Size(200, 200),
        );
      },
    );
  }
}
