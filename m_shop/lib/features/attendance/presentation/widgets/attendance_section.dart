import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class AttendanceSection extends StatelessWidget {
  const AttendanceSection({super.key, required this.attendance});

  final List<AttendanceRecord> attendance;

  @override
  Widget build(BuildContext context) {
    final presentCount = attendance.where((item) => item.present).length;
    final absentCount = attendance.length - presentCount;
    final avgHours = attendance.isEmpty ? 0.0 : attendance.fold<double>(0, (sum, item) => sum + item.workedHours) / attendance.length;

    return SectionCard(
      title: 'Attendance',
      subtitle: 'Attendance summary, team presence, and daily working hours.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _AttendanceStatCard(title: 'Records', value: attendance.length.toString(), color: const Color(0xFF0F766E)),
              _AttendanceStatCard(title: 'Present', value: presentCount.toString(), color: const Color(0xFF16A34A)),
              _AttendanceStatCard(title: 'Absent', value: absentCount.toString(), color: const Color(0xFFDC2626)),
              _AttendanceStatCard(title: 'Avg Hours', value: avgHours.toStringAsFixed(1), color: const Color(0xFF2563EB)),
            ],
          ),
          const SizedBox(height: 18),
          ...attendance.map((record) => _AttendanceTile(record: record)),
        ],
      ),
    );
  }
}

class _AttendanceStatCard extends StatelessWidget {
  const _AttendanceStatCard({required this.title, required this.value, required this.color});
  final String title;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withValues(alpha: 0.12))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 34, height: 4, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999))),
        const SizedBox(height: 12),
        Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
      ]),
    );
  }
}

class _AttendanceTile extends StatelessWidget {
  const _AttendanceTile({required this.record});
  final AttendanceRecord record;
  @override
  Widget build(BuildContext context) {
    final accent = record.present ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF7FAF9), borderRadius: BorderRadius.circular(18)),
      child: Row(children: [
        CircleAvatar(backgroundColor: accent.withValues(alpha: 0.12), foregroundColor: accent, child: Icon(record.present ? Icons.check_rounded : Icons.close_rounded)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(record.name, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text('In: ${record.checkIn}  •  Out: ${record.checkOut}  •  Hours: ${record.workedHours}', style: const TextStyle(color: Color(0xFF667B75), height: 1.4)),
        ])),
        const SizedBox(width: 12),
        Text(record.present ? 'Present' : 'Absent', style: TextStyle(color: accent, fontWeight: FontWeight.w800)),
      ]),
    );
  }
}
