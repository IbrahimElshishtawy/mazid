import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/productivity/presentation/widgets/components/productivity_models.dart';

class ProductivityCharts extends StatelessWidget {
  const ProductivityCharts({
    super.key,
    required this.production,
    required this.machines,
  });

  final List<ProductionPoint> production;
  final List<MachineInfo> machines;

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
            SizedBox(width: chartWidth, child: ProductionFlowChart(production: production)),
            SizedBox(width: chartWidth, child: MachineLoadChart(machines: machines)),
          ],
        );
      },
    );
  }
}

class ProductionFlowChart extends StatelessWidget {
  const ProductionFlowChart({super.key, required this.production});

  final List<ProductionPoint> production;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'الجراف الخطي للإنتاج',
      subtitle: 'قراءة بصرية للفعلي مقابل المستهدف عبر دفعات أو فترات الإنتاج.',
      child: SizedBox(
        height: 320,
        child: CustomPaint(
          painter: _ProductionLinePainter(production.isEmpty ? const [ProductionPoint(label: 'تمهيدي', actual: 70, target: 82)] : production),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class MachineLoadChart extends StatelessWidget {
  const MachineLoadChart({super.key, required this.machines});

  final List<MachineInfo> machines;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'جراف تحميل الماكينات',
      subtitle: 'يبين كفاءة كل ماكينة ونسبة استغلالها الحالي على المنتجات النشطة.',
      child: SizedBox(
        height: 320,
        child: CustomPaint(
          painter: _MachineBarsPainter(machines),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _ProductionLinePainter extends CustomPainter {
  const _ProductionLinePainter(this.production);

  final List<ProductionPoint> production;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 44.0;
    const right = 18.0;
    const top = 18.0;
    const bottom = 34.0;
    final width = size.width - left - right;
    final height = size.height - top - bottom;
    final maxValue = production.expand((item) => [item.actual, item.target]).reduce(math.max) + 10;

    double yFor(double value) => top + height - ((value / maxValue) * height);

    final grid = Paint()
      ..color = const Color(0xFFDCE8E4)
      ..strokeWidth = 1;
    for (var i = 0; i < 5; i++) {
      final y = top + (height * i / 4);
      canvas.drawLine(Offset(left, y), Offset(size.width - right, y), grid);
    }

    final actualPoints = <Offset>[];
    final targetPoints = <Offset>[];
    final safeCount = production.length == 1 ? 2 : production.length;
    final slot = width / (safeCount - 1);

    for (var i = 0; i < production.length; i++) {
      final x = left + slot * i;
      final actualPoint = Offset(x, yFor(production[i].actual));
      final targetPoint = Offset(x, yFor(production[i].target));
      actualPoints.add(actualPoint);
      targetPoints.add(targetPoint);

      final label = TextPainter(
        text: TextSpan(
          text: production[i].label,
          style: const TextStyle(color: Color(0xFF677C76), fontSize: 11, fontWeight: FontWeight.w700),
        ),
        textDirection: TextDirection.rtl,
      )..layout();
      label.paint(canvas, Offset(x - (label.width / 2), size.height - 22));
    }

    final areaPath = _smooth(actualPoints)
      ..lineTo(actualPoints.last.dx, top + height)
      ..lineTo(actualPoints.first.dx, top + height)
      ..close();
    canvas.drawPath(
      areaPath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x550F766E), Color(0x050F766E)],
        ).createShader(Rect.fromLTWH(left, top, width, height)),
    );

    canvas.drawPath(
      _smooth(targetPoints),
      Paint()
        ..color = const Color(0xFF94A3B8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );
    canvas.drawPath(
      _smooth(actualPoints),
      Paint()
        ..color = const Color(0xFF0F766E)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.4,
    );

    for (final point in actualPoints) {
      canvas.drawCircle(point, 6, Paint()..color = const Color(0x220F766E));
      canvas.drawCircle(point, 4.5, Paint()..color = const Color(0xFF0F766E));
      canvas.drawCircle(point, 4.5, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
    }

    _drawLegend(canvas, const Offset(18, 8), const Color(0xFF0F766E), 'الفعلي');
    _drawLegend(canvas, const Offset(92, 8), const Color(0xFF94A3B8), 'المستهدف');
  }

  Path _smooth(List<Offset> points) {
    if (points.length == 1) {
      return Path()..addOval(Rect.fromCircle(center: points.first, radius: 1));
    }
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final current = points[i];
      final middle = (previous.dx + current.dx) / 2;
      path.cubicTo(middle, previous.dy, middle, current.dy, current.dx, current.dy);
    }
    return path;
  }

  void _drawLegend(Canvas canvas, Offset offset, Color color, String label) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(offset.dx, offset.dy + 4, 20, 8), const Radius.circular(999)),
      Paint()..color = color,
    );
    final painter = TextPainter(
      text: TextSpan(text: label, style: const TextStyle(color: Color(0xFF51635E), fontSize: 11, fontWeight: FontWeight.w700)),
      textDirection: TextDirection.rtl,
    )..layout();
    painter.paint(canvas, Offset(offset.dx + 28, offset.dy));
  }

  @override
  bool shouldRepaint(covariant _ProductionLinePainter oldDelegate) => oldDelegate.production != production;
}

class _MachineBarsPainter extends CustomPainter {
  const _MachineBarsPainter(this.machines);

  final List<MachineInfo> machines;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 18.0;
    const right = 18.0;
    const top = 20.0;
    const rowHeight = 62.0;
    final width = size.width - left - right;
    final list = machines.take(4).toList();

    for (var i = 0; i < list.length; i++) {
      final machine = list[i];
      final y = top + (rowHeight * i);
      final track = RRect.fromRectAndRadius(Rect.fromLTWH(left + 118, y + 20, width - 130, 14), const Radius.circular(999));
      final valueWidth = (width - 130) * machine.efficiency.clamp(0.0, 1.0);
      final bar = RRect.fromRectAndRadius(Rect.fromLTWH(left + 118, y + 20, valueWidth, 14), const Radius.circular(999));
      canvas.drawRRect(track, Paint()..color = const Color(0xFFDCE8E4));
      canvas.drawRRect(bar, Paint()..color = machine.accent);

      final machineName = TextPainter(
        text: TextSpan(text: machine.name, style: const TextStyle(color: Color(0xFF111827), fontSize: 12, fontWeight: FontWeight.w800)),
        textDirection: TextDirection.rtl,
      )..layout(maxWidth: 110);
      machineName.paint(canvas, Offset(left, y + 6));

      final label = TextPainter(
        text: TextSpan(text: formatPercent(machine.efficiency), style: TextStyle(color: machine.accent, fontSize: 12, fontWeight: FontWeight.w900)),
        textDirection: TextDirection.rtl,
      )..layout();
      label.paint(canvas, Offset(size.width - right - label.width, y + 4));

      final sub = TextPainter(
        text: TextSpan(text: machine.status, style: const TextStyle(color: Color(0xFF667B75), fontSize: 11, fontWeight: FontWeight.w600)),
        textDirection: TextDirection.rtl,
      )..layout(maxWidth: 110);
      sub.paint(canvas, Offset(left, y + 24));
    }
  }

  @override
  bool shouldRepaint(covariant _MachineBarsPainter oldDelegate) => oldDelegate.machines != machines;
}
