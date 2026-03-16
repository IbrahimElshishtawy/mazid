import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/results/presentation/widgets/components/results_models.dart';

class ResultsChartsGrid extends StatelessWidget {
  const ResultsChartsGrid({
    super.key,
    required this.production,
    required this.tasks,
    required this.inventory,
    required this.financialReports,
    required this.attendance,
    required this.alerts,
    required this.summary,
  });

  final List<ProductionPoint> production;
  final List<TaskModel> tasks;
  final List<InventoryItem> inventory;
  final List<FinancialReport> financialReports;
  final List<AttendanceRecord> attendance;
  final List<AlertModel> alerts;
  final ResultsSummary summary;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 1100;
        final chartWidth = wide ? (constraints.maxWidth - 18) / 2 : constraints.maxWidth;
        return Wrap(
          spacing: 18,
          runSpacing: 18,
          children: [
            SizedBox(width: chartWidth, child: _ProductionLineCard(production: production)),
            SizedBox(width: chartWidth, child: _TaskBarsCard(tasks: tasks)),
            SizedBox(width: chartWidth, child: _InventoryDonutCard(inventory: inventory)),
            SizedBox(width: chartWidth, child: _ProfitAreaCard(financialReports: financialReports)),
            SizedBox(width: constraints.maxWidth, child: _FactoryRadarCard(summary: summary, attendance: attendance, alerts: alerts)),
          ],
        );
      },
    );
  }
}

class _ProductionLineCard extends StatelessWidget {
  const _ProductionLineCard({required this.production});
  final List<ProductionPoint> production;
  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'جراف خطي للإنتاج',
      subtitle: 'يوضح الفعلي مقابل المستهدف على مدار الفترات أو الدفعات.',
      child: SizedBox(height: 300, child: CustomPaint(painter: _LineChartPainter(production), size: Size.infinite)),
    );
  }
}

class _TaskBarsCard extends StatelessWidget {
  const _TaskBarsCard({required this.tasks});
  final List<TaskModel> tasks;
  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'جراف أعمدة للمهام',
      subtitle: 'قراءة سريعة لمستوى التقدم في المهام الحالية.',
      child: SizedBox(height: 300, child: CustomPaint(painter: _TaskBarPainter(tasks), size: Size.infinite)),
    );
  }
}

class _InventoryDonutCard extends StatelessWidget {
  const _InventoryDonutCard({required this.inventory});
  final List<InventoryItem> inventory;
  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'جراف دائري للمخزون',
      subtitle: 'توزيع المخزون الحالي بين العناصر الأساسية داخل المصنع.',
      child: SizedBox(height: 300, child: CustomPaint(painter: _DonutPainter(inventory), size: Size.infinite)),
    );
  }
}

class _ProfitAreaCard extends StatelessWidget {
  const _ProfitAreaCard({required this.financialReports});
  final List<FinancialReport> financialReports;
  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'جراف مساحي للربحية',
      subtitle: 'اتجاه الربح عبر الفترات مع قراءة بصرية ناعمة وواضحة.',
      child: SizedBox(height: 300, child: CustomPaint(painter: _AreaChartPainter(financialReports), size: Size.infinite)),
    );
  }
}

