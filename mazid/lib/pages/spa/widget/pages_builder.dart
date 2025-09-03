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
  List<Particle> _bubbles = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // إنشاء فقاعات البداية
    _bubbles = BubbleHelper.createBubbles(Colors.white);

    // حركة بسيطة للفقاعات (Shuffle)
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

  /// بناء صفحات الانترو + اللوجين
  List<Widget> buildPages() {
    return [
      const IntroPage1(textColor: Colors.white),
      const IntroPage2(textColor: Color.fromARGB(255, 255, 255, 255)),
      const IntroPage3(textColor: Colors.white),
      const LoginPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pages = buildPages();

    // لو وصلنا Login → نعرضها مباشرة بدون تأثير
    if (currentPage == pages.length - 1) {
      return const LoginPage();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // الخلفية بلون الصفحة
        Container(color: pagesData[currentPage].bgColor),

        // فقاعات متحركة
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

        // Liquid Swipe
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
            final dir = isBack
                ? SlideDirection.leftToRight
                : SlideDirection.rightToLeft;

            setState(() {
              currentPage = page;
              _lastPage = page;

              // إضافة حركة للفقاعات مع تغيير الصفحة
              _bubbles.addAll(BubbleHelper.waveBubbles(dir, Colors.white));
            });
          },
        ),

        // Page Indicator أبيض فقط
        Positioned(
          bottom: 20,
          child: PageIndicator(
            length: pages.length,
            currentPage: currentPage,
            color: Colors.white, // ثابت أبيض
          ),
        ),
      ],
    );
  }
}
