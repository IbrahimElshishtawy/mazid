import 'package:flutter/material.dart';
import 'dart:math';

class MPainter extends CustomPainter {
  final double progress;

  MPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    final w = size.width;
    final random = Random();

    // تأثير التوهج للحرف
    final glowPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    // الخط الرئيسي
    final mainPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    // رسم حرف M حاد
    final path = Path();
    path.moveTo(0, h); // أسفل اليسار
    path.lineTo(0, 0); // أعلى اليسار
    path.lineTo(w / 2, h); // أسفل المنتصف
    path.lineTo(w, 0); // أعلى اليمين
    path.lineTo(w, h); // أسفل اليمين

    // رسم الجزء المرسوم حتى الآن حسب progress
    final pathMetrics = path.computeMetrics();
    final extractPath = Path();
    for (final metric in pathMetrics) {
      final length = metric.length * progress;
      extractPath.addPath(metric.extractPath(0, length), Offset.zero);
    }

    // رسم التوهج والخط الرئيسي
    canvas.drawPath(extractPath, glowPaint);
    canvas.drawPath(extractPath, mainPaint);

    // نقاط ووميض متطاير من نهاية الحرف
    for (int i = 0; i < 15; i++) {
      final bounds = extractPath.getBounds();
      // توليد نقاط عشوائية خارج الحرف (يمين وأسفل)
      final dx = bounds.right + random.nextDouble() * 30 - 15;
      final dy = bounds.bottom * random.nextDouble();
      canvas.drawCircle(
        Offset(dx, dy),
        random.nextDouble() * 3 + 1,
        Paint()..color = Colors.white.withOpacity(random.nextDouble()),
      );
    }
  }

  @override
  bool shouldRepaint(covariant MPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