class _FactoryRadarCard extends StatelessWidget {
  const _FactoryRadarCard({required this.summary, required this.attendance, required this.alerts});
  final ResultsSummary summary;
  final List<AttendanceRecord> attendance;
  final List<AlertModel> alerts;
  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'جراف رادار للصورة الاستراتيجية',
      subtitle: 'ملخص شامل لعناصر القوة والضغط داخل المصنع في رسم واحد.',
      child: SizedBox(height: 340, child: CustomPaint(painter: _RadarPainter(summary: summary, attendance: attendance, alerts: alerts), size: Size.infinite)),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  const _LineChartPainter(this.production);
  final List<ProductionPoint> production;
  @override
  void paint(Canvas canvas, Size size) {
    final list = production.isEmpty ? const [ProductionPoint(label: 'تمهيدي', actual: 72, target: 84)] : production;
    const left = 44.0, right = 18.0, top = 18.0, bottom = 34.0;
    final width = size.width - left - right;
    final height = size.height - top - bottom;
    final maxValue = list.expand((item) => [item.actual, item.target]).reduce(math.max) + 10;
    double yFor(double value) => top + height - ((value / maxValue) * height);
    for (var i = 0; i < 5; i++) {
      final y = top + height * i / 4;
      canvas.drawLine(Offset(left, y), Offset(size.width - right, y), Paint()..color = const Color(0xFFDCE8E4));
    }
    final actualPoints = <Offset>[];
    final targetPoints = <Offset>[];
    final slot = list.length == 1 ? width : width / (list.length - 1);
    for (var i = 0; i < list.length; i++) {
      final x = left + slot * i;
      actualPoints.add(Offset(x, yFor(list[i].actual)));
      targetPoints.add(Offset(x, yFor(list[i].target)));
      final painter = TextPainter(text: TextSpan(text: list[i].label, style: const TextStyle(color: Color(0xFF677C76), fontSize: 11, fontWeight: FontWeight.w700)), textDirection: TextDirection.rtl)..layout();
      painter.paint(canvas, Offset(x - painter.width / 2, size.height - 22));
    }
    canvas.drawPath(_smooth(actualPoints), Paint()..color = const Color(0xFF0F766E)..style = PaintingStyle.stroke..strokeWidth = 3.2);
    canvas.drawPath(_smooth(targetPoints), Paint()..color = const Color(0xFF94A3B8)..style = PaintingStyle.stroke..strokeWidth = 2.4);
    for (final point in actualPoints) {
      canvas.drawCircle(point, 5.5, Paint()..color = const Color(0xFF0F766E));
      canvas.drawCircle(point, 5.5, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
    }
  }

  Path _smooth(List<Offset> points) {
    if (points.length == 1) return Path()..addOval(Rect.fromCircle(center: points.first, radius: 1));
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final current = points[i];
      final cx = (prev.dx + current.dx) / 2;
      path.cubicTo(cx, prev.dy, cx, current.dy, current.dx, current.dy);
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) => oldDelegate.production != production;
}

class _TaskBarPainter extends CustomPainter {
  const _TaskBarPainter(this.tasks);
  final List<TaskModel> tasks;
  @override
  void paint(Canvas canvas, Size size) {
    final list = tasks.take(5).toList();
    const left = 22.0, right = 18.0, top = 18.0, bottom = 36.0;
    final width = size.width - left - right;
    final height = size.height - top - bottom;
    final barWidth = math.min(54.0, width / math.max(1, list.length * 1.4));
    final gap = list.isEmpty ? 0.0 : (width - (barWidth * list.length)) / math.max(1, list.length);
    canvas.drawLine(Offset(left, top + height), Offset(size.width - right, top + height), Paint()..color = const Color(0xFFDCE8E4));
    for (var i = 0; i < list.length; i++) {
      final task = list[i];
      final x = left + gap / 2 + i * (barWidth + gap);
      final barHeight = height * task.progress.clamp(0.0, 1.0);
      final rect = RRect.fromRectAndRadius(Rect.fromLTWH(x, top + height - barHeight, barWidth, barHeight), const Radius.circular(16));
      final accent = task.progress >= 0.8 ? const Color(0xFF16A34A) : task.progress >= 0.45 ? const Color(0xFF2563EB) : const Color(0xFFF59E0B);
      canvas.drawRRect(rect, Paint()..color = accent);
      final percent = TextPainter(text: TextSpan(text: '${(task.progress * 100).round()}%', style: TextStyle(color: accent, fontSize: 11, fontWeight: FontWeight.w800)), textDirection: TextDirection.rtl)..layout();
      percent.paint(canvas, Offset(x + (barWidth - percent.width) / 2, top + height - barHeight - 18));
      final label = TextPainter(text: TextSpan(text: task.title, style: const TextStyle(color: Color(0xFF677C76), fontSize: 10, fontWeight: FontWeight.w700)), maxLines: 2, textDirection: TextDirection.rtl)..layout(maxWidth: 72);
      label.paint(canvas, Offset(x - ((72 - barWidth) / 2), size.height - 30));
    }
  }

