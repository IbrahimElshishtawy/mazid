// lib/pages/home/widget/banner_section.dart
import 'package:flutter/material.dart';
import 'package:m_shop/core/widget/home/widget/banner.dart';

class BannerSection extends StatelessWidget {
  const BannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: PageView(
        children: const [
          BannerWidget("", imageUrl: 'assets/asset/image/offer50.png'),
          BannerWidget("", imageUrl: 'assets/asset/image/download.jpg'),
          BannerWidget(
            "",
            imageUrl: 'assets/asset/image/sell-used-electronics.jpg',
          ),
        ],
      ),
    );
  }
}
