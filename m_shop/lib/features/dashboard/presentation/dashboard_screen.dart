import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/application/dashboard_store.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:redux/redux.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<DashboardState, _DashboardVm>(
      converter: _DashboardVm.fromStore,
      builder: (context, vm) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFE7F4F1), Color(0xFFF7FAF9)],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _DashboardHero(vm: vm),
                      const SizedBox(height: 18),
                      _DashboardTabs(vm: vm),
                      const SizedBox(height: 18),
                      _OverviewMetrics(vm: vm),
                      const SizedBox(height: 18),
                      _DashboardContent(vm: vm),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DashboardVm {
  const _DashboardVm({
    required this.tab,
    required this.shift,
    required this.users,
    required this.attendance,
    required this.production,
    required this.tasks,
    required this.inventory,
    required this.financialReports,
    required this.alerts,
    required this.setTab,
    required this.setShift,
  });

  final DashboardTab tab;
  final ShiftType shift;
  final List<UserModel> users;
  final List<AttendanceRecord> attendance;
  final List<ProductionPoint> production;
  final List<TaskModel> tasks;
  final List<InventoryItem> inventory;
  final List<FinancialReport> financialReports;
  final List<AlertModel> alerts;
  final ValueChanged<DashboardTab> setTab;
  final ValueChanged<ShiftType> setShift;

  static _DashboardVm fromStore(Store<DashboardState> store) {
    final state = store.state;
    return _DashboardVm(
      tab: state.tab,
      shift: state.shift,
      users: state.users,
      attendance: state.attendance,
      production: state.production,
      tasks: state.tasks,
      inventory: state.inventory,
      financialReports: state.financialReports,
      alerts: state.alerts,
      setTab: (tab) => store.dispatch(SetDashboardTabAction(tab)),
      setShift: (shift) => store.dispatch(SetShiftAction(shift)),
    );
  }
}

class _DashboardHero extends StatelessWidget {
  const _DashboardHero({required this.vm});

  final _DashboardVm vm;

  @override
  Widget build(BuildContext context) {
    final shiftLabels = {
      ShiftType.morning: 'صباحية',
      ShiftType.evening: 'مسائية',
      ShiftType.night: 'ليلية',
    };

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF0F766E), Color(0xFF1D4ED8)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x220F766E),
            blurRadius: 28,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.factory_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('نظام إدارة المصنع', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
                    SizedBox(height: 4),
                    Text('كل الوحدات الأساسية أمامك الآن ببيانات موجودة داخل التطبيق.', style: TextStyle(color: Color(0xD7FFFFFF), height: 1.5)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text('الوردية ${shiftLabels[vm.shift]}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ShiftType.values.map((shift) {
              final selected = shift == vm.shift;
              final label = shiftLabels[shift]!;
              return InkWell(
                onTap: () => vm.setShift(shift),
                borderRadius: BorderRadius.circular(999),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? Colors.white : Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(label, style: TextStyle(color: selected ? const Color(0xFF0F766E) : Colors.white, fontWeight: FontWeight.w800)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _DashboardTabs extends StatelessWidget {
  const _DashboardTabs({required this.vm});

  final _DashboardVm vm;

  @override
  Widget build(BuildContext context) {
    final tabs = {
      DashboardTab.overview: 'الرئيسية',
      DashboardTab.users: 'المستخدمين',
      DashboardTab.attendance: 'الحضور',
      DashboardTab.productivity: 'الإنتاج',
      DashboardTab.tasks: 'المهام',
      DashboardTab.inventory: 'المخزون',
      DashboardTab.finance: 'المالية',
    };

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: tabs.entries.map((entry) {
        final selected = entry.key == vm.tab;
        return InkWell(
          onTap: () => vm.setTab(entry.key),
          borderRadius: BorderRadius.circular(999),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFF0F766E) : Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: selected ? const Color(0xFF0F766E) : const Color(0xFFE2ECE8)),
            ),
            child: Text(entry.value, style: TextStyle(color: selected ? Colors.white : const Color(0xFF4F6660), fontWeight: FontWeight.w800)),
          ),
        );
      }).toList(),
    );
  }
}

class _OverviewMetrics extends StatelessWidget {
  const _OverviewMetrics({required this.vm});

  final _DashboardVm vm;