  @override
  bool shouldRepaint(covariant _TaskBarPainter oldDelegate) => oldDelegate.tasks != tasks;
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter(this.inventory);
  final List<InventoryItem> inventory;
  @override
  void paint(Canvas canvas, Size size) {
    final list = inventory.isEmpty
        ? const [InventoryItem(name: 'مخزون أساسي', quantity: 120, minimum: 80, unit: 'وحدة')]
        : inventory;
    final total = list.fold<int>(0, (sum, item) => sum + item.quantity).toDouble();
    final center = Offset(size.width * 0.35, size.height * 0.5);
    final rect = Rect.fromCircle(center: center, radius: 82);
    final colors = [const Color(0xFF0F766E), const Color(0xFF2563EB), const Color(0xFFF59E0B), const Color(0xFF7C3AED)];
    var start = -math.pi / 2;
    for (var i = 0; i < list.length; i++) {
      final sweep = ((list[i].quantity / total) * math.pi * 2).toDouble();
      canvas.drawArc(rect, start, sweep, false, Paint()..color = colors[i % colors.length]..style = PaintingStyle.stroke..strokeWidth = 28..strokeCap = StrokeCap.round);
      start += sweep;
    }
    final inner = TextPainter(text: TextSpan(text: '${total.round()}\nمخزون', style: const TextStyle(color: Color(0xFF111827), fontSize: 16, fontWeight: FontWeight.w900)), textAlign: TextAlign.center, textDirection: TextDirection.rtl)..layout();
    inner.paint(canvas, Offset(center.dx - inner.width / 2, center.dy - inner.height / 2));
    final legendX = size.width * 0.62;
    for (var i = 0; i < list.length; i++) {
      final y = 60.0 + i * 48;
      final color = colors[i % colors.length];
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(legendX, y + 5, 16, 16), const Radius.circular(6)), Paint()..color = color);
      final label = TextPainter(text: TextSpan(text: list[i].name, style: const TextStyle(color: Color(0xFF111827), fontSize: 12, fontWeight: FontWeight.w800)), textDirection: TextDirection.rtl)..layout(maxWidth: size.width - legendX - 60);
      label.paint(canvas, Offset(legendX + 24, y));
      final sub = TextPainter(text: TextSpan(text: '${list[i].quantity} ${list[i].unit}', style: const TextStyle(color: Color(0xFF667B75), fontSize: 11, fontWeight: FontWeight.w700)), textDirection: TextDirection.rtl)..layout();
      sub.paint(canvas, Offset(legendX + 24, y + 18));
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) => oldDelegate.inventory != inventory;
}

class _AreaChartPainter extends CustomPainter {
  const _AreaChartPainter(this.financialReports);
  final List<FinancialReport> financialReports;
  @override
  void paint(Canvas canvas, Size size) {
    final list = financialReports.isEmpty
        ? const [FinancialReport(period: 'افتراضي', income: 100000, expenses: 70000, profit: 30000)]
        : financialReports;
    const left = 44.0, right = 18.0, top = 18.0, bottom = 34.0;
    final width = size.width - left - right;
    final height = size.height - top - bottom;
    final maxValue = list.map((item) => item.profit).reduce(math.max) + 10000;
    double yFor(double value) => top + height - ((value / maxValue) * height);
    final points = <Offset>[];
    final slot = list.length == 1 ? width : width / (list.length - 1);
    for (var i = 0; i < list.length; i++) {
      final x = left + slot * i;
      points.add(Offset(x, yFor(list[i].profit)));
      final painter = TextPainter(text: TextSpan(text: list[i].period, style: const TextStyle(color: Color(0xFF677C76), fontSize: 11, fontWeight: FontWeight.w700)), textDirection: TextDirection.rtl)..layout();
      painter.paint(canvas, Offset(x - painter.width / 2, size.height - 22));
    }
    final line = _smooth(points);
    final area = Path.from(line)..lineTo(points.last.dx, top + height)..lineTo(points.first.dx, top + height)..close();
    canvas.drawPath(area, Paint()..shader = const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x6616A34A), Color(0x0516A34A)]).createShader(Rect.fromLTWH(left, top, width, height)));
    canvas.drawPath(line, Paint()..color = const Color(0xFF16A34A)..style = PaintingStyle.stroke..strokeWidth = 3.4);
    for (final point in points) {
      canvas.drawCircle(point, 5, Paint()..color = const Color(0xFF16A34A));
      canvas.drawCircle(point, 5, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
    }
  }

  Path _smooth(List<Offset> points) {
    if (points.length == 1) return Path()..addOval(Rect.fromCircle(center: points.first, radius: 1));
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final current = points[i];
      final middle = (prev.dx + current.dx) / 2;
      path.cubicTo(middle, prev.dy, middle, current.dy, current.dx, current.dy);
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant _AreaChartPainter oldDelegate) => oldDelegate.financialReports != financialReports;
}

