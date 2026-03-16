import 'package:flutter/material.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/overview/presentation/widgets/components/overview_charts.dart';
import 'package:m_shop/features/overview/presentation/widgets/components/overview_hero.dart';
import 'package:m_shop/features/overview/presentation/widgets/components/overview_metrics.dart';
import 'package:m_shop/features/overview/presentation/widgets/components/overview_models.dart';
import 'package:m_shop/features/overview/presentation/widgets/components/overview_panels.dart';
import 'package:m_shop/features/overview/presentation/widgets/components/overview_sheet.dart';

class OverviewSection extends StatelessWidget {
  const OverviewSection({
    super.key,
    required this.users,
    required this.attendance,
    required this.production,
    required this.tasks,
    required this.inventory,
    required this.financialReports,
    required this.alerts,
  });

  final List<UserModel> users;
  final List<AttendanceRecord> attendance;
  final List<ProductionPoint> production;
  final List<TaskModel> tasks;
  final List<InventoryItem> inventory;
  final List<FinancialReport> financialReports;
  final List<AlertModel> alerts;

  @override
  Widget build(BuildContext context) {
    final summary = OverviewSummary.fromData(
      users: users,
      attendance: attendance,
      production: production,
      tasks: tasks,
      inventory: inventory,
      financialReports: financialReports,
      alerts: alerts,
    );
    final layout = OverviewLayout.fromWidth(MediaQuery.sizeOf(context).width);
    final cameraPoints = buildCameraPoints(alerts);
    final payrollPoints = buildPayrollPoints(attendance);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1180),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OverviewHero(
              summary: summary,
              onOpenFactory: () => _showFactoryReport(context, summary),
              onOpenCameras: () => _showCameras(context, cameraPoints),
            ),
            const SizedBox(height: 24),
            const _SectionLead(
              eyebrow: 'نظرة شاملة',
              title: 'مؤشرات المصنع الأساسية',
              subtitle: 'أرقام سريعة تساعدك تفهم وضع المصنع قبل الدخول في التفاصيل والتحليلات.',
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                OverviewMetricCard(width: layout.metricWidth, title: 'العمال في الوردية', value: '${summary.workersOnShift}', note: 'عدد العمال أو المشرفين الموجودين الآن في دورة العمل الحالية', accent: const Color(0xFF0F766E), icon: Icons.groups_rounded),
                OverviewMetricCard(width: layout.metricWidth, title: 'كفاءة المكن', value: '${(summary.machineEfficiency * 100).round()}%', note: 'قياس تقريبي للأداء الفعلي مقارنة بالمستهدف في خطوط التشغيل', accent: const Color(0xFF2563EB), icon: Icons.precision_manufacturing_rounded),
                OverviewMetricCard(width: layout.metricWidth, title: 'الأرباح', value: formatMoney(summary.totalProfit), note: 'إجمالي الربح المجمع من الفترات المسجلة حالياً', accent: const Color(0xFF16A34A), icon: Icons.trending_up_rounded),
                OverviewMetricCard(width: layout.metricWidth, title: 'الخسائر والأعباء', value: formatMoney(summary.totalLosses), note: 'قراءة تقديرية للضغط المالي والخسائر التشغيلية الحالية', accent: const Color(0xFFDC2626), icon: Icons.trending_down_rounded),
                OverviewMetricCard(width: layout.metricWidth, title: 'الأجور', value: formatMoney(summary.totalPayroll), note: 'إجمالي الأجور التقريبية المرتبطة بالحضور وساعات العمل الحالية', accent: const Color(0xFF7C3AED), icon: Icons.payments_rounded),
                OverviewMetricCard(width: layout.metricWidth, title: 'الخصومات', value: formatMoney(summary.totalDeductions), note: 'إجمالي الخصومات المقترحة الناتجة عن تأخر تنفيذ المهام', accent: const Color(0xFFF59E0B), icon: Icons.money_off_csred_rounded),
              ],
            ),
            const SizedBox(height: 28),
            const _SectionLead(
              eyebrow: 'تشغيل مباشر',
              title: 'محطات المتابعة السريعة',
              subtitle: 'وصول سريع لأهم ملفات العمال والمكن والماليات والصيانة من مكان واحد.',
            ),
            const SizedBox(height: 14),
            OverviewActionPanel(
              onWorkers: () => _showWorkers(context, attendance, tasks),
              onMachines: () => _showMachines(context, production, alerts),
              onFinance: () => _showFinance(context, financialReports, summary),
              onMaintenance: () => _showMaintenance(context, tasks, production),
              onPayroll: () => _showPayroll(context, payrollPoints, summary),
            ),
            const SizedBox(height: 28),
            const _SectionLead(
              eyebrow: 'تحليلات بصرية',
              title: 'لوحات الرسوم البيانية',
              subtitle: 'تنسيق منظم لأربعة جرافات مختلفة تغطي العمال والمكن والماليات والكاميرات.',
            ),
            const SizedBox(height: 14),
            OverviewChartsGrid(
              attendance: attendance,
              production: production,
              financialReports: financialReports,
              cameraPoints: cameraPoints,
              payrollPoints: payrollPoints,
            ),
            const SizedBox(height: 28),
            const _SectionLead(
              eyebrow: 'متابعة وتحسين',
              title: 'المراقبة الحية والفرص التشغيلية',
              subtitle: 'قسم نهائي للملاحظات اللحظية والأفكار المقترحة لتحسين أداء المصنع.',
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 18,
              runSpacing: 18,
              children: [
                SizedBox(width: layout.primaryWidth, child: FactoryMonitorPanel(alerts: alerts, cameraPoints: cameraPoints, summary: summary)),
                SizedBox(width: layout.secondaryWidth, child: ImprovementsPanel(tasks: tasks, inventory: inventory)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showFactoryReport(BuildContext context, OverviewSummary summary) {
    return showOverviewInfoSheet(
      context: context,
      title: 'تقرير المصنع',
      subtitle: 'ملخص تنفيذي لحالة المصنع الآن من منظور العمال والمكن والماليات.',
      children: [
        OverviewSheetLine(label: 'حالة المصنع', value: summary.factoryState),
        OverviewSheetLine(label: 'العمال الحاضرون', value: '${summary.presentWorkers}'),
        OverviewSheetLine(label: 'كفاءة المكن', value: '${(summary.machineEfficiency * 100).round()}%'),
        OverviewSheetLine(label: 'الأرباح', value: formatMoney(summary.totalProfit)),
        OverviewSheetMessage(message: 'المؤشرات الحالية مناسبة للمتابعة اللحظية وتساعد الإدارة على رصد نقاط الخطر بسرعة قبل تحولها إلى مشكلة تشغيلية أكبر.'),
      ],
    );
  }

  Future<void> _showCameras(BuildContext context, List<CameraPoint> cameraPoints) {
    return showOverviewInfoSheet(
      context: context,
      title: 'متابعة الكاميرات',
      subtitle: 'رؤية سريعة لنقاط التغطية والمناطق التي تحتاج متابعة أو تحسين.',
      children: cameraPoints
          .map((camera) => OverviewSheetLine(label: camera.name, value: camera.online ? '${(camera.coverage * 100).round()}%' : 'متوقفة'))
          .toList(),
    );
  }

  Future<void> _showWorkers(BuildContext context, List<AttendanceRecord> attendance, List<TaskModel> tasks) {
    final present = attendance.where((record) => record.present).length;
    final activeTasks = tasks.where((task) => task.progress > 0 && task.progress < 1).length;
    return showOverviewInfoSheet(
      context: context,
      title: 'متابعة العمال',
      subtitle: 'قراءة مرتبطة بالحضور والمهام الجارية والانضباط التشغيلي.',
      children: [
        OverviewSheetLine(label: 'الحضور الحالي', value: '$present عامل'),
        OverviewSheetLine(label: 'المهام النشطة', value: '$activeTasks مهام'),
        const OverviewSheetLine(label: 'وضع الانضباط', value: 'جيد مع حاجة لمتابعة الحالات المتأخرة'),
        const OverviewSheetMessage(message: 'ينصح بربط شاشة الحضور بالمهام المفتوحة لتحديد من لديه حمل أكبر أو تأخير متكرر.'),
      ],
    );
  }

  Future<void> _showMachines(BuildContext context, List<ProductionPoint> production, List<AlertModel> alerts) {
    final avg = production.fold<double>(0, (sum, p) => sum + (p.actual / p.target)) / production.length;
    return showOverviewInfoSheet(
      context: context,
      title: 'متابعة المكن',
      subtitle: 'ملخص للكفاءة والأعطال والتنبيهات الخاصة بخطوط التشغيل.',
      children: [
        OverviewSheetLine(label: 'متوسط الكفاءة', value: '${(avg * 100).round()}%'),
        OverviewSheetLine(label: 'عدد التنبيهات', value: '${alerts.length}'),
        const OverviewSheetLine(label: 'توصية الصيانة', value: 'رفع المتابعة الوقائية للخطوط الأعلى ضغطاً'),
        const OverviewSheetMessage(message: 'المكن تحتاج متابعة لحظية مع دمج بيانات الأعطال والصيانة الوقائية لتحسين الجاهزية وتقليل التوقف المفاجئ.'),
      ],
    );
  }

  Future<void> _showFinance(BuildContext context, List<FinancialReport> financialReports, OverviewSummary summary) {
    return showOverviewInfoSheet(
      context: context,
      title: 'متابعة الأرباح والخسائر والقبض',
      subtitle: 'قراءة مالية مبسطة للمصنع مع الربحية الحالية والضغط المالي.',
      children: [
        OverviewSheetLine(label: 'عدد الفترات المالية', value: '${financialReports.length}'),
        OverviewSheetLine(label: 'إجمالي الربح', value: formatMoney(summary.totalProfit)),
        OverviewSheetLine(label: 'الخسائر التقديرية', value: formatMoney(summary.totalLosses)),
        const OverviewSheetLine(label: 'حالة القبض', value: 'مستقر مع الحاجة لمراجعة التحصيل اليومي'),
        const OverviewSheetMessage(message: 'المتابعة المالية داخل لوحة overview تساعد الإدارة على الربط بين الأداء التشغيلي والضغط المالي مباشرة.'),
      ],
    );
  }

  Future<void> _showMaintenance(BuildContext context, List<TaskModel> tasks, List<ProductionPoint> production) {
    final maintenanceTasks = tasks.where((task) => task.title.contains('صيانة')).length;
    final avgProduction = production.fold<double>(0, (sum, p) => sum + p.actual) / production.length;
    return showOverviewInfoSheet(
      context: context,
      title: 'التحسينات والصيانة',
      subtitle: 'ملف سريع لمهام الصيانة والفرص المتاحة لتحسين التشغيل.',
      children: [
        OverviewSheetLine(label: 'مهام صيانة مرتبطة', value: '$maintenanceTasks'),
        OverviewSheetLine(label: 'متوسط الإنتاج الفعلي', value: avgProduction.round().toString()),
        const OverviewSheetLine(label: 'أولوية التحسين', value: 'تقليل الهدر وربط التنبيهات بالصيانة الوقائية'),
        const OverviewSheetMessage(message: 'التحسين المستمر يجب أن يعتمد على بيانات الأعطال والتنبيهات والضغط على المخزون والعمالة معاً.'),
      ],
    );
  }

  Future<void> _showPayroll(BuildContext context, List<PayrollPoint> payrollPoints, OverviewSummary summary) {
    final highestSalary = payrollPoints.isEmpty ? 0.0 : payrollPoints.map((e) => e.salary).reduce((a, b) => a > b ? a : b);
    return showOverviewInfoSheet(
      context: context,
      title: 'الأجور والخصومات',
      subtitle: 'نظرة سريعة على الأجور الحالية وتأثير الخصومات على التكلفة.',
      children: [
        OverviewSheetLine(label: 'إجمالي الأجور', value: formatMoney(summary.totalPayroll)),
        OverviewSheetLine(label: 'إجمالي الخصومات', value: formatMoney(summary.totalDeductions)),
        OverviewSheetLine(label: 'أعلى أجر تقريبي', value: formatMoney(highestSalary)),
        const OverviewSheetMessage(message: 'مفيد ربط الأجور والخصومات بالحضور والمهام لتكوين تقييم عادل وواضح لكل عامل أو فريق.'),
      ],
    );
  }
}

class _SectionLead extends StatelessWidget {
  const _SectionLead({required this.eyebrow, required this.title, required this.subtitle});

  final String eyebrow;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(eyebrow, style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.w800, fontSize: 12)),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, height: 1.1)),
        const SizedBox(height: 8),
        Text(subtitle, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
      ],
    );
  }
}
