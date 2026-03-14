import 'package:flutter/material.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class OverviewLine extends StatelessWidget {
  const OverviewLine({super.key, required this.title, required this.description});

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

class AlertTile extends StatelessWidget {
  const AlertTile({super.key, required this.alert});

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

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return SimpleTile(
      title: user.name,
      subtitle: '${user.role} • ${user.email}',
      trailing: user.status,
    );
  }
}

class AttendanceTile extends StatelessWidget {
  const AttendanceTile({super.key, required this.record});

  final AttendanceRecord record;

  @override
  Widget build(BuildContext context) {
    return SimpleTile(
      title: record.name,
      subtitle: '????: ${record.checkIn} • ????: ${record.checkOut}',
      trailing: '${record.workedHours} ????',
      accent: record.present ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
    );
  }
}

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task});

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
          Text('?????? ???: ${task.assignedTo} • ??????: ${task.status} • ??????: ${task.dueDate}', style: const TextStyle(color: Color(0xFF4E645F), fontSize: 13)),
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

class InventoryTile extends StatelessWidget {
  const InventoryTile({super.key, required this.item});

  final InventoryItem item;

  @override
  Widget build(BuildContext context) {
    final low = item.quantity <= item.minimum;
    return SimpleTile(
      title: item.name,
      subtitle: '???????: ${item.quantity} ${item.unit} • ???? ??????: ${item.minimum} ${item.unit}',
      trailing: low ? '?????' : '???',
      accent: low ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
    );
  }
}

class FinanceTile extends StatelessWidget {
  const FinanceTile({super.key, required this.report});

  final FinancialReport report;

  @override
  Widget build(BuildContext context) {
    return SimpleTile(
      title: '????? ${report.period}',
      subtitle: '???????: ${report.income.toStringAsFixed(0)} • ?????????: ${report.expenses.toStringAsFixed(0)}',
      trailing: '??? ${report.profit.toStringAsFixed(0)}',
      accent: const Color(0xFF0F766E),
    );
  }
}

class SimpleTile extends StatelessWidget {
  const SimpleTile({
    super.key,
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
