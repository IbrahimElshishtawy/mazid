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

class AttendanceStatCard extends StatelessWidget {
  const AttendanceStatCard({super.key, required this.title, required this.value, required this.note, required this.color, required this.icon});

  final String title;
  final String value;
  final String note;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withValues(alpha: 0.14)),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.08), blurRadius: 14, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, color: color, size: 18),
              ),
              const Spacer(),
              Container(width: 34, height: 4, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999))),
            ],
          ),
          const SizedBox(height: 14),
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(note, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
        ],
      ),
    );
  }
}

class QuickAction extends StatelessWidget {
  const QuickAction({super.key, required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(onPressed: () {}, icon: Icon(icon), label: Text(label));
  }
}

class SimpleTile extends StatelessWidget {
  const SimpleTile({super.key, required this.title, required this.subtitle, required this.trailing, this.accent = const Color(0xFF0F766E)});

  final String title;
  final String subtitle;
  final String trailing;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.48), borderRadius: BorderRadius.circular(18)),
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

class AttendanceTile extends StatelessWidget {
  const AttendanceTile({super.key, required this.record});

  final AttendanceRecord record;

  @override
  Widget build(BuildContext context) {
    final accent = record.present ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final status = record.present ? '????' : '????';
    final note = record.present
        ? (record.checkIn != '-' && _late(record.checkIn) ? '???? ?? ?????? ??????' : '????? ????? ??????')
        : '????? ?????? ?? ???????';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(record.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: accent.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(999)),
                child: Text(status, style: TextStyle(color: accent, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _InfoChip(icon: Icons.login_rounded, label: '????', value: record.checkIn),
              _InfoChip(icon: Icons.logout_rounded, label: '??????', value: record.checkOut),
              _InfoChip(icon: Icons.schedule_rounded, label: '???????', value: '${record.workedHours}'),
            ],
          ),
          const SizedBox(height: 12),
          Text(note, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              QuickAction(label: '?????', icon: Icons.edit_outlined),
              QuickAction(label: '??????', icon: Icons.visibility_outlined),
              QuickAction(label: '??????', icon: Icons.verified_outlined),
            ],
          ),
        ],
      ),
    );
  }

  bool _late(String checkIn) {
    if (checkIn == '-' || !checkIn.contains(':')) {
      return false;
    }

    final parts = checkIn.split(':');
    final hour = int.tryParse(parts.first) ?? 0;
    final minute = int.tryParse(parts.last) ?? 0;
    return hour > 8 || (hour == 8 && minute > 10);
  }
}

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    final approvalReady = task.progress >= 0.8;
    final delayed = task.progress < 0.4 || task.status.contains('??????');
    final accent = approvalReady ? const Color(0xFF16A34A) : delayed ? const Color(0xFFDC2626) : const Color(0xFF0F766E);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: accent.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(999)),
                child: Text(approvalReady ? '????? ????????' : delayed ? '????? ????' : task.status, style: TextStyle(color: accent, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(task.description, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _InfoChip(icon: Icons.person_outline_rounded, label: '???????', value: task.assignedTo),
              _InfoChip(icon: Icons.calendar_today_outlined, label: '??????', value: task.dueDate),
              _InfoChip(icon: Icons.analytics_outlined, label: '???????', value: '${(task.progress * 100).round()}%'),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: task.progress,
              minHeight: 9,
              color: accent,
              backgroundColor: const Color(0xFFD9E6E2),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            approvalReady ? '???? ??????? ?????? ?????? ???? ????????? ??????.' : delayed ? '???? ??????? ??? ?????? ?? ????? ??????? ??????.' : '?????? ???? ???? ????? ?????? ?????? ??? ????????.',
            style: const TextStyle(color: Color(0xFF667B75), height: 1.5),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              const QuickAction(label: '??????', icon: Icons.visibility_outlined),
              const QuickAction(label: '?????', icon: Icons.edit_outlined),
              QuickAction(label: approvalReady ? '??????' : '????? ??????', icon: approvalReady ? Icons.fact_check_rounded : Icons.sync_alt_rounded),
              const QuickAction(label: '????? ?????', icon: Icons.swap_horiz_rounded),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2ECE8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF0F766E)),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w700)),
          Text(value, style: const TextStyle(color: Color(0xFF667B75))),
        ],
      ),
    );
  }
}

