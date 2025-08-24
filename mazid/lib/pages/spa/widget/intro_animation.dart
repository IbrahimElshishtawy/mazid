import 'dart:async';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:mazid/pages/spa/widget/pages_builder.dart';
import 'package:mazid/pages/spa/widget/bubbles.dart';
import 'package:mazid/pages/spa/widget/page_indicator.dart';
import 'package:particles_flutter/component/particle/particle.dart';
import 'package:particles_flutter/particles_engine.dart';

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
    _bubbleColor = pagesData[0].$2;
    _bubbles = BubbleHelper.createBubbles(_bubbleColor);

    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted) return;
      setState(() => _bubbles.shuffle());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pages = buildPages(pagesData);

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(color: pagesData[currentPage].$1),

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
              _bubbleColor = pagesData[page].$2;
              _bubbles.addAll(BubbleHelper.waveBubbles(dir, _bubbleColor));
            });
          },
        ),

        Positioned(
          bottom: 20,
          child: PageIndicator(
            length: pages.length,
            currentPage: currentPage,
            color: pagesData[currentPage].$2,
          ),
        ),
      ],
    );
  }
}
