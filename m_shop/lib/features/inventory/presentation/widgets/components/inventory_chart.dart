import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/inventory/presentation/widgets/components/inventory_metrics.dart';
import 'package:m_shop/features/inventory/presentation/widgets/components/inventory_models.dart';

class InventoryChartCard extends StatelessWidget {
  const InventoryChartCard({
    super.key,
    required this.items,
    required this.summary,
  });

  final List<InventoryItem> items;
  final InventorySummary summary;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'لوحة التدفق الخطي',
      subtitle: 'عرض احترافي يوضح الفجوة بين الكمية الحالية والحد الأدنى ومستوى التغطية لكل صنف.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              MiniLegendStat(
                label: 'إجمالي الكمية',
                value: formatInventoryNumber(summary.totalQuantity),
                color: const Color(0xFF0F766E),
              ),
              MiniLegendStat(
                label: 'نقص مطلوب',
                value: formatInventoryNumber(summary.restockUnits),
                color: const Color(0xFFDC2626),
              ),
              MiniLegendStat(
                label: 'أعلى تغطية',
                value: '${summary.stockCoverage.toStringAsFixed(1)}x',
                color: const Color(0xFF2563EB),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              ChartLegendItem(label: 'الكمية الحالية', color: Color(0xFF0F766E), dashed: false),
              ChartLegendItem(label: 'الحد الأدنى', color: Color(0xFFDC2626), dashed: true),
              ChartLegendItem(label: 'التغطية', color: Color(0xFF2563EB), dashed: false),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 390,
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).cardColor,
                  const Color(0xFF0F766E).withValues(alpha: 0.04),
                  const Color(0xFF2563EB).withValues(alpha: 0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFFDCE8E4)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x120F172A),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: CustomPaint(
              painter: InventoryLineChartPainter(items: items),
              size: Size.infinite,
            ),
          ),
        ],
      ),
    );
  }
}

class ChartLegendItem extends StatelessWidget {
  const ChartLegendItem({
    super.key,
    required this.label,
    required this.color,
    required this.dashed,
  });

