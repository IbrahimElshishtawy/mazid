// ignore_for_file: unused_field, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:m_shop/core/widget/spa/widget/page_indicator.dart';
// صفحات الانترو
import 'package:m_shop/page/spa/ui/page/inrto_page3.dart'; // عدّل للاسم الصحيح لو intro_page3.dart
import 'package:m_shop/page/spa/ui/page/intro_page1.dart';
import 'package:m_shop/page/spa/ui/page/intro_page2.dart';
// صفحة الوجهة
import 'package:m_shop/page/Auth/UI/ui/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageData {
  final Color bgColor;
  final Color textColor;
  const PageData(this.bgColor, this.textColor);
}

// 3 صفحات انترو فقط (من غير Login)
final List<PageData> pagesData = const [
  PageData(Colors.black, Colors.white),
  PageData(Color.fromARGB(255, 247, 247, 247), Color.fromARGB(255, 1, 1, 1)),
  PageData(Colors.black, Colors.white),
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

  List<Widget> _buildPages() {
    return List.generate(pagesData.length, (index) {
      final page = pagesData[index];

      Widget content;
      if (index == 0) {
        content = IntroPage1(textColor: page.textColor);
      } else if (index == 1) {
        content = IntroPage2(textColor: page.textColor);
      } else {
        content = IntroPage3(textColor: page.textColor);
      }

      return Container(color: page.bgColor, child: content);
    });
  }

  bool get _isLastIntro => currentPage == _pages.length - 1;

  Future<void> _markIntroSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('introSeen', true);
    } catch (_) {}
  }

  /// ترانزيشن سلايد يمين→يسار في push والعكس في pop
  Route<T> _slideRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        final inFromRight = Tween<Offset>(
          begin: const Offset(1, 0), // يدخل من اليمين
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation);

        final outToLeft =
            Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(-0.1, 0), // خروج بسيط لليسار
                )
                .chain(CurveTween(curve: Curves.easeOutCubic))
                .animate(secondaryAnimation);

        return SlideTransition(
          position: inFromRight,
          child: SlideTransition(position: outToLeft, child: child),
        );
      },
    );
  }

  Future<void> _onGetStarted() async {
    await _markIntroSeen();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(_slideRoute(const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // رجوع للخلف بنفس حركة LiquidSwipe بدل الخروج
      onWillPop: () async {
        if (currentPage > 0) {
          _liquidController.animateToPage(page: currentPage - 1, duration: 350);
          return false;
        }
        return true; // أول صفحة: يسمح بالخروج
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          LiquidSwipe(
            pages: _pages,
            liquidController: _liquidController,
            enableLoop: false,
            fullTransitionValue: 550,
            enableSideReveal: false,
            waveType: WaveType.liquidReveal,
            slideIconWidget: null,
            onPageChangeCallback: (page) {
              setState(() => currentPage = page);
            },
          ),

          // مؤشر الصفحات
          Positioned(
            bottom: 20,
            child: PageIndicator(
              length: _pages.length,
              currentPage: currentPage,
              color: pagesData[currentPage].textColor,
            ),
          ),

          // زر Back اختياري بنفس أنيميشن السحب
          if (currentPage > 0)
            Positioned(
              top: 44,
              left: 16,
              child: IconButton(
                onPressed: () {
                  _liquidController.animateToPage(
                    page: currentPage - 1,
                    duration: 350,
                  );
                },
                icon: const Icon(Icons.arrow_back),
                color: pagesData[currentPage].textColor.withOpacity(0.9),
                tooltip: 'Back',
              ),
            ),

          // زر Skip (ينطّ لآخر صفحة)
          if (!_isLastIntro)
            Positioned(
              top: 44,
              right: 16,
              child: TextButton(
                onPressed: () {
                  _liquidController.animateToPage(
                    page: _pages.length - 1,
                    duration: 350,
                  );
                },
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: pagesData[currentPage].textColor.withOpacity(0.85),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          // زر Next / Get Started
          Positioned(
            right: 16,
            bottom: 24,
            child: ElevatedButton(
              onPressed: () async {
                if (_isLastIntro) {
                  await _onGetStarted(); // slide + mark seen
                } else {
                  _liquidController.animateToPage(
                    page: currentPage + 1,
                    duration: 300,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: pagesData[currentPage].textColor,
                foregroundColor: pagesData[currentPage].bgColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(_isLastIntro ? 'Get Started' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }
}
