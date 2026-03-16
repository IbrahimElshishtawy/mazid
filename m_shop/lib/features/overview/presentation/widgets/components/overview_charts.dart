import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/overview/presentation/widgets/components/overview_models.dart';

class OverviewChartsGrid extends StatelessWidget {
  const OverviewChartsGrid({
    super.key,
    required this.attendance,
    required this.production,
    required this.financialReports,
    required this.cameraPoints,
    required this.payrollPoints,
  });

  final List<AttendanceRecord> attendance;
  final List<ProductionPoint> production;
  final List<FinancialReport> financialReports;
  final List<CameraPoint> cameraPoints;
  final List<PayrollPoint> payrollPoints;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 1100;
        final chartWidth = wide ? (constraints.maxWidth - 16) / 2 : constraints.maxWidth;

        return Column(
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(width: chartWidth, child: WorkersBarChartCard(attendance: attendance)),
                SizedBox(width: chartWidth, child: MachineAreaChartCard(production: production)),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(width: chartWidth, child: ProfitLineChartCard(financialReports: financialReports)),
                SizedBox(width: chartWidth, child: CamerasDonutChartCard(cameraPoints: cameraPoints, payrollPoints: payrollPoints)),
              ],
            ),
          ],
        );
      },
    );
  }
}

class WorkersBarChartCard extends StatelessWidget {
  const WorkersBarChartCard({super.key, required this.attendance});
  final List<AttendanceRecord> attendance;
  @override
  Widget build(BuildContext context) {
    return SectionCard(title: 'متابعة العمال', subtitle: 'مخطط أعمدة يقارن ساعات العمل الفعلية بالمستهدف اليومي لكل عامل.', child: SizedBox(height: 320, child: CustomPaint(painter: _WorkersBarPainter(attendance), size: Size.infinite)));
  }
}

class MachineAreaChartCard extends StatelessWidget {
  const MachineAreaChartCard({super.key, required this.production});
  final List<ProductionPoint> production;
  @override
  Widget build(BuildContext context) {
    return SectionCard(title: 'أداء المكن', subtitle: 'مخطط مساحي يوضح الفعلي مقابل المستهدف لقياس كفاءة خطوط التشغيل.', child: SizedBox(height: 320, child: CustomPaint(painter: _MachineAreaPainter(production), size: Size.infinite)));
  }
}

class ProfitLineChartCard extends StatelessWidget {
  const ProfitLineChartCard({super.key, required this.financialReports});
  final List<FinancialReport> financialReports;
  @override
  Widget build(BuildContext context) {
    return SectionCard(title: 'الأرباح والخسائر', subtitle: 'مخطط خطي يعرض الإيراد والمصروف والربح عبر الفترات المختلفة.', child: SizedBox(height: 320, child: CustomPaint(painter: _ProfitLinePainter(financialReports), size: Size.infinite)));
  }
}

class CamerasDonutChartCard extends StatelessWidget {
  const CamerasDonutChartCard({super.key, required this.cameraPoints, required this.payrollPoints});
  final List<CameraPoint> cameraPoints;
  final List<PayrollPoint> payrollPoints;
  @override
  Widget build(BuildContext context) {
    final averageCoverage = cameraPoints.fold<double>(0, (sum, point) => sum + point.coverage) / math.max(1, cameraPoints.length);
    final payroll = payrollPoints.fold<double>(0, (sum, point) => sum + point.salary);
    final deductions = payrollPoints.fold<double>(0, (sum, point) => sum + point.deduction);
    return SectionCard(
      title: 'الكاميرات والأجور والخصومات',
      subtitle: 'مخطط دائري لمراقبة التغطية، ومعه مؤشرات سريعة للأجور والخصومات.',
      child: SizedBox(
        height: 220,
        child: Row(children: [
          Expanded(child: Padding(padding: const EdgeInsetsDirectional.only(end: 6), child: CustomPaint(painter: _DonutPainter(coverage: averageCoverage), size: Size.infinite))),
          Expanded(child: Padding(padding: const EdgeInsetsDirectional.only(start: 6), child: SingleChildScrollView(physics: const BouncingScrollPhysics(), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            _MiniInfo(label: 'متوسط تغطية الكاميرات', value: '${(averageCoverage * 100).round()}%', color: const Color(0xFF0F766E)),
            const SizedBox(height: 10),
            _MiniInfo(label: 'إجمالي الأجور', value: formatMoney(payroll), color: const Color(0xFF2563EB)),
            const SizedBox(height: 10),
            _MiniInfo(label: 'إجمالي الخصومات', value: formatMoney(deductions), color: const Color(0xFFDC2626)),
          ])))),
        ]),
      ),
    );
  }
}

