import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:particles_flutter/component/particle/particle.dart';
import 'package:particles_flutter/particles_engine.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final LiquidController _liquidController = LiquidController();
  int currentPage = 0;
  int _lastPage = 0; // لمعرفة اتجاه الانتقال (تقديم/رجوع)
  bool _spawnedThisSwipe = false; // عشان منطلّعش فقاعات كتير في نفس السحبة
  Timer? _timer;

  final pages = [
    _buildPage(Colors.blue, "Welcome to My App"),
    _buildPage(Colors.green, "Buy & Adopt Cats Easily"),
    _buildPage(Colors.purple, "Let's Get Started 🚀"),
  ];

  static Widget _buildPage(Color color, String text) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // فقاعات خلفية عادية
  List<Particle> _createBubbles() {
    final rng = Random();
    return List.generate(60, (_) {
      final size = rng.nextDouble() * 6 + 2;
      final vx = (rng.nextDouble() - 0.5) * 10;
      final vy = -(5 + rng.nextDouble() * 15);
      return Particle(
        color: Colors.white.withOpacity(rng.nextDouble() * 0.4 + 0.2),
        size: size,
        velocity: Offset(vx, vy),
      );
    });
  }

  // فقاعات تظهر أثناء الانتقال — اتجاهها بيتأثر باتجاه السحب
  List<Particle> _waveBubbles(SlideDirection dir) {
    final rng = Random();
    // انحياز بسيط في اتجاه السحب: يمين←يسار = موجب، يسار←يمين = سالب
    final double bias = (dir == SlideDirection.rightToLeft)
        ? 30.0
        : (dir == SlideDirection.leftToRight)
        ? -30.0
        : 0.0;

    return List.generate(22, (_) {
      final size = rng.nextDouble() * 12 + 4;
      final vx =
          bias + (rng.nextDouble() - 0.5) * 60; // فيه انحياز + شوية عشوائية
      final vy = -(15 + rng.nextDouble() * 25);
      return Particle(
        color: Colors.white.withOpacity(rng.nextDouble() * 0.5 + 0.5),
        size: size,
        velocity: Offset(vx, vy),
      );
    });
  }

  List<Particle> _bubbles = [];

  @override
  void initState() {
    super.initState();
    _bubbles = _createBubbles();

    // تحريك/تحديث بسيط دوري عشان يبان في حركة
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted) return;
      setState(() {
        _bubbles.shuffle();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // نستدعيها جوه slidePercentCallback
  void _onSwipeProgress(double percent, SlideDirection direction) {
    // أول لما السحبة تبدأ بنسبة صغيرة نطلّع فقاعات في اتجاه السحب
    if (!_spawnedThisSwipe &&
        percent > 0.02 &&
        direction != SlideDirection.none) {
      setState(() {
        _bubbles.addAll(_waveBubbles(direction));
        _spawnedThisSwipe = true;
      });
    }
    // لما السحبة تخلص (رجعت للصفر أو خلصت 100%) نسمح بسحبة جديدة تطلع فقاعات
    if (percent == 0.0 || percent == 1.0) {
      _spawnedThisSwipe = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // خلفية البحر
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0D47A1),
                  Color(0xFF1976D2),
                  Color(0xFF42A5F5),
                ],
              ),
            ),
          ),

          // فقاعات المية
          IgnorePointer(
            child: Particles(
              awayRadius: 120,
              particles: _bubbles,
              height: size.height,
              width: size.width,
              onTapAnimation: false,
              awayAnimationDuration: const Duration(milliseconds: 200),
              awayAnimationCurve: Curves.linear, // عشان الإحساس يبقى أقل نعومة
              enableHover: false,
              hoverRadius: 80,
              connectDots: false,
            ),
          ),

          // السحب بموج البحر
          LiquidSwipe(
            pages: pages,
            liquidController: _liquidController,
            enableLoop: true,
            fullTransitionValue: 450, // سرعة انتقال (أقل = أحدة)
            enableSideReveal: false, // نفس الحركة رايح/راجع
            waveType: WaveType.liquidReveal, // موج بحر
            slideIconWidget: null,

            // دالة للسحب (تطبيقها في الاتجاهين: تقديم *و* رجوع)
            slidePercentCallback: (percent, direction) {
              _onSwipeProgress(percent, direction as SlideDirection);
            },

            // دالة تغيير الصفحة — هنحدد منها هل الانتقال كان رجوع ولا تقديم ونطلع فقاعات تاني
            onPageChangeCallback: (page) {
              final int pagesLen = pages.length;
              final bool isBack =
                  page == ((_lastPage - 1 + pagesLen) % pagesLen);
              final SlideDirection dir = isBack
                  ? SlideDirection.leftToRight
                  : SlideDirection.rightToLeft;

              setState(() {
                currentPage = page;
                _lastPage = page;
                _bubbles.addAll(
                  _waveBubbles(dir),
                ); // فقاعات إضافية بعد اكتمال الانتقال
              });
            },
          ),

          // مؤشر الصفحات
          Positioned(
            bottom: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentPage == index ? 14 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentPage == index ? Colors.white : Colors.white54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
