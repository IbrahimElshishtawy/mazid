import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/profile/presentation/widgets/components/profile_models.dart';

class ProfileChartsGrid extends StatelessWidget {
  const ProfileChartsGrid({
    super.key,
    required this.financialReports,
    required this.production,
    required this.markets,
    required this.currencies,
    required this.summary,
  });

  final List<FinancialReport> financialReports;
  final List<ProductionPoint> production;
  final List<CompanyMarket> markets;
  final List<CurrencyPoint> currencies;
  final ProfileSummary summary;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 1100;
        final width = wide ? (constraints.maxWidth - 18) / 2 : constraints.maxWidth;

        return Wrap(
          spacing: 18,
          runSpacing: 18,
          children: [
            SizedBox(
              width: width,
              child: _ChartCard(
                title: '\u062C\u0631\u0627\u0641 \u0627\u0644\u0625\u064A\u0631\u0627\u062F \u0627\u0644\u062E\u0637\u064A',
                subtitle: '\u062D\u0631\u0643\u0629 \u0627\u0644\u0625\u064A\u0631\u0627\u062F \u0628\u064A\u0646 \u0627\u0644\u0641\u062A\u0631\u0627\u062A.',
                painter: _RevenueLinePainter(financialReports),
                height: 280,
              ),
            ),
            SizedBox(
              width: width,
              child: _ChartCard(
                title: '\u062C\u0631\u0627\u0641 \u0627\u0644\u0631\u0628\u062D \u0627\u0644\u0645\u0633\u0627\u062D\u064A',
                subtitle: '\u0627\u062A\u062C\u0627\u0647 \u0627\u0644\u0631\u0628\u062D\u064A\u0629 \u0628\u0634\u0643\u0644 \u0646\u0627\u0639\u0645.',
                painter: _ProfitAreaPainter(financialReports),
                height: 280,
              ),
            ),
            SizedBox(
              width: width,
              child: _ChartCard(
                title: '\u062C\u0631\u0627\u0641 \u0627\u0644\u0625\u0646\u062A\u0627\u062C \u0628\u0627\u0644\u0623\u0639\u0645\u062F\u0629',
                subtitle: '\u0627\u0644\u0641\u0639\u0644\u064A \u0645\u0642\u0627\u0628\u0644 \u0627\u0644\u0645\u0633\u062A\u0647\u062F\u0641.',
                painter: _ProductionBarsPainter(production),
                height: 280,
              ),
            ),
            SizedBox(
              width: width,
              child: _ChartCard(
                title: '\u062C\u0631\u0627\u0641 \u0627\u0644\u0623\u0633\u0648\u0627\u0642 \u0627\u0644\u062F\u0627\u0626\u0631\u064A',
                subtitle: '\u062A\u0648\u0632\u064A\u0639 \u0627\u0644\u0628\u064A\u0639 \u062D\u0633\u0628 \u0627\u0644\u0623\u0633\u0648\u0627\u0642.',
                painter: _MarketsDonutPainter(markets),
                height: 280,
              ),
            ),
            SizedBox(
              width: width,
              child: _ChartCard(
                title: '\u062C\u0631\u0627\u0641 \u0627\u0644\u0639\u0645\u0644\u0627\u062A',
                subtitle: '\u0645\u062A\u0627\u0628\u0639\u0629 \u0627\u0644\u0639\u0645\u0644\u0627\u062A \u0627\u0644\u0628\u064A\u0639\u064A\u0629 \u0627\u0644\u0631\u0626\u064A\u0633\u064A\u0629.',
                painter: _CurrencyBarsPainter(currencies),
                height: 280,
              ),
            ),
            SizedBox(
              width: width,
              child: _ChartCard(
                title: '\u062C\u0631\u0627\u0641 \u0627\u0644\u0633\u064A\u0648\u0644\u0629',
                subtitle: '\u0635\u0648\u0631\u0629 \u0633\u0631\u064A\u0639\u0629 \u0644\u062A\u062F\u0641\u0642 \u0627\u0644\u0646\u0642\u062F.',
                painter: _CashFlowPainter(summary),
                height: 280,
              ),
            ),
            SizedBox(
              width: width,
              child: _ChartCard(
                title: '\u062C\u0631\u0627\u0641 \u0627\u0644\u0645\u062E\u0627\u0637\u0631',
                subtitle: '\u0641\u0642\u0627\u0639\u0627\u062A \u062A\u0639\u0643\u0633 \u0627\u0644\u0636\u063A\u0637 \u0627\u0644\u0645\u0627\u0644\u064A \u0648\u0627\u0644\u062A\u0634\u063A\u064A\u0644\u064A.',
                painter: _BubbleRiskPainter(summary),
                height: 280,
              ),
            ),
            SizedBox(
              width: width,
              child: _ChartCard(
                title: '\u062C\u0631\u0627\u0641 \u0627\u0644\u0631\u0627\u062F\u0627\u0631 \u0627\u0644\u0627\u0633\u062A\u0631\u0627\u062A\u064A\u062C\u064A',
                subtitle: '\u0635\u0648\u0631\u0629 \u0643\u0644\u064A\u0629 \u0644\u0635\u0627\u062D\u0628 \u0627\u0644\u0642\u0631\u0627\u0631.',
                painter: _OwnerRadarPainter(summary),
                height: 280,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.title,
    required this.subtitle,
    required this.painter,
    required this.height,
  });

  final String title;
  final String subtitle;
  final CustomPainter painter;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: title,
      subtitle: subtitle,
      child: SizedBox(
        height: height,
        child: CustomPaint(painter: painter, size: Size.infinite),
      ),
    );
  }
}

