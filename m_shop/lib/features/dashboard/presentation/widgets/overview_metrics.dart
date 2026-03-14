import 'package:flutter/material.dart';
import 'package:m_shop/features/dashboard/presentation/dashboard_vm.dart';

class OverviewMetrics extends StatelessWidget {
  const OverviewMetrics({super.key, required this.vm});

  final DashboardVm vm;

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
        MetricTile(title: '??????????', value: '${vm.users.length}', subtitle: '?????? ?????', color: const Color(0xFF0F766E)),
        MetricTile(title: '??????', value: '$presentCount', subtitle: '???? ?????', color: const Color(0xFF2563EB)),
        MetricTile(title: '???????', value: '$totalProduction', subtitle: '???? ??? ???????', color: const Color(0xFFF59E0B)),
        MetricTile(title: '??????', value: '$openTasks', subtitle: '???? ????', color: const Color(0xFF7C3AED)),
        MetricTile(title: '???????', value: '$lowStock', subtitle: '???? ????? ?????', color: const Color(0xFFDC2626)),
      ],
    );
  }
}

class MetricTile extends StatelessWidget {
  const MetricTile({super.key, required this.title, required this.value, required this.subtitle, required this.color});

  final String title;
  final String value;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2ECE8)),
      ),
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
