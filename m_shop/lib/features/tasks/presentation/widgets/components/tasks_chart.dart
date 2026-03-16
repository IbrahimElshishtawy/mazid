import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/tasks/presentation/widgets/components/task_metrics.dart';
import 'package:m_shop/features/tasks/presentation/widgets/components/task_models.dart';

class TasksChartCard extends StatelessWidget {
  const TasksChartCard({super.key, required this.tasks, required this.summary});

  final List<TaskModel> tasks;
  final TaskSummary summary;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'الرسم البياني للمهام الماضية',
      subtitle: 'تحليل بصري احترافي يوضح نسب الإنجاز والحوافز والخصومات عبر المهام الحالية والماضية.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              MiniLegendStat(label: 'متوسط الإنجاز', value: '${(summary.averageProgress * 100).round()}%', color: const Color(0xFF0F766E)),
              MiniLegendStat(label: 'الحوافز', value: formatMoney(summary.totalBonuses), color: const Color(0xFF16A34A)),
              MiniLegendStat(label: 'الخصومات', value: formatMoney(summary.totalDeductions), color: const Color(0xFFDC2626)),
            ],
          ),
          const SizedBox(height: 18),
          const Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              ChartLegendItem(label: 'نسبة الإنجاز', color: Color(0xFF0F766E), dashed: false),
              ChartLegendItem(label: 'الحافز', color: Color(0xFF16A34A), dashed: false),
              ChartLegendItem(label: 'الخصم', color: Color(0xFFDC2626), dashed: true),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 390,
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFDFEFE), Color(0xFFF1F7F5), Color(0xFFEFF6FF)],
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFFDCE8E4)),
              boxShadow: const [BoxShadow(color: Color(0x120F172A), blurRadius: 20, offset: Offset(0, 10))],
            ),
            child: CustomPaint(
              painter: TasksLineChartPainter(tasks: tasks),
              size: Size.infinite,
            ),
          ),
        ],
      ),
    );
  }
}

class ChartLegendItem extends StatelessWidget {
  const ChartLegendItem({super.key, required this.label, required this.color, required this.dashed});

  final String label;
  final Color color;
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE2ECE8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 28, height: 10, child: CustomPaint(painter: _LegendStrokePainter(color: color, dashed: dashed))),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Color(0xFF5E746E), fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class TasksLineChartPainter extends CustomPainter {
  const TasksLineChartPainter({required this.tasks});

  final List<TaskModel> tasks;

  @override
  void paint(Canvas canvas, Size size) {
    if (tasks.isEmpty) {
      return;
    }

    const leftPad = 48.0;
    const rightPad = 20.0;
    const topPad = 22.0;
    const bottomPad = 42.0;
    final chartWidth = size.width - leftPad - rightPad;
    final chartHeight = size.height - topPad - bottomPad;
    final maxValue = tasks
            .expand((task) => [(task.progress * 100), _bonus(task).toDouble(), _deduction(task).toDouble()])
            .reduce(math.max)
            .ceilToDouble() +
        12;

    double scaleY(double value) => topPad + chartHeight - ((value / maxValue) * chartHeight);
    _drawGrid(canvas, size, leftPad, rightPad, topPad, chartHeight, maxValue);

    final progressPoints = <Offset>[];
    final bonusPoints = <Offset>[];
    final deductionPoints = <Offset>[];
    final slot = tasks.length == 1 ? chartWidth : chartWidth / (tasks.length - 1);

    for (var i = 0; i < tasks.length; i++) {
      final x = leftPad + slot * i;
      final task = tasks[i];
      progressPoints.add(Offset(x, scaleY(task.progress * 100)));
      bonusPoints.add(Offset(x, scaleY(_bonus(task).toDouble())));
      deductionPoints.add(Offset(x, scaleY(_deduction(task).toDouble())));

      final labelPainter = TextPainter(
        text: TextSpan(
          text: task.title,
          style: const TextStyle(color: Color(0xFF677C76), fontSize: 11, fontWeight: FontWeight.w700),
        ),
        textDirection: TextDirection.rtl,
      )..layout(maxWidth: 88);
      labelPainter.paint(canvas, Offset(x - labelPainter.width / 2, size.height - 28));
    }

    _drawArea(canvas, progressPoints, chartHeight + topPad, const [Color(0x300F766E), Color(0x050F766E)]);
    _drawSmoothLine(canvas, progressPoints, const Color(0xFF0F766E), 3.4);
    _drawSmoothLine(canvas, bonusPoints, const Color(0xFF16A34A), 3.0);
    _drawDashedLine(canvas, deductionPoints, const Color(0xFFDC2626), 2.8);
    _drawPoints(canvas, progressPoints, const Color(0xFF0F766E));
    _drawPoints(canvas, bonusPoints, const Color(0xFF16A34A));
    _drawPoints(canvas, deductionPoints, const Color(0xFFDC2626));
  }

  int _bonus(TaskModel task) => task.progress >= 0.85 ? 180 : task.progress >= 0.6 ? 90 : 0;
  int _deduction(TaskModel task) => task.progress < 0.25 ? 120 : task.progress < 0.4 ? 60 : 0;

  void _drawGrid(Canvas canvas, Size size, double leftPad, double rightPad, double topPad, double chartHeight, double maxValue) {
    final solidPaint = Paint()..color = const Color(0xFFDCE8E4)..strokeWidth = 1;
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
    if (points.isEmpty) return;
    final path = _smoothPath(points)..lineTo(points.last.dx, floorY)..lineTo(points.first.dx, floorY)..close();
    final bounds = Rect.fromLTWH(points.first.dx, 0, points.last.dx - points.first.dx, floorY);
    final paint = Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: colors).createShader(bounds);
    canvas.drawPath(path, paint);
  }

  void _drawSmoothLine(Canvas canvas, List<Offset> points, Color color, double strokeWidth) {
    if (points.isEmpty) return;
    final paint = Paint()
      ..shader = LinearGradient(colors: [color.withValues(alpha: 0.85), color]).createShader(Rect.fromLTWH(points.first.dx, 0, points.last.dx - points.first.dx, 1))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(_smoothPath(points), paint);
  }

  void _drawDashedLine(Canvas canvas, List<Offset> points, Color color, double strokeWidth) {
    if (points.length < 2) return;
    final paint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.round;
    for (var i = 1; i < points.length; i++) {
      _drawDashedHorizontalLine(canvas, points[i - 1], points[i], paint, dashWidth: 10, dashSpace: 7);
    }
  }

  void _drawPoints(Canvas canvas, List<Offset> points, Color color) {
    final glowPaint = Paint()..color = color.withValues(alpha: 0.18);
    final fillPaint = Paint()..color = color;
    final strokePaint = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 3;
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

  void _drawDashedHorizontalLine(Canvas canvas, Offset start, Offset end, Paint paint, {double dashWidth = 6, double dashSpace = 5}) {
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
  bool shouldRepaint(covariant TasksLineChartPainter oldDelegate) => oldDelegate.tasks != tasks;
}

class _LegendStrokePainter extends CustomPainter {
  const _LegendStrokePainter({required this.color, required this.dashed});

  final Color color;
  final bool dashed;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.stroke..strokeCap = StrokeCap.round..strokeWidth = 2.6;
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
  bool shouldRepaint(covariant _LegendStrokePainter oldDelegate) => oldDelegate.color != color || oldDelegate.dashed != dashed;
}