class _RevenueLinePainter extends CustomPainter {
  const _RevenueLinePainter(this.reports);

  final List<FinancialReport> reports;

  @override
  void paint(Canvas canvas, Size size) {
    final list = reports.isEmpty
        ? const [FinancialReport(period: '\u0634\u0647\u0631', income: 100000, expenses: 70000, profit: 30000)]
        : reports;
    const left = 40.0;
    const right = 18.0;
    const top = 18.0;
    const bottom = 30.0;
    final width = size.width - left - right;
    final height = size.height - top - bottom;
    final maxValue = list.map((item) => item.income).reduce(math.max) + 10000;
    final points = <Offset>[];
    final slot = list.length <= 1 ? width : width / (list.length - 1);

    for (var i = 0; i < list.length; i++) {
      final x = left + slot * i;
      final y = top + height - ((list[i].income / maxValue) * height);
      points.add(Offset(x, y));

      final labelPainter = TextPainter(
        text: TextSpan(
          text: list[i].period,
          style: const TextStyle(color: Color(0xFF677C76), fontSize: 10, fontWeight: FontWeight.w700),
        ),
        textDirection: TextDirection.rtl,
      )..layout();
      labelPainter.paint(canvas, Offset(x - labelPainter.width / 2, size.height - 20));
    }

    final path = _smoothPath(points);
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF2563EB)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    for (final point in points) {
      canvas.drawCircle(point, 4.5, Paint()..color = const Color(0xFF2563EB));
    }
  }

  @override
  bool shouldRepaint(covariant _RevenueLinePainter oldDelegate) => oldDelegate.reports != reports;
}

class _ProfitAreaPainter extends CustomPainter {
  const _ProfitAreaPainter(this.reports);

  final List<FinancialReport> reports;

  @override
  void paint(Canvas canvas, Size size) {
    final list = reports.isEmpty
        ? const [FinancialReport(period: '\u0634\u0647\u0631', income: 100000, expenses: 70000, profit: 30000)]
        : reports;
    const left = 40.0;
    const right = 18.0;
    const top = 18.0;
    const bottom = 30.0;
    final width = size.width - left - right;
    final height = size.height - top - bottom;
    final maxValue = list.map((item) => item.profit).reduce(math.max) + 5000;
    final points = <Offset>[];
    final slot = list.length <= 1 ? width : width / (list.length - 1);

    for (var i = 0; i < list.length; i++) {
      final x = left + slot * i;
      final y = top + height - ((list[i].profit / maxValue) * height);
      points.add(Offset(x, y));
    }

    final line = _smoothPath(points);
    final area = Path.from(line)
      ..lineTo(points.last.dx, top + height)
      ..lineTo(points.first.dx, top + height)
      ..close();

    canvas.drawPath(
      area,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x6616A34A), Color(0x0516A34A)],
        ).createShader(Rect.fromLTWH(left, top, width, height)),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = const Color(0xFF16A34A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant _ProfitAreaPainter oldDelegate) => oldDelegate.reports != reports;
}

class _ProductionBarsPainter extends CustomPainter {
  const _ProductionBarsPainter(this.production);

  final List<ProductionPoint> production;

