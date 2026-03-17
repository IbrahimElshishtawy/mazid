import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/finance/presentation/widgets/components/finance_metrics.dart';
import 'package:m_shop/features/finance/presentation/widgets/components/finance_models.dart';

class FinanceChartCard extends StatelessWidget {
  const FinanceChartCard({
    super.key,
    required this.reports,
    required this.summary,
  });

  final List<FinancialReport> reports;
  final FinanceSummary summary;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'الرسم البياني الخطي',
      subtitle: 'رسم خطي بعرض كامل يوضح الإيرادات والمصروفات والربح عبر كل الفترات.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              MiniLegendStat(label: 'الإيرادات', value: formatCurrency(summary.totalIncome), color: const Color(0xFF0F766E)),
              MiniLegendStat(label: 'المصروفات', value: formatCurrency(summary.totalExpenses), color: const Color(0xFFDC2626)),
              MiniLegendStat(label: 'الربح', value: formatCurrency(summary.totalProfit), color: const Color(0xFF2563EB)),
            ],
          ),
          const SizedBox(height: 18),
          const Wrap(
            spacing: 16,
            runSpacing: 10,
            children: [
              ChartLegendItem(label: 'الإيرادات', color: Color(0xFF0F766E)),
              ChartLegendItem(label: 'المصروفات', color: Color(0xFFDC2626)),
              ChartLegendItem(label: 'الربح', color: Color(0xFF2563EB)),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 360,
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.48),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2ECE8)),
            ),
            child: CustomPaint(
              painter: FinanceLineChartPainter(reports: reports),
              size: Size.infinite,
            ),
          ),
        ],
      ),
    );
  }
}

class ChartLegendItem extends StatelessWidget {
  const ChartLegendItem({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 26,
          height: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Color(0xFF5E746E), fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class FinanceLineChartPainter extends CustomPainter {
  const FinanceLineChartPainter({required this.reports});

  final List<FinancialReport> reports;

  @override
  void paint(Canvas canvas, Size size) {
    if (reports.isEmpty) {
      return;
    }

    const leftPad = 44.0;
    const rightPad = 18.0;
    const topPad = 18.0;
    const bottomPad = 34.0;
    final chartWidth = size.width - leftPad - rightPad;
    final chartHeight = size.height - topPad - bottomPad;
    final maxValue = reports
            .expand((report) => [report.income, report.expenses, report.profit])
            .reduce(math.max)
            .ceilToDouble() +
        12;

    double scaleY(double value) => topPad + chartHeight - ((value / maxValue) * chartHeight);

    final gridPaint = Paint()
      ..color = const Color(0xFFDDE8E4)
      ..strokeWidth = 1;

    const rowCount = 5;
    for (var i = 0; i < rowCount; i++) {
      final y = topPad + chartHeight * i / (rowCount - 1);
      canvas.drawLine(Offset(leftPad, y), Offset(size.width - rightPad, y), gridPaint);

      final value = (maxValue - (maxValue * i / (rowCount - 1))).round();
      final painter = TextPainter(
        text: TextSpan(text: '$value', style: const TextStyle(color: Color(0xFF70857F), fontSize: 11)),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, Offset(4, y - painter.height / 2));
    }

    final incomePoints = <Offset>[];
    final expensePoints = <Offset>[];
    final profitPoints = <Offset>[];
    final slot = reports.length == 1 ? chartWidth : chartWidth / (reports.length - 1);

    for (var i = 0; i < reports.length; i++) {
      final x = leftPad + slot * i;
      final report = reports[i];
      incomePoints.add(Offset(x, scaleY(report.income)));
      expensePoints.add(Offset(x, scaleY(report.expenses)));
      profitPoints.add(Offset(x, scaleY(report.profit)));

      final labelPainter = TextPainter(
        text: TextSpan(
          text: report.period,
          style: const TextStyle(color: Color(0xFF677C76), fontSize: 11, fontWeight: FontWeight.w700),
        ),
        textDirection: TextDirection.rtl,
      )..layout();
      labelPainter.paint(canvas, Offset(x - labelPainter.width / 2, size.height - 22));
    }

    _drawSmoothArea(canvas, incomePoints, chartHeight + topPad, const Color(0x110F766E));
    _drawLine(canvas, incomePoints, const Color(0xFF0F766E));
    _drawLine(canvas, expensePoints, const Color(0xFFDC2626));
    _drawLine(canvas, profitPoints, const Color(0xFF2563EB));
  }

  void _drawSmoothArea(Canvas canvas, List<Offset> points, double floorY, Color color) {
    if (points.isEmpty) {
      return;
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final current = points[i];
      final controlX = (previous.dx + current.dx) / 2;
      path.cubicTo(controlX, previous.dy, controlX, current.dy, current.dx, current.dy);
    }

    path
      ..lineTo(points.last.dx, floorY)
      ..lineTo(points.first.dx, floorY)
      ..close();

    canvas.drawPath(path, Paint()..color = color);
  }

  void _drawLine(Canvas canvas, List<Offset> points, Color color) {
    if (points.isEmpty) {
      return;
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final current = points[i];
      final controlX = (previous.dx + current.dx) / 2;
      path.cubicTo(controlX, previous.dy, controlX, current.dy, current.dx, current.dy);
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);

    final pointPaint = Paint()..color = color;
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
  bool shouldRepaint(covariant FinanceLineChartPainter oldDelegate) => oldDelegate.reports != reports;
}