  @override
  Widget build(BuildContext context) {
    final presentCount = vm.attendance.where((item) => item.present).length;
    final totalProduction = vm.production.fold<double>(0, (sum, item) => sum + item.actual).round();
    final openTasks = vm.tasks.where((task) => task.progress < 1).length;
    final lowStock = vm.inventory.where((item) => item.quantity <= item.minimum).length;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _MetricTile(title: 'المستخدمين', value: '${vm.users.length}', subtitle: 'حسابات مفعلة', color: const Color(0xFF0F766E)),
        _MetricTile(title: 'الحضور', value: '$presentCount', subtitle: 'حاضر اليوم', color: const Color(0xFF2563EB)),
        _MetricTile(title: 'الإنتاج', value: '$totalProduction', subtitle: 'وحدة هذا الأسبوع', color: const Color(0xFFF59E0B)),
        _MetricTile(title: 'المهام', value: '$openTasks', subtitle: 'نشطة الآن', color: const Color(0xFF7C3AED)),
        _MetricTile(title: 'المخزون', value: '$lowStock', subtitle: 'مواد تحتاج تنبيه', color: const Color(0xFFDC2626)),
      ],
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.vm});

  final _DashboardVm vm;

  @override
  Widget build(BuildContext context) {
    switch (vm.tab) {
      case DashboardTab.overview:
        return Column(
          children: [
            SectionCard(
              title: 'تنبيهات النظام',
              subtitle: 'قراءة فورية لأهم ما يحتاج انتباهك الآن',
              child: Column(children: vm.alerts.map((alert) => _AlertTile(alert: alert)).toList()),
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: 'نظرة عامة على الوحدات',
              subtitle: 'ملخص سريع لكل جزء من النظام',
              child: Column(
                children: const [
                  _OverviewLine(title: 'إدارة المستخدمين', description: 'صلاحيات المدير والمشرف والعامل جاهزة للعرض والتطوير لاحقًا.'),
                  _OverviewLine(title: 'إدارة الحضور', description: 'سجلات حضور وانصراف وساعات عمل يومية.'),
                  _OverviewLine(title: 'إدارة الإنتاجية', description: 'مخطط الإنتاج ومقارنة الفعلي بالمستهدف.'),
                  _OverviewLine(title: 'إدارة المهام', description: 'مهام مخصصة وحالات تنفيذ ومواعيد نهائية.'),
                  _OverviewLine(title: 'إدارة المخزون', description: 'كميات المواد الخام والتنبيه قبل النفاد.'),
                  _OverviewLine(title: 'التقارير المالية', description: 'دخل ومصروفات وربحية يومية وأسبوعية وشهرية.'),
                ],
              ),
            ),
          ],
        );
      case DashboardTab.users:
        return SectionCard(
          title: 'إدارة المستخدمين',
          subtitle: 'بيانات المستخدمين والأدوار الوظيفية داخل النظام',
          child: Column(children: vm.users.map((user) => _UserTile(user: user)).toList()),
        );
      case DashboardTab.attendance:
        return SectionCard(
          title: 'إدارة الحضور',
          subtitle: 'الحضور والانصراف وساعات العمل اليومية',
          child: Column(children: vm.attendance.map((record) => _AttendanceTile(record: record)).toList()),
        );
      case DashboardTab.productivity:
        return SectionCard(
          title: 'إدارة الإنتاجية',
          subtitle: 'عرض الإنتاج اليومي وتحليل الأداء مقابل المستهدف',
          child: SizedBox(height: 280, child: _ProductionChart(data: vm.production)),
        );
      case DashboardTab.tasks:
        return SectionCard(
          title: 'إدارة المهام',
          subtitle: 'المهام المخصصة للعاملين مع الحالة ونسبة الإنجاز',
          child: Column(children: vm.tasks.map((task) => _TaskTile(task: task)).toList()),
        );
      case DashboardTab.inventory:
        return SectionCard(
          title: 'إدارة المخزون',
          subtitle: 'المواد الخام والكميات الحالية والتنبيه عند الانخفاض',
          child: Column(children: vm.inventory.map((item) => _InventoryTile(item: item)).toList()),
        );
      case DashboardTab.finance:
        return SectionCard(
          title: 'التقارير المالية',
          subtitle: 'تقارير يومية وأسبوعية وشهرية للإيرادات والمصروفات والربحية',
          child: Column(children: vm.financialReports.map((report) => _FinanceTile(report: report)).toList()),
        );
    }
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.title, required this.value, required this.subtitle, required this.color});

  final String title;
  final String value;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE2ECE8))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(height: 14),
          Text(title, style: const TextStyle(color: Color(0xFF5E746E), fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Color(0xFF6C817B), fontSize: 13)),
        ],
      ),
    );
  }
}

