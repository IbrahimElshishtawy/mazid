// ignore_for_file: file_names

import 'dart:math';
import 'package:flutter/material.dart';

/// ويدجت للنجوم (قابلة لإعادة الاستخدام)
class StarRating extends StatelessWidget {
  final double rating;
  final int starCount;
  final double size;

  const StarRating({
    super.key,
    required this.rating,
    this.starCount = 5,
    this.size = 14,
  });

  @override
  Widget build(BuildContext context) {
    // لو مفيش ريتنج نخليه عشوائي (3, 4, أو 5)
    final random = Random();
    final effectiveRating = (rating == 0)
        ? (3 + random.nextInt(3)) // هيديك يا 3 يا 4 يا 5
        : rating;

    final filledStars = min(effectiveRating.floor(), starCount);

    return Row(
      children: List.generate(starCount, (index) {
        return Icon(
          index < filledStars ? Icons.star : Icons.star_border,
          color: Colors.orangeAccent,
          size: size,
        );
      }),
    );
  }
}
