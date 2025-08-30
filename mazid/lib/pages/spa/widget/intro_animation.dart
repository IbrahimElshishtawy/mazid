import 'dart:async';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:mazid/pages/spa/page/intro_page1.dart';
import 'package:mazid/pages/spa/page/intro_page2.dart';
import 'package:mazid/pages/spa/page/inrto_page3.dart';
import 'package:mazid/pages/spa/widget/bubbles.dart';
import 'package:mazid/pages/spa/widget/page_indicator.dart';
import 'package:particles_flutter/component/particle/particle.dart';
import 'package:particles_flutter/particles_engine.dart';
import 'package:mazid/pages/auth/login.dart';

// تعريف class PageData
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
  List<Particle> _bubbles = [];
  Color _bubbleColor = Colors.white;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _bubbleColor = pagesData[0].textColor;
    _bubbles = BubbleHelper.createBubbles(_bubbleColor);

    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (!mounted) return;
      setState(() => _bubbles.shuffle());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // دالة بناء الصفحات
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
    final size = MediaQuery.of(context).size;
    final pages = buildPages();

    if (currentPage == pages.length - 1) {
      return const LoginPage();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(color: pagesData[currentPage].bgColor),

        IgnorePointer(
          child: Particles(
            awayRadius: 120,
            particles: _bubbles,
            height: size.height,
            width: size.width,
            onTapAnimation: false,
            awayAnimationDuration: const Duration(milliseconds: 200),
            awayAnimationCurve: Curves.linear,
            enableHover: false,
            hoverRadius: 80,
            connectDots: false,
          ),
        ),

        LiquidSwipe(
          pages: pages,
          liquidController: _liquidController,
          enableLoop: true,
          fullTransitionValue: 450,
          enableSideReveal: false,
          waveType: WaveType.liquidReveal,
          slideIconWidget: null,
          onPageChangeCallback: (page) {
            final int pagesLen = pages.length;
            final bool isBack = page == ((_lastPage - 1 + pagesLen) % pagesLen);
            final dir = isBack
                ? SlideDirection.leftToRight
                : SlideDirection.rightToLeft;

            setState(() {
              currentPage = page;
              _lastPage = page;
              _bubbleColor = pagesData[page].textColor;
              _bubbles.addAll(BubbleHelper.waveBubbles(dir, _bubbleColor));
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