class _OverviewLine extends StatelessWidget {
  const _OverviewLine({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 10, height: 10, margin: const EdgeInsets.only(top: 5), decoration: const BoxDecoration(color: Color(0xFF0F766E), shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  const _AlertTile({required this.alert});

  final AlertModel alert;

  @override
  Widget build(BuildContext context) {
    final color = Color(alert.colorHex);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(18), border: Border.all(color: color.withValues(alpha: 0.18))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(alert.title, style: TextStyle(color: color, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(alert.description, style: const TextStyle(color: Color(0xFF30413D), height: 1.5)),
        ],
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return _SimpleTile(
      title: user.name,
      subtitle: '${user.role} • ${user.email}',
      trailing: user.status,
    );
  }
}

class _AttendanceTile extends StatelessWidget {
  const _AttendanceTile({required this.record});

  final AttendanceRecord record;

  @override
  Widget build(BuildContext context) {
    return _SimpleTile(
      title: record.name,
      subtitle: 'دخول: ${record.checkIn} • خروج: ${record.checkOut}',
      trailing: '${record.workedHours} ساعة',
      accent: record.present ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFF7FAF9), borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w800))),
              Text('${(task.progress * 100).round()}%', style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 6),
          Text(task.description, style: const TextStyle(color: Color(0xFF667B75), height: 1.4)),
          const SizedBox(height: 8),
          Text('مُسندة إلى: ${task.assignedTo} • الحالة: ${task.status} • الموعد: ${task.dueDate}', style: const TextStyle(color: Color(0xFF4E645F), fontSize: 13)),
          const SizedBox(height: 10),
          ClipRRect(borderRadius: BorderRadius.circular(999), child: LinearProgressIndicator(value: task.progress, minHeight: 8, color: const Color(0xFF0F766E), backgroundColor: const Color(0xFFD9E6E2))),
        ],
      ),
    );
  }
}

class _InventoryTile extends StatelessWidget {
  const _InventoryTile({required this.item});

  final InventoryItem item;

  @override
  Widget build(BuildContext context) {
    final low = item.quantity <= item.minimum;
    return _SimpleTile(
      title: item.name,
      subtitle: 'المتوفر: ${item.quantity} ${item.unit} • الحد الأدنى: ${item.minimum} ${item.unit}',
      trailing: low ? 'تنبيه' : 'آمن',
      accent: low ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
    );
  }
}

class _FinanceTile extends StatelessWidget {
  const _FinanceTile({required this.report});

  final FinancialReport report;

  @override
  Widget build(BuildContext context) {
    return _SimpleTile(
      title: 'تقرير ${report.period}',
      subtitle: 'الإيراد: ${report.income.toStringAsFixed(0)} • المصروفات: ${report.expenses.toStringAsFixed(0)}',
      trailing: 'ربح ${report.profit.toStringAsFixed(0)}',
      accent: const Color(0xFF0F766E),
    );
  }
}

class _SimpleTile extends StatelessWidget {
  const _SimpleTile({required this.title, required this.subtitle, required this.trailing, this.accent = const Color(0xFF0F766E)});

  final String title;
  final String subtitle;
  final String trailing;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFF7FAF9), borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: accent, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Color(0xFF667B75), height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(trailing, style: TextStyle(color: accent, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _ProductionChart extends StatelessWidget {
  const _ProductionChart({required this.data});

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

    final grid = Paint()..color = const Color(0xFFE2ECE8)..strokeWidth = 1;
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
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(barX, barY, barWidth, height - barY), const Radius.circular(4)), barPaint);

      final targetX = left + slot * i + slot / 2;
      final targetY = scaleY(data[i].target);
      if (i == 0) {
        path.moveTo(targetX, targetY);
      } else {
        path.lineTo(targetX, targetY);
      }

      final textPainter = TextPainter(
        text: TextSpan(text: data[i].label, style: const TextStyle(color: Color(0xFF677C76), fontSize: 11)),
        textDirection: TextDirection.rtl,
      )..layout();
      textPainter.paint(canvas, Offset(targetX - textPainter.width / 2, size.height - 18));
    }

    canvas.drawPath(path, Paint()..color = const Color(0xFF94A3B8)..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
