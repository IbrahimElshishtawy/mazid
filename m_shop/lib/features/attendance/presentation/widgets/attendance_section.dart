import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/attendance/presentation/widgets/components/attendance_hero.dart';
import 'package:m_shop/features/attendance/presentation/widgets/components/attendance_models.dart';
import 'package:m_shop/features/attendance/presentation/widgets/components/attendance_stat_card.dart';
import 'package:m_shop/features/attendance/presentation/widgets/components/attendance_formatters.dart';
import 'package:m_shop/features/attendance/presentation/widgets/components/payroll_summary_card.dart';
import 'package:m_shop/features/attendance/presentation/widgets/components/worker_attendance_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class AttendanceSection extends StatelessWidget {
  const AttendanceSection({super.key, required this.attendance});

  final List<AttendanceRecord> attendance;

  @override
  Widget build(BuildContext context) {
    final workers = attendance.asMap().entries.map((entry) => WorkerAttendanceProfile.fromRecord(entry.value, entry.key)).toList();
    final summary = AttendanceSummary.fromWorkers(workers);

    return SectionCard(
      title: 'إدارة الحضور والأجور',
      subtitle: 'شاشة احترافية لمتابعة العمال والمواعيد والأجور من مكان واحد.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AttendanceHero(summary: summary),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 880;
              final cardWidth = wide ? (constraints.maxWidth - 30) / 4 : math.max(192.0, (constraints.maxWidth - 10) / 2);

              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  AttendanceStatCard(
                    width: cardWidth,
                    title: 'العمال الحاضرون',
                    value: '${summary.presentCount}',
                    note: 'العمال الملتزمون ببداية اليوم.',
                    accent: const Color(0xFF16A34A),
                    icon: Icons.groups_2_rounded,
                  ),
                  AttendanceStatCard(
                    width: cardWidth,
                    title: 'حالات التأخير',
                    value: '${summary.lateCount}',
                    note: 'عمال حضروا بعد موعد الوردية.',
                    accent: const Color(0xFFF59E0B),
                    icon: Icons.alarm_on_rounded,
                  ),
                  AttendanceStatCard(
                    width: cardWidth,
                    title: 'الغياب',
                    value: '${summary.absentCount}',
                    note: 'غياب يؤثر على التشغيل والأجر.',
                    accent: const Color(0xFFDC2626),
                    icon: Icons.person_off_rounded,
                  ),
                  AttendanceStatCard(
                    width: cardWidth,
                    title: 'متوسط الساعات',
                    value: formatAttendanceHours(summary.averageHours),
                    note: 'متوسط الساعات المنفذة للعمال.',
                    accent: const Color(0xFF2563EB),
                    icon: Icons.schedule_rounded,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          PayrollSummaryCard(summary: summary),
          const SizedBox(height: 20),
          ...workers.map((worker) => WorkerAttendanceCard(worker: worker)),
        ],
      ),
    );
  }
}