  final String label;
  final Color color;
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE2ECE8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28,
            height: 10,
            child: CustomPaint(
              painter: _LegendStrokePainter(color: color, dashed: dashed),
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Color(0xFF5E746E), fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class InventoryLineChartPainter extends CustomPainter {
  const InventoryLineChartPainter({required this.items});

  final List<InventoryItem> items;

  @override
  void paint(Canvas canvas, Size size) {
    if (items.isEmpty) {
      return;
    }

    const leftPad = 48.0;
    const rightPad = 20.0;
    const topPad = 22.0;
    const bottomPad = 42.0;
    final chartWidth = size.width - leftPad - rightPad;
    final chartHeight = size.height - topPad - bottomPad;
    final maxValue = items
            .expand(
              (item) => [
                item.quantity.toDouble(),
                item.minimum.toDouble(),
                (item.minimum == 0 ? 1.0 : item.quantity / item.minimum) * 100,
              ],
            )
            .reduce(math.max)
            .ceilToDouble() +
        12;

    double scaleY(double value) => topPad + chartHeight - ((value / maxValue) * chartHeight);

    _drawGrid(canvas, size, leftPad, rightPad, topPad, chartHeight, maxValue);

    final quantityPoints = <Offset>[];
    final minimumPoints = <Offset>[];
    final coveragePoints = <Offset>[];
    final slot = items.length == 1 ? chartWidth : chartWidth / (items.length - 1);

    for (var i = 0; i < items.length; i++) {
      final x = leftPad + slot * i;
      final item = items[i];
      quantityPoints.add(Offset(x, scaleY(item.quantity.toDouble())));
      minimumPoints.add(Offset(x, scaleY(item.minimum.toDouble())));
      coveragePoints.add(Offset(x, scaleY((item.minimum == 0 ? 1.0 : item.quantity / item.minimum) * 100)));

      final labelPainter = TextPainter(
        text: TextSpan(
          text: item.name,
          style: const TextStyle(color: Color(0xFF677C76), fontSize: 11, fontWeight: FontWeight.w700),
        ),
        textDirection: TextDirection.rtl,
      )..layout(maxWidth: 88);
      labelPainter.paint(canvas, Offset(x - labelPainter.width / 2, size.height - 28));
    }

    _drawArea(
      canvas,
      quantityPoints,
      chartHeight + topPad,
      const [Color(0x300F766E), Color(0x050F766E)],
    );
    _drawArea(
      canvas,
      coveragePoints,
      chartHeight + topPad,
      const [Color(0x202563EB), Color(0x032563EB)],
    );

    _drawSmoothLine(canvas, quantityPoints, const Color(0xFF0F766E), 3.4);
    _drawDashedLine(canvas, minimumPoints, const Color(0xFFDC2626), 2.8);
    _drawSmoothLine(canvas, coveragePoints, const Color(0xFF2563EB), 3.0);

    _drawPoints(canvas, quantityPoints, const Color(0xFF0F766E));
    _drawPoints(canvas, minimumPoints, const Color(0xFFDC2626));
    _drawPoints(canvas, coveragePoints, const Color(0xFF2563EB));
  }

  void _drawGrid(
    Canvas canvas,
    Size size,
    double leftPad,
    double rightPad,
    double topPad,
    double chartHeight,
    double maxValue,
  ) {
    final solidPaint = Paint()
      ..color = const Color(0xFFDCE8E4)
      ..strokeWidth = 1;

    const rowCount = 5;
    for (var i = 0; i < rowCount; i++) {
      final y = topPad + chartHeight * i / (rowCount - 1);
      _drawDashedHorizontalLine(canvas, Offset(leftPad, y), Offset(size.width - rightPad, y), solidPaint);

      final value = (maxValue - (maxValue * i / (rowCount - 1))).round();
      final painter = TextPainter(
        text: TextSpan(text: '$value', style: const TextStyle(color: Color(0xFF70857F), fontSize: 11)),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, Offset(4, y - painter.height / 2));
    }
  }

  void _drawArea(Canvas canvas, List<Offset> points, double floorY, List<Color> colors) {
    if (points.isEmpty) {
      return;
    }

    final path = _smoothPath(points)
      ..lineTo(points.last.dx, floorY)
      ..lineTo(points.first.dx, floorY)
      ..close();

    final bounds = Rect.fromLTWH(points.first.dx, 0, points.last.dx - points.first.dx, floorY);
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: colors,
      ).createShader(bounds);
    canvas.drawPath(path, paint);
  }

  void _drawSmoothLine(Canvas canvas, List<Offset> points, Color color, double strokeWidth) {
    if (points.isEmpty) {
      return;
    }

    final paint = Paint()
      ..shader = LinearGradient(
        colors: [color.withValues(alpha: 0.85), color],
      ).createShader(Rect.fromLTWH(points.first.dx, 0, points.last.dx - points.first.dx, 1))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(_smoothPath(points), paint);
  }

  void _drawDashedLine(Canvas canvas, List<Offset> points, Color color, double strokeWidth) {
    if (points.length < 2) {
      return;
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    for (var i = 1; i < points.length; i++) {
      _drawDashedHorizontalLine(canvas, points[i - 1], points[i], paint, dashWidth: 10, dashSpace: 7);
    }
  }

  void _drawPoints(Canvas canvas, List<Offset> points, Color color) {
    final glowPaint = Paint()..color = color.withValues(alpha: 0.18);
    final fillPaint = Paint()..color = color;
    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (final point in points) {
      canvas.drawCircle(point, 10, glowPaint);
      canvas.drawCircle(point, 5, fillPaint);
      canvas.drawCircle(point, 5, strokePaint);
    }
  }

  Path _smoothPath(List<Offset> points) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final current = points[i];
      final controlX = (previous.dx + current.dx) / 2;
      path.cubicTo(controlX, previous.dy, controlX, current.dy, current.dx, current.dy);
    }
    return path;
  }

  void _drawDashedHorizontalLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint, {
    double dashWidth = 6,
    double dashSpace = 5,
  }) {
    final distance = (end - start).distance;
    final direction = (end - start) / distance;
    double current = 0;

    while (current < distance) {
      final dashStart = start + direction * current;
      final dashEnd = start + direction * math.min(current + dashWidth, distance);
      canvas.drawLine(dashStart, dashEnd, paint);
      current += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant InventoryLineChartPainter oldDelegate) => oldDelegate.items != items;
}

class _LegendStrokePainter extends CustomPainter {
  const _LegendStrokePainter({required this.color, required this.dashed});

  final Color color;
  final bool dashed;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.6;

    if (!dashed) {
      canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
      return;
    }

    double current = 0;
    while (current < size.width) {
      final end = math.min(current + 7, size.width);
      canvas.drawLine(Offset(current, size.height / 2), Offset(end, size.height / 2), paint);
      current += 11;
    }
  }

  @override
  bool shouldRepaint(covariant _LegendStrokePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.dashed != dashed;
  }
}


