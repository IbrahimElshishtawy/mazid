import 'package:flutter/material.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class ProductionChart extends StatelessWidget {
  const ProductionChart({super.key, required this.data});

  final List<ProductionPoint> data;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _ProductionChartPainter(data));
  }
}

class _ProductionChartPainter extends CustomPainter {
  const _ProductionChartPainter(this.data);

  final List<ProductionPoint> data;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 28.0;
    final width = size.width - left;
    final height = size.height - 28.0;
    const min = 60.0;
    const max = 110.0;

    double scaleY(double value) => height - ((value - min) / (max - min) * height);

    final grid = Paint()
      ..color = const Color(0xFFE2ECE8)
      ..strokeWidth = 1;
    for (var i = 0; i < 5; i++) {
      final y = height * i / 4;
      canvas.drawLine(Offset(left, y), Offset(size.width, y), grid);
    }

    final slot = width / data.length;
    final barWidth = slot * 0.42;
    final barPaint = Paint()..color = const Color(0xFF0F766E);
    final path = Path();

    for (var i = 0; i < data.length; i++) {
      final barX = left + slot * i + (slot - barWidth) / 2;
      final barY = scaleY(data[i].actual);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(barX, barY, barWidth, height - barY),
          const Radius.circular(4),
        ),
        barPaint,
      );

      final targetX = left + slot * i + slot / 2;
      final targetY = scaleY(data[i].target);
      if (i == 0) {
        path.moveTo(targetX, targetY);
      } else {
        path.lineTo(targetX, targetY);
      }

      final textPainter = TextPainter(
        text: TextSpan(
          text: data[i].label,
          style: const TextStyle(color: Color(0xFF677C76), fontSize: 11),
        ),
        textDirection: TextDirection.rtl,
      )..layout();
      textPainter.paint(canvas, Offset(targetX - textPainter.width / 2, size.height - 18));
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF94A3B8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
