import 'package:flutter/material.dart';
import 'package:m_shop/features/dashboard/application/dashboard_store.dart';
import 'package:m_shop/features/dashboard/presentation/dashboard_vm.dart';

class OverviewMetrics extends StatelessWidget {
  const OverviewMetrics({super.key, required this.vm});

  final DashboardVm vm;

  @override
  Widget build(BuildContext context) {
    final presentCount = vm.attendance.where((item) => item.present).length;
    final totalProduction = vm.production.fold<double>(0, (sum, item) => sum + item.actual).round();
    final openTasks = vm.tasks.where((task) => task.progress < 1).length;
    final totalProfit = vm.financialReports.fold<double>(0, (sum, item) => sum + item.profit).round();
    final lowStock = vm.inventory.where((item) => item.quantity <= item.minimum).length;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        MetricTile(title: 'الموظفون', value: vm.users.length.toDouble(), subtitle: 'حسابات عاملة', color: const Color(0xFF0F766E), progress: 0.82, icon: Icons.group_rounded, onTap: () => vm.setTab(DashboardTab.users)),
        MetricTile(title: 'الحضور', value: presentCount.toDouble(), subtitle: 'حاضر اليوم', color: const Color(0xFF2563EB), progress: 0.74, icon: Icons.fact_check_rounded, onTap: () => vm.setTab(DashboardTab.attendance)),
        MetricTile(title: 'الإنتاج', value: totalProduction.toDouble(), subtitle: 'وحدة هذا الأسبوع', color: const Color(0xFFF59E0B), progress: 0.88, icon: Icons.precision_manufacturing_rounded, onTap: () => vm.setTab(DashboardTab.productivity)),
        MetricTile(title: 'المهام', value: openTasks.toDouble(), subtitle: 'مهام جارية', color: const Color(0xFF7C3AED), progress: 0.63, icon: Icons.assignment_rounded, onTap: () => vm.setTab(DashboardTab.tasks)),
        MetricTile(title: 'الأرباح', value: totalProfit.toDouble(), subtitle: 'صافي التقارير', color: const Color(0xFF059669), progress: 0.79, icon: Icons.payments_rounded, onTap: () => vm.setTab(DashboardTab.finance)),
        MetricTile(title: 'الجرد', value: lowStock.toDouble(), subtitle: 'عناصر تحتاج متابعة', color: const Color(0xFFDC2626), progress: 0.41, icon: Icons.inventory_2_rounded, onTap: () => vm.setTab(DashboardTab.inventory)),
      ],
    );
  }
}

class MetricTile extends StatelessWidget {
  const MetricTile({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.progress,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final double value;
  final String subtitle;
  final Color color;
  final double progress;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, _) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(18),
              child: Ink(
                width: 166,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [theme.cardColor, color.withValues(alpha: isDark ? 0.14 : 0.05)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: color.withValues(alpha: 0.18)),
                  boxShadow: [BoxShadow(color: color.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 8))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                          child: Icon(icon, color: color, size: 17),
                        ),
                        const Spacer(),
                        Text('${(progress * 100).round()}%', style: TextStyle(color: color, fontWeight: FontWeight.w900)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(title, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 5),
                    Text(animatedValue.round().toString(), style: theme.textTheme.titleLarge?.copyWith(fontSize: 23, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 3),
                    Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontSize: 12)),
                    const SizedBox(height: 6),
                    Text('اضغط للانتقال للقسم', style: TextStyle(color: color.withValues(alpha: 0.9), fontSize: 12, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: progress),
                        duration: const Duration(milliseconds: 1000),
                        builder: (context, progressValue, _) => LinearProgressIndicator(
                          value: progressValue,
                          minHeight: 7,
                          color: color,
                          backgroundColor: color.withValues(alpha: 0.12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

