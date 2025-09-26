// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:m_shop/core/widget/spa/widget/page_indicator.dart';
import 'package:m_shop/page/Auth/UI/ui/login.dart';
import 'package:m_shop/page/spa/ui/page/inrto_page3.dart';
import 'package:m_shop/page/spa/ui/page/intro_page1.dart';
import 'package:m_shop/page/spa/ui/page/intro_page2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageData {
  final Color bgColor;
  final Color textColor;
  final String type; // "intro" | "login"
  const PageData(this.bgColor, this.textColor, this.type);
}

final List<PageData> pagesData = const [
  PageData(Colors.black, Colors.white, "intro"),
  PageData(
    Color.fromARGB(255, 247, 247, 247),
    Color.fromARGB(255, 1, 1, 1),
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
  late final List<Widget> _pages;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pages = _buildPages();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> _buildPages() {
    return List.generate(pagesData.length, (index) {
      final page = pagesData[index];

      Widget content;
      if (page.type == "intro") {
        if (index == 0) {
          content = IntroPage1(textColor: page.textColor);
        } else if (index == 1) {
          content = IntroPage2(textColor: page.textColor);
        } else {
          content = IntroPage3(textColor: page.textColor);
        }
      } else {
        // صفحة الـ Login كآخر صفحة داخل السوايب (تجربة سلسة)
        content = const LoginPage();
      }

      // نضمن الخلفية لكل صفحة من البيانات
      return Container(color: page.bgColor, child: content);
    });
  }

  Future<void> _markIntroSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('introSeen', true);
    } catch (_) {
      // تجاهل بهدوء لو في الويب أو حصلت مشكلة مؤقتة
    }
  }

  bool get _isLast => currentPage == _pages.length - 1;

  void _onNext() async {
    if (_isLast) {
      await _markIntroSeen();
      // بما إن صفحة الـ Login آخر صفحة، هنسيب المستخدم يكمل عليها
      // ولو عايز بدل كده تعمل pushReplacement للـ LoginPage برة السوايب، استخدم Navigator هنا.
      return;
    }
    _liquidController.animateToPage(page: currentPage + 1, duration: 350);
  }

  void _onSkip() async {
    // نروح على آخر صفحة (Login) ونعلم introSeen
    _liquidController.jumpToPage(page: _pages.length - 1);
    await _markIntroSeen();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        LiquidSwipe(
          pages: _pages,
          liquidController: _liquidController,
          enableLoop: false, // نخلي الوصول للآخر طبيعي
          fullTransitionValue: 550,
          enableSideReveal: false,
          waveType: WaveType.liquidReveal,
          slideIconWidget: null,
          onPageChangeCallback: (page) async {
            setState(() => currentPage = page);
            if (page == _pages.length - 1) {
              // أول ما يوصل لآخر صفحة نعلّم introSeen
              await _markIntroSeen();
            }
          },
        ),

        // الـ Page Indicator
        Positioned(
          bottom: 20,
          child: PageIndicator(
            length: _pages.length,
            currentPage: currentPage,
            color: pagesData[currentPage].textColor,
          ),
        ),
      ],
    );
  }
}
