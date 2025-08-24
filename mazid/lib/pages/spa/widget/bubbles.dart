import 'dart:math';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/Helpers/Helpers.dart';
import 'package:particles_flutter/component/particle/particle.dart';

class BubbleHelper {
  // إنشاء فقاعات أولية
  static List<Particle> createBubbles(Color color) {
    final rng = Random();
    return List.generate(60, (_) {
      final size = rng.nextDouble() * 6 + 2;
      final vx = (rng.nextDouble() - 0.5) * 10;
      final vy = -(5 + rng.nextDouble() * 15);
      return Particle(
        color: color.withOpacity(rng.nextDouble() * 0.4 + 0.2),
        size: size,
        velocity: Offset(vx, vy),
      );
    });
  }

  // فقاعات وقت السحب
  static List<Particle> waveBubbles(SlideDirection dir, Color color) {
    final rng = Random();
    final double bias = (dir == SlideDirection.rightToLeft)
        ? 30.0
        : (dir == SlideDirection.leftToRight)
        ? -30.0
        : 0.0;

    return List.generate(22, (_) {
      final size = rng.nextDouble() * 12 + 4;
      final vx = bias + (rng.nextDouble() - 0.5) * 60;
      final vy = -(15 + rng.nextDouble() * 25);
      return Particle(
        color: color.withOpacity(rng.nextDouble() * 0.5 + 0.5),
        size: size,
        velocity: Offset(vx, vy),
      );
    });
  }
}
