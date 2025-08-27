// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:math' as math;

class BackgroundAnimation extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final double circleOpacity1;
  final double circleOpacity2;
  final double circleRadius;
  final double speed;

  const BackgroundAnimation({
    super.key,
    required this.child,
    this.colors = const [Color(0xFF00C6A2), Color(0xFF007C91)],
    this.circleOpacity1 = 0.1,
    this.circleOpacity2 = 0.15,
    this.circleRadius = 150,
    this.speed = 6,
  });

  @override
  State<BackgroundAnimation> createState() => _BackgroundAnimationState();
}

class _BackgroundAnimationState extends State<BackgroundAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.speed.toInt()),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: MediaQuery.of(context).size,
              painter: _BackgroundPainter(
                progress: _controller.value,
                circleOpacity1: widget.circleOpacity1,
                circleOpacity2: widget.circleOpacity2,
                circleRadius: widget.circleRadius,
              ),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  final double progress;
  final double circleOpacity1;
  final double circleOpacity2;
  final double circleRadius;

  _BackgroundPainter({
    required this.progress,
    required this.circleOpacity1,
    required this.circleOpacity2,
    required this.circleRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = Colors.white.withOpacity(circleOpacity1);
    final paint2 = Paint()..color = Colors.white.withOpacity(circleOpacity2);

    final offset1 = Offset(
      size.width * 0.5 + math.sin(progress * 2 * math.pi) * 50,
      size.height * 0.2,
    );
    final offset2 = Offset(
      size.width * 0.5 + math.cos(progress * 2 * math.pi) * 50,
      size.height * 0.75,
    );

    canvas.drawCircle(offset1, circleRadius, paint1);
    canvas.drawCircle(offset2, circleRadius, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
