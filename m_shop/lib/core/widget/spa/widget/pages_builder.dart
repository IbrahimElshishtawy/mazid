// ignore_for_file: unused_local_variable

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
          enableLoop: false,
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

        if (currentPage < pages.length - 1)
          Positioned(
            bottom: 20,
            child: PageIndicator(
              length: pages.length - 1,
              currentPage: currentPage,
              color: pagesData[currentPage].textColor,
            ),
          ),
      ],
    );
  }
}