class _RadarPainter extends CustomPainter {
  const _RadarPainter({required this.summary, required this.attendance, required this.alerts});
  final ResultsSummary summary;
  final List<AttendanceRecord> attendance;
  final List<AlertModel> alerts;
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.28, size.height * 0.56);
    final radius = math.min(120.0, size.height * 0.32);
    final labels = ['تنفيذ', 'حضور', 'ربحية', 'مخزون', 'مخاطر', 'استقرار'];
    final values = [
      summary.executionRate.clamp(0.0, 1.0),
      summary.attendanceRate.clamp(0.0, 1.0),
      (summary.totalProfit / math.max(1, summary.totalExpenses)).clamp(0.0, 1.0),
      (summary.totalInventory / 1000).clamp(0.0, 1.0),
      (1 - summary.riskRate).clamp(0.0, 1.0),
      (1 - (alerts.length / 8)).clamp(0.0, 1.0),
    ];
    for (var ring = 1; ring <= 4; ring++) {
      final ringRadius = radius * ring / 4;
      final path = Path();
      for (var i = 0; i < labels.length; i++) {
        final angle = (-math.pi / 2) + (math.pi * 2 * i / labels.length);
        final point = Offset(center.dx + math.cos(angle) * ringRadius, center.dy + math.sin(angle) * ringRadius);
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
      canvas.drawPath(path, Paint()..color = const Color(0xFFDCE8E4)..style = PaintingStyle.stroke);
    }
    final dataPath = Path();
    for (var i = 0; i < labels.length; i++) {
      final angle = (-math.pi / 2) + (math.pi * 2 * i / labels.length);
      final point = Offset(center.dx + math.cos(angle) * radius * values[i], center.dy + math.sin(angle) * radius * values[i]);
      if (i == 0) {
        dataPath.moveTo(point.dx, point.dy);
      } else {
        dataPath.lineTo(point.dx, point.dy);
      }
      canvas.drawLine(center, Offset(center.dx + math.cos(angle) * radius, center.dy + math.sin(angle) * radius), Paint()..color = const Color(0xFFE3ECE8));
      final labelPainter = TextPainter(text: TextSpan(text: labels[i], style: const TextStyle(color: Color(0xFF51635E), fontSize: 12, fontWeight: FontWeight.w800)), textDirection: TextDirection.rtl)..layout();
      labelPainter.paint(canvas, Offset(center.dx + math.cos(angle) * (radius + 18) - labelPainter.width / 2, center.dy + math.sin(angle) * (radius + 18) - labelPainter.height / 2));
    }
    dataPath.close();
    canvas.drawPath(dataPath, Paint()..color = const Color(0x330F766E)..style = PaintingStyle.fill);
    canvas.drawPath(dataPath, Paint()..color = const Color(0xFF0F766E)..style = PaintingStyle.stroke..strokeWidth = 2.6);

    final sideX = size.width * 0.56;
    final lines = [
      'النتيجة العامة: ${summary.strategicState}',
      'الالتزام بالحضور: ${formatPercent(summary.attendanceRate)}',
      'الضغط التشغيلي الحالي: ${formatPercent(summary.riskRate)}',
      'التنبيهات المفتوحة: ${summary.alertCount}',
      'المهام الجاري تنفيذها: ${summary.inProgressTasks}',
    ];
    for (var i = 0; i < lines.length; i++) {
      final y = 76.0 + i * 44;
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(sideX, y, size.width - sideX - 12, 34), const Radius.circular(14)), Paint()..color = const Color(0xFFF7FAF9));
      final tp = TextPainter(text: TextSpan(text: lines[i], style: const TextStyle(color: Color(0xFF111827), fontSize: 12, fontWeight: FontWeight.w800)), textDirection: TextDirection.rtl)..layout(maxWidth: size.width - sideX - 24);
      tp.paint(canvas, Offset(sideX + 12, y + 9));
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) => oldDelegate.summary != summary || oldDelegate.attendance != attendance || oldDelegate.alerts != alerts;
}
