// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:mazid/pages/spa/page/intro_page1.dart';
import 'package:mazid/pages/spa/page/intro_page2.dart';
import 'package:mazid/pages/spa/page/inrto_page3.dart';
import 'package:mazid/pages/spa/widget/page_indicator.dart';
import 'package:mazid/pages/auth/ui/login.dart';

/// بيانات الصفحات
class PageData {
  final Color bgColor;
  final Color textColor;
  final String type;

  PageData(this.bgColor, this.textColor, this.type);
}

/// قائمة الصفحات
final List<PageData> pagesData = [
  PageData(Colors.black, Colors.white, "intro"),
  PageData(Colors.white, Colors.black, "intro"),
  PageData(Colors.black, Colors.white, "intro"),
  PageData(Colors.white, Colors.black, "login"),
];

class IntroAnimation extends StatefulWidget {
  const IntroAnimation({super.key});

  @override
  State<IntroAnimation> createState() => _IntroAnimationState();
}

class _IntroAnimationState extends State<IntroAnimation> {
  final LiquidController _liquidController = LiquidController();
  int currentPage = 0;
  int _lastPage = 0;

  /// بناء صفحات الانترو + اللوجين
  List<Widget> buildPages() {
    return [
      const IntroPage1(textColor: Colors.white),
      const IntroPage2(textColor: Colors.black),
      const IntroPage3(textColor: Colors.white),
      const LoginPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final pages = buildPages();

    // لو وصلنا Login → نعرضها مباشرة
    if (currentPage == pages.length - 1) {
      return const LoginPage();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        /// لون خلفية الصفحة الحالية
        Container(color: pagesData[currentPage].bgColor),

        /// انيميشن السوايب
        LiquidSwipe(
          pages: pages,
          liquidController: _liquidController,
          enableLoop: true,
          fullTransitionValue: 500,
          enableSideReveal: false,
          waveType: WaveType.liquidReveal,
          slideIconWidget: null,
          onPageChangeCallback: (page) {
            final int pagesLen = pages.length;
            final bool isBack = page == ((_lastPage - 1 + pagesLen) % pagesLen);

            setState(() {
              currentPage = page;
              _lastPage = page;
            });
          },
        ),

        /// إنديكيتور للصفحات
        Positioned(
          bottom: 20,
          child: PageIndicator(
            length: pages.length,
            currentPage: currentPage,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