  @override
  void paint(Canvas canvas, Size size) {
    final list = production.isEmpty ? const [ProductionPoint(label: '\u0623', actual: 70, target: 84)] : production.take(5).toList();
    const left = 22.0;
    const right = 18.0;
    const top = 18.0;
    const bottom = 34.0;
    final width = size.width - left - right;
    final height = size.height - top - bottom;
    final barWidth = math.min(30.0, width / math.max(1, list.length * 2.2));
    final gap = (width - (barWidth * 2 * list.length)) / math.max(1, list.length);
    final maxValue = list.expand((item) => [item.actual, item.target]).reduce(math.max) + 10;

    for (var i = 0; i < list.length; i++) {
      final base = left + gap / 2 + i * ((barWidth * 2) + gap);
      final actualHeight = height * (list[i].actual / maxValue);
      final targetHeight = height * (list[i].target / maxValue);

      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(base, top + height - actualHeight, barWidth, actualHeight), const Radius.circular(10)),
        Paint()..color = const Color(0xFF0F766E),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(base + barWidth + 6, top + height - targetHeight, barWidth, targetHeight), const Radius.circular(10)),
        Paint()..color = const Color(0xFF94A3B8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ProductionBarsPainter oldDelegate) => oldDelegate.production != production;
}

class _MarketsDonutPainter extends CustomPainter {
  const _MarketsDonutPainter(this.markets);

  final List<CompanyMarket> markets;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.36, size.height * 0.5);
    final rect = Rect.fromCircle(center: center, radius: 76);
    const colors = [
      Color(0xFF0F766E),
      Color(0xFF2563EB),
      Color(0xFF16A34A),
      Color(0xFFF59E0B),
      Color(0xFF7C3AED),
    ];

    var start = -math.pi / 2;
    for (var i = 0; i < markets.length; i++) {
      final sweep = markets[i].share * math.pi * 2;
      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        Paint()
          ..color = colors[i % colors.length]
          ..style = PaintingStyle.stroke
          ..strokeWidth = 26
          ..strokeCap = StrokeCap.round,
      );
      start += sweep;
    }

    final labelPainter = TextPainter(
      text: const TextSpan(
        text: '\u0623\u0633\u0648\u0627\u0642\n\u0627\u0644\u0628\u064A\u0639',
        style: TextStyle(color: Color(0xFF111827), fontSize: 16, fontWeight: FontWeight.w900),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
    )..layout();
    labelPainter.paint(canvas, Offset(center.dx - labelPainter.width / 2, center.dy - labelPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _MarketsDonutPainter oldDelegate) => oldDelegate.markets != markets;
}

class _CurrencyBarsPainter extends CustomPainter {
  const _CurrencyBarsPainter(this.points);

  final List<CurrencyPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 24.0;
    const right = 18.0;
    const top = 18.0;
    const bottom = 34.0;
    final width = size.width - left - right;
    final height = size.height - top - bottom;
    final maxValue = points.map((item) => item.value).reduce(math.max) + 5;
    final barWidth = math.min(40.0, width / math.max(1, points.length * 1.8));
    final gap = (width - (barWidth * points.length)) / math.max(1, points.length);

    for (var i = 0; i < points.length; i++) {
      final x = left + gap / 2 + i * (barWidth + gap);
      final barHeight = height * (points[i].value / maxValue);
      final accent = points[i].change >= 0 ? const Color(0xFF2563EB) : const Color(0xFFDC2626);

      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, top + height - barHeight, barWidth, barHeight), const Radius.circular(12)),
        Paint()..color = accent,
      );

      final labelPainter = TextPainter(
        text: TextSpan(
          text: points[i].code,
          style: const TextStyle(color: Color(0xFF111827), fontSize: 10, fontWeight: FontWeight.w800),
        ),
        textDirection: TextDirection.rtl,
      )..layout();
      labelPainter.paint(canvas, Offset(x + (barWidth - labelPainter.width) / 2, size.height - 20));
    }
  }

  @override
  bool shouldRepaint(covariant _CurrencyBarsPainter oldDelegate) => oldDelegate.points != points;
}

class _CashFlowPainter extends CustomPainter {
  const _CashFlowPainter(this.summary);

  final ProfileSummary summary;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 24.0;
    final points = [summary.availableCash * 0.62, summary.totalExpenses * 0.38, summary.totalProfit * 0.52, summary.availableCash * 0.74];
    const labels = ['\u062F\u062E\u0644', '\u0645\u0635\u0631\u0648\u0641', '\u0631\u0628\u062D', '\u0633\u064A\u0648\u0644\u0629'];
    final maxValue = points.reduce(math.max) + 1000;

