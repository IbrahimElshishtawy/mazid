import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/application/dashboard_store.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/dashboard/presentation/dashboard_vm.dart';
import 'production_chart.dart';
import 'package:m_shop/features/users/presentation/users_management_screen.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key, required this.vm});

  final DashboardVm vm;

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
            const SectionCard(
              title: 'نظرة عامة على الوحدات',
              subtitle: 'ملخص سريع لكل جزء من النظام',
              child: Column(
                children: [
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
          subtitle: 'بيانات المستخدمين والأدوار الوظيفية داخل النظام مع صفحة مستقلة للإدارة.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => UsersManagementScreen(users: vm.users),
                      ),
                    );
                  },
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: const Text('فتح صفحة إدارة المستخدمين'),
                ),
              ),
              const SizedBox(height: 16),
              ...vm.users.take(3).map((user) => _UserTile(user: user)),
            ],
          ),
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
          child: SizedBox(height: 280, child: ProductionChart(data: vm.production)),
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
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 5),
            decoration: const BoxDecoration(color: Color(0xFF0F766E), shape: BoxShape.circle),
          ),
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
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: task.progress,
              minHeight: 8,
              color: const Color(0xFF0F766E),
              backgroundColor: const Color(0xFFD9E6E2),
            ),
          ),
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
  const _SimpleTile({
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.accent = const Color(0xFF0F766E),
  });

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
