// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mazid/pages/spa/widget/bubbles.dart';
import 'package:particles_flutter/component/particle/particle.dart';
import 'package:particles_flutter/particles_engine.dart';

class AnimatedBackground extends StatefulWidget {
  final String imagePath; // مسار الصورة
  final Widget child; // المحتوى اللي يظهر فوق الخلفية
  final List<Color>? overlayColors; // ألوان الـ overlay

  const AnimatedBackground({
    super.key,
    required this.imagePath,
    required this.child,
    this.overlayColors,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> {
  List<Particle> _bubbles = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _bubbles = BubbleHelper.createBubbles(Colors.white);

    _timer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (!mounted) return;
      setState(() => _bubbles.shuffle());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        /// الخلفية (صورة)
        Positioned.fill(
          child: Image.asset(widget.imagePath, fit: BoxFit.cover),
        ),

        /// Overlay (قابل لتخصيص الألوان)
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    widget.overlayColors ??
                    [
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

        /// فقاعات متحركة
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

        /// المحتوى اللي يترسم فوق الخلفية
        widget.child,
      ],
    );
  }
}
