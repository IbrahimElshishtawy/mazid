import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int length;
  final int currentPage;
  final Color color;

  const PageIndicator({
    super.key,
    required this.length,
    required this.currentPage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentPage == index ? 14 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