    for (var i = 0; i < points.length; i++) {
      final x = left + i * 70;
      final height = (size.height - 60) * (points[i] / maxValue);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, size.height - 34 - height, 44, height), const Radius.circular(12)),
        Paint()..color = i.isEven ? const Color(0xFF0F766E) : const Color(0xFF16A34A),
      );

      final labelPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: const TextStyle(color: Color(0xFF111827), fontSize: 10, fontWeight: FontWeight.w800),
        ),
        textDirection: TextDirection.rtl,
      )..layout();
      labelPainter.paint(canvas, Offset(x + (44 - labelPainter.width) / 2, size.height - 22));
    }
  }

  @override
  bool shouldRepaint(covariant _CashFlowPainter oldDelegate) => oldDelegate.summary != summary;
}

class _BubbleRiskPainter extends CustomPainter {
  const _BubbleRiskPainter(this.summary);

  final ProfileSummary summary;

  @override
  void paint(Canvas canvas, Size size) {
    final bubbles = [
      (Offset(size.width * 0.28, size.height * 0.42), 44.0, const Color(0xFFDC2626)),
      (Offset(size.width * 0.56, size.height * 0.36), 32.0, const Color(0xFFF59E0B)),
      (Offset(size.width * 0.46, size.height * 0.62), 54.0, const Color(0xFF2563EB)),
      (Offset(size.width * 0.72, size.height * 0.58), 26.0, const Color(0xFF16A34A)),
    ];

    for (final bubble in bubbles) {
      canvas.drawCircle(bubble.$1, bubble.$2, Paint()..color = bubble.$3.withValues(alpha: 0.22));
      canvas.drawCircle(
        bubble.$1,
        bubble.$2,
        Paint()
          ..color = bubble.$3.withValues(alpha: 0.72)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BubbleRiskPainter oldDelegate) => oldDelegate.summary != summary;
}

class _OwnerRadarPainter extends CustomPainter {
  const _OwnerRadarPainter(this.summary);

  final ProfileSummary summary;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final radius = math.min(size.width, size.height) * 0.28;
    final productionRatio = summary.totalTarget == 0 ? 0.0 : (summary.totalProduction / summary.totalTarget).clamp(0.0, 1.0).toDouble();
    final values = [
      productionRatio,
      summary.netMargin.clamp(0.0, 1.0).toDouble(),
      (1 - (summary.alertCount / 6)).clamp(0.0, 1.0).toDouble(),
      (summary.availableCash / (summary.totalExpenses + 1)).clamp(0.0, 1.0).toDouble(),
      0.82,
      0.76,
    ];

    for (var ring = 1; ring <= 4; ring++) {
      final ringRadius = radius * ring / 4;
      final path = Path();
      for (var i = 0; i < 6; i++) {
        final angle = -math.pi / 2 + (math.pi * 2 * i / 6);
        final point = Offset(center.dx + math.cos(angle) * ringRadius, center.dy + math.sin(angle) * ringRadius);
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFFDCE8E4)
          ..style = PaintingStyle.stroke,
      );
    }

    final dataPath = Path();
    for (var i = 0; i < 6; i++) {
      final angle = -math.pi / 2 + (math.pi * 2 * i / 6);
      final point = Offset(center.dx + math.cos(angle) * radius * values[i], center.dy + math.sin(angle) * radius * values[i]);
      if (i == 0) {
        dataPath.moveTo(point.dx, point.dy);
      } else {
        dataPath.lineTo(point.dx, point.dy);
      }
    }
    dataPath.close();

    canvas.drawPath(dataPath, Paint()..color = const Color(0x330F766E));
    canvas.drawPath(
      dataPath,
      Paint()
        ..color = const Color(0xFF0F766E)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4,
    );
  }

  @override
  bool shouldRepaint(covariant _OwnerRadarPainter oldDelegate) => oldDelegate.summary != summary;
}

Path _smoothPath(List<Offset> points) {
  if (points.length == 1) {
    return Path()..addOval(Rect.fromCircle(center: points.first, radius: 1));
  }

  final path = Path()..moveTo(points.first.dx, points.first.dy);
  for (var i = 1; i < points.length; i++) {
    final previous = points[i - 1];
    final current = points[i];
    final midX = (previous.dx + current.dx) / 2;
    path.cubicTo(midX, previous.dy, midX, current.dy, current.dx, current.dy);
  }
  return path;
}
