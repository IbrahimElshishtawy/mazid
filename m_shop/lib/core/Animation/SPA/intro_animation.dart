// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:m_shop/core/widget/spa/widget/page_indicator.dart';
import 'package:m_shop/page/Auth/UI/ui/login.dart';
import 'package:m_shop/page/spa/ui/page/inrto_page3.dart';
import 'package:m_shop/page/spa/ui/page/intro_page1.dart';
import 'package:m_shop/page/spa/ui/page/intro_page2.dart';

class PageData {
  final Color bgColor;
  final Color textColor;
  final String type;

  PageData(this.bgColor, this.textColor, this.type);
}

final List<PageData> pagesData = [
  PageData(Colors.black, Colors.white, "intro"),
  PageData(
    const Color.fromARGB(255, 247, 247, 247),
    const Color.fromARGB(255, 1, 1, 1),
    "intro",
  ),
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

  List<Widget> buildPages() {
    return pagesData.map((page) {
      final index = pagesData.indexOf(page);
      if (page.type == "intro") {
        if (index == 0) return IntroPage1(textColor: page.textColor);
        if (index == 1) return IntroPage2(textColor: page.textColor);
        return IntroPage3(textColor: page.textColor);
      } else {
        return const LoginPage();
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final pages = buildPages();

    if (currentPage == pages.length - 1) {
      return const LoginPage();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(color: pagesData[currentPage].bgColor),

        LiquidSwipe(
          pages: pages,
          liquidController: _liquidController,
          enableLoop: true,
          fullTransitionValue: 450,
          enableSideReveal: false,
          waveType: WaveType.liquidReveal,
          slideIconWidget: null,
          onPageChangeCallback: (page) {
            setState(() {
              currentPage = page;
              _lastPage = page;
            });
          },
        ),

        Positioned(
          bottom: 20,
          child: PageIndicator(
            length: pages.length,
            currentPage: currentPage,
            color: pagesData[currentPage].textColor,
          ),
        ),
      ],
    );
  }
}