class _MiniInfo extends StatelessWidget {
  const _MiniInfo({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: const Color(0xFFF8FBFB), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withValues(alpha: 0.14))),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12.5)), const SizedBox(height: 4), Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17))]),
    );
  }
}

class _WorkersBarPainter extends CustomPainter { const _WorkersBarPainter(this.attendance); final List<AttendanceRecord> attendance; @override void paint(Canvas canvas, Size size) { const leftPad = 42.0, rightPad = 18.0, topPad = 18.0, bottomPad = 34.0; final width = size.width - leftPad - rightPad; final height = size.height - topPad - bottomPad; const maxValue = 10.0; final slot = width / attendance.length; final barWidth = slot * 0.28; final targetPaint = Paint()..color = const Color(0xFFD6E4E0); final actualPaint = Paint()..shader = const LinearGradient(colors: [Color(0xFF0F766E), Color(0xFF2DD4BF)]).createShader(Rect.fromLTWH(leftPad, topPad, width, height)); for (var i = 0; i < 5; i++) { final y = topPad + height * i / 4; canvas.drawLine(Offset(leftPad, y), Offset(size.width - rightPad, y), Paint()..color = const Color(0xFFDCE8E4)); } double scale(double value) => topPad + height - ((value / maxValue) * height); for (var i = 0; i < attendance.length; i++) { final item = attendance[i]; final center = leftPad + slot * i + slot / 2; final actualY = scale(item.workedHours); final targetY = scale(8); canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(center - barWidth - 2, targetY, barWidth, topPad + height - targetY), const Radius.circular(8)), targetPaint); canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(center + 2, actualY, barWidth, topPad + height - actualY), const Radius.circular(8)), actualPaint); final tp = TextPainter(text: TextSpan(text: item.name.split(' ').first, style: const TextStyle(color: Color(0xFF677C76), fontSize: 11, fontWeight: FontWeight.w700)), textDirection: TextDirection.rtl)..layout(maxWidth: slot); tp.paint(canvas, Offset(center - tp.width / 2, size.height - 22)); } } @override bool shouldRepaint(covariant _WorkersBarPainter oldDelegate) => oldDelegate.attendance != attendance; }
class _MachineAreaPainter extends CustomPainter { const _MachineAreaPainter(this.production); final List<ProductionPoint> production; @override void paint(Canvas canvas, Size size) { const left = 42.0, right = 18.0, top = 18.0, bottom = 34.0; final width = size.width - left - right; final height = size.height - top - bottom; final maxValue = production.expand((p) => [p.actual, p.target]).reduce(math.max) + 8; double scale(double value) => top + height - ((value / maxValue) * height); for (var i = 0; i < 5; i++) { final y = top + height * i / 4; canvas.drawLine(Offset(left, y), Offset(size.width - right, y), Paint()..color = const Color(0xFFDCE8E4)); } final actual = <Offset>[]; final target = <Offset>[]; final slot = width / (production.length - 1); for (var i = 0; i < production.length; i++) { final x = left + slot * i; actual.add(Offset(x, scale(production[i].actual))); target.add(Offset(x, scale(production[i].target))); final tp = TextPainter(text: TextSpan(text: production[i].label, style: const TextStyle(color: Color(0xFF677C76), fontSize: 11, fontWeight: FontWeight.w700)), textDirection: TextDirection.rtl)..layout(); tp.paint(canvas, Offset(x - tp.width / 2, size.height - 22)); } final area = _smooth(actual)..lineTo(actual.last.dx, top + height)..lineTo(actual.first.dx, top + height)..close(); canvas.drawPath(area, Paint()..shader = const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x330F766E), Color(0x040F766E)]).createShader(Rect.fromLTWH(left, top, width, height))); canvas.drawPath(_smooth(actual), Paint()..color = const Color(0xFF0F766E)..style = PaintingStyle.stroke..strokeWidth = 3); canvas.drawPath(_smooth(target), Paint()..color = const Color(0xFF94A3B8)..style = PaintingStyle.stroke..strokeWidth = 3); } Path _smooth(List<Offset> points) { final path = Path()..moveTo(points.first.dx, points.first.dy); for (var i = 1; i < points.length; i++) { final prev = points[i - 1]; final cur = points[i]; final cx = (prev.dx + cur.dx) / 2; path.cubicTo(cx, prev.dy, cx, cur.dy, cur.dx, cur.dy); } return path; } @override bool shouldRepaint(covariant _MachineAreaPainter oldDelegate) => oldDelegate.production != production; }
class _ProfitLinePainter extends CustomPainter { const _ProfitLinePainter(this.reports); final List<FinancialReport> reports; @override void paint(Canvas canvas, Size size) { const left = 42.0, right = 18.0, top = 18.0, bottom = 34.0; final width = size.width - left - right; final height = size.height - top - bottom; final maxValue = reports.expand((r) => [r.income, r.expenses, r.profit]).reduce(math.max) + 4000; double scale(double value) => top + height - ((value / maxValue) * height); for (var i = 0; i < 5; i++) { final y = top + height * i / 4; canvas.drawLine(Offset(left, y), Offset(size.width - right, y), Paint()..color = const Color(0xFFDCE8E4)); } final income = <Offset>[], expense = <Offset>[], profit = <Offset>[]; final slot = reports.length == 1 ? width : width / (reports.length - 1); for (var i = 0; i < reports.length; i++) { final x = left + slot * i; income.add(Offset(x, scale(reports[i].income))); expense.add(Offset(x, scale(reports[i].expenses))); profit.add(Offset(x, scale(reports[i].profit))); final tp = TextPainter(text: TextSpan(text: reports[i].period, style: const TextStyle(color: Color(0xFF677C76), fontSize: 11, fontWeight: FontWeight.w700)), textDirection: TextDirection.rtl)..layout(); tp.paint(canvas, Offset(x - tp.width / 2, size.height - 22)); } void draw(List<Offset> pts, Color c) { final p = _smooth(pts); canvas.drawPath(p, Paint()..color = c..style = PaintingStyle.stroke..strokeWidth = 3); for (final pt in pts) { canvas.drawCircle(pt, 5, Paint()..color = c); canvas.drawCircle(pt, 5, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2.5); } } draw(income, const Color(0xFF0F766E)); draw(expense, const Color(0xFFDC2626)); draw(profit, const Color(0xFF2563EB)); } Path _smooth(List<Offset> points) { final path = Path()..moveTo(points.first.dx, points.first.dy); for (var i = 1; i < points.length; i++) { final prev = points[i - 1]; final cur = points[i]; final cx = (prev.dx + cur.dx) / 2; path.cubicTo(cx, prev.dy, cx, cur.dy, cur.dx, cur.dy); } return path; } @override bool shouldRepaint(covariant _ProfitLinePainter oldDelegate) => oldDelegate.reports != reports; }
class _DonutPainter extends CustomPainter { const _DonutPainter({required this.coverage}); final double coverage; @override void paint(Canvas canvas, Size size) { final center = Offset(size.width / 2, size.height / 2); final radius = math.min(size.width, size.height) / 2 - 16; final rect = Rect.fromCircle(center: center, radius: radius); final bg = Paint()..color = const Color(0xFFE2ECE8)..style = PaintingStyle.stroke..strokeWidth = 18; final fg = Paint()..shader = const SweepGradient(colors: [Color(0xFF0F766E), Color(0xFF2563EB), Color(0xFF0F766E)]).createShader(rect)..style = PaintingStyle.stroke..strokeWidth = 18..strokeCap = StrokeCap.round; canvas.drawArc(rect, -math.pi / 2, math.pi * 2, false, bg); canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * coverage, false, fg); final tp = TextPainter(text: TextSpan(children: [TextSpan(text: '${(coverage * 100).round()}%\n', style: const TextStyle(color: Color(0xFF111827), fontSize: 28, fontWeight: FontWeight.w900)), const TextSpan(text: 'تغطية', style: TextStyle(color: Color(0xFF667B75), fontSize: 13, fontWeight: FontWeight.w700))]), textDirection: TextDirection.rtl, textAlign: TextAlign.center)..layout(maxWidth: size.width); tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2)); } @override bool shouldRepaint(covariant _DonutPainter oldDelegate) => oldDelegate.coverage != coverage; }
