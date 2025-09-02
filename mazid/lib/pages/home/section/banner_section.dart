// lib/pages/home/widget/banner_section.dart
import 'package:flutter/material.dart';
import 'package:mazid/pages/home/widget/banner.dart';

class BannerSection extends StatelessWidget {
  const BannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: PageView(
        children: const [
          BannerWidget("🔥 Sale up to 50%"),
          BannerWidget("🐶 New Pets Collection"),
          BannerWidget("💻 Latest Electronics"),
        ],
      ),
    );
  }
}
