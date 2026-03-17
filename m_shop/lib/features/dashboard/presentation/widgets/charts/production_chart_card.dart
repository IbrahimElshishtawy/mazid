import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class ProductionChartCard extends StatelessWidget {
  const ProductionChartCard({super.key, required this.data});

  final List<ProductionPoint> data;

  @override
  Widget build(BuildContext context) {
    final totalActual = data.fold<double>(0, (sum, item) => sum + item.actual);
    final totalTarget = data.fold<double>(0, (sum, item) => sum + item.target);
    final variance = totalActual - totalTarget;

    return SectionCard(
      title: 'الإنتاجية',
      subtitle: 'مخطط احترافي يقارن الإنتاج الفعلي بالمستهدف عبر الأيام.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _MiniStat(
                title: 'الإنتاج الفعلي',
                value: totalActual.round().toString(),
                accent: const Color(0xFF0F766E),
              ),
              _MiniStat(
                title: 'المستهدف',
                value: totalTarget.round().toString(),
                accent: const Color(0xFF94A3B8),
              ),
              _MiniStat(
                title: 'الفارق',
                value: variance.round().toString(),
                accent: variance >= 0
                    ? const Color(0xFF16A34A)
                    : const Color(0xFFDC2626),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const _ChartLegend(),
          const SizedBox(height: 14),
          Container(
            height: 240,
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surface.withValues(alpha: 0.48),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2ECE8)),
            ),
            child: CustomPaint(
              painter: _ProductionChartPainter(data),
              size: Size.infinite,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.title,
    required this.value,
    required this.accent,
  });

  final String title;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF647874),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  const _ChartLegend();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 16,
      runSpacing: 10,
      children: [
        _LegendItem(
          label: 'الإنتاج الفعلي',
          color: Color(0xFF0F766E),
          isLine: false,
        ),
        _LegendItem(label: 'المستهدف', color: Color(0xFF94A3B8), isLine: true),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.label,
    required this.color,
    required this.isLine,
  });

  final String label;
  final Color color;
  final bool isLine;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 10,
          decoration: BoxDecoration(
            color: isLine ? Colors.transparent : color,
            borderRadius: BorderRadius.circular(999),
            border: isLine ? Border.all(color: color, width: 2) : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF5E746E),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ProductionChartPainter extends CustomPainter {
  const _ProductionChartPainter(this.data);

  final List<ProductionPoint> data;

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 42.0;
    const rightPad = 18.0;
    const topPad = 18.0;
    const bottomPad = 34.0;
    final chartWidth = size.width - leftPad - rightPad;
    final chartHeight = size.height - topPad - bottomPad;

    final values = [
      for (final point in data) point.actual,
      for (final point in data) point.target,
    ];
    final maxValue = (values.reduce(math.max) + 8).ceilToDouble();
    const minValue = 0.0;

    double scaleY(double value) =>
        topPad +
        chartHeight -
        ((value - minValue) / (maxValue - minValue) * chartHeight);

    final gridPaint = Paint()
      ..color = const Color(0xFFDDE8E4)
      ..strokeWidth = 1;

    const rowCount = 5;
    for (var i = 0; i < rowCount; i++) {
      final y = topPad + chartHeight * i / (rowCount - 1);
      canvas.drawLine(
        Offset(leftPad, y),
        Offset(size.width - rightPad, y),
        gridPaint,
      );

      final value = (maxValue - ((maxValue - minValue) * i / (rowCount - 1)))
          .round();
      final textPainter = TextPainter(
        text: TextSpan(
          text: '$value',
          style: const TextStyle(color: Color(0xFF70857F), fontSize: 11),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(4, y - textPainter.height / 2));
    }

    final slot = chartWidth / data.length;
    final barWidth = slot * 0.44;
    final barPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [Color(0xFF0F766E), Color(0xFF34D399)],
      ).createShader(Rect.fromLTWH(leftPad, topPad, chartWidth, chartHeight));

    final areaPath = Path();
    final linePath = Path();
    final points = <Offset>[];

    for (var i = 0; i < data.length; i++) {
      final centerX = leftPad + slot * i + slot / 2;
      final barX = centerX - barWidth / 2;
      final actualY = scaleY(data[i].actual);
      final targetY = scaleY(data[i].target);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            barX,
            actualY,
            barWidth,
            topPad + chartHeight - actualY,
          ),
          const Radius.circular(10),
        ),
        barPaint,
      );

      points.add(Offset(centerX, targetY));

      final labelPainter = TextPainter(
        text: TextSpan(
          text: data[i].label,
          style: const TextStyle(
            color: Color(0xFF677C76),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.rtl,
      )..layout();
      labelPainter.paint(
        canvas,
        Offset(centerX - labelPainter.width / 2, size.height - 22),
      );
    }

    for (var i = 0; i < points.length; i++) {
      if (i == 0) {
        linePath.moveTo(points[i].dx, points[i].dy);
        areaPath.moveTo(points[i].dx, points[i].dy);
      } else {
        final previous = points[i - 1];
        final current = points[i];
        final controlX = (previous.dx + current.dx) / 2;
        linePath.cubicTo(
          controlX,
          previous.dy,
          controlX,
          current.dy,
          current.dx,
          current.dy,
        );
        areaPath.cubicTo(
          controlX,
          previous.dy,
          controlX,
          current.dy,
          current.dx,
          current.dy,
        );
      }
    }

    if (points.isNotEmpty) {
      areaPath
        ..lineTo(points.last.dx, topPad + chartHeight)
        ..lineTo(points.first.dx, topPad + chartHeight)
        ..close();
    }

    final areaPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x3394A3B8), Color(0x0094A3B8)],
      ).createShader(Rect.fromLTWH(leftPad, topPad, chartWidth, chartHeight));
    canvas.drawPath(areaPath, areaPaint);

    final linePaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(linePath, linePaint);

    final pointPaint = Paint()..color = const Color(0xFF94A3B8);
    final pointStroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    for (final point in points) {
      canvas.drawCircle(point, 5, pointPaint);
      canvas.drawCircle(point, 5, pointStroke);
    }
  }

  @override
  bool shouldRepaint(covariant _ProductionChartPainter oldDelegate) =>
      oldDelegate.data != data;
}
