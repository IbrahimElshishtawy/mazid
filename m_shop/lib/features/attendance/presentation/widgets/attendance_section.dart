import '../../../../core/widgets/section_components.dart';
import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class AttendanceSection extends StatelessWidget {
  const AttendanceSection({super.key, required this.attendance});

  final List<AttendanceRecord> attendance;

  @override
  Widget build(BuildContext context) {
    final presentCount = attendance.where((record) => record.present).length;
    final absentCount = attendance.length - presentCount;
    final lateCount = attendance
        .where((record) => record.present && _isLate(record.checkIn))
        .length;
    final totalHours = attendance.fold<double>(
      0,
      (sum, record) => sum + record.workedHours,
    );
    final averageHours = attendance.isEmpty
        ? 0.0
        : totalHours / attendance.length;

    return SectionCard(
      title: '?????? ?????????',
      subtitle:
          '???? ???? ??????? ??????? ????? ???????? ??????? ??????? ???????.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AttendanceStatCard(
                title: '?????? ????',
                value: '$presentCount',
                note: '????? ????? ?????',
                color: const Color(0xFF16A34A),
                icon: Icons.how_to_reg_rounded,
              ),
              AttendanceStatCard(
                title: '???? ?????',
                value: '$absentCount',
                note: '????? ?????? ?????',
                color: const Color(0xFFDC2626),
                icon: Icons.person_off_rounded,
              ),
              AttendanceStatCard(
                title: '???????',
                value: '$lateCount',
                note: '??? 08:10 ??????',
                color: const Color(0xFFF59E0B),
                icon: Icons.timer_outlined,
              ),
              AttendanceStatCard(
                title: '????? ???????',
                value: averageHours.toStringAsFixed(1),
                note: '???? ???? ??? ???',
                color: const Color(0xFF2563EB),
                icon: Icons.schedule_rounded,
              ),
            ],
          ),
          const SizedBox(height: 18),
          _AttendanceChartCard(
            presentCount: presentCount,
            absentCount: absentCount,
            lateCount: lateCount,
            averageHours: averageHours,
            totalCount: attendance.length,
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAF9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '???? ???? ??????',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                const Text(
                  '?????? ??? ???????? ?????? ???? ????? ????? ?????? ?????????? ??????? ?????? ?????? ?? ???? ????.',
                  style: TextStyle(color: Color(0xFF667B75), height: 1.6),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: const [
                    QuickAction(
                      label: '????? ????',
                      icon: Icons.person_add_alt_1_rounded,
                    ),
                    QuickAction(
                      label: '????? ???',
                      icon: Icons.edit_calendar_rounded,
                    ),
                    QuickAction(
                      label: '?????? ??????',
                      icon: Icons.verified_outlined,
                    ),
                    QuickAction(
                      label: '?????? ?????????',
                      icon: Icons.notifications_active_outlined,
                    ),
                    QuickAction(
                      label: '????? ???',
                      icon: Icons.file_download_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: const [
                    _AttendanceManagerPanel(
                      title: '????? ?? ?????',
                      description:
                          '????? ??? ???? ?? ??????? ????? ????? ?????? ?? ????? ??? ????.',
                    ),
                    _AttendanceManagerPanel(
                      title: '?????? ?????',
                      description:
                          '??? ?????? ????????? ?????? ??????? ???? ??????? ????? ???????.',
                    ),
                    _AttendanceManagerPanel(
                      title: '??????? ??????',
                      description:
                          '?????? ??????? ????? ???????? ?????? ??? ???? ??????? ?? ??????? ???????.',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const SectionCard(
            title: '?????? ??????? ??? ??????',
            subtitle: '??? ?????? ???? ?????? ?????? ??????? ???? ??? ?????.',
            child: Column(
              children: [
                OverviewLine(
                  title: '????? ??? ???? ????',
                  description:
                      '????? ???? ?? ?????? ??????? ???? ?? ??????? ??? ????.',
                ),
                OverviewLine(
                  title: '????? ????? ?????',
                  description:
                      '????? ??? ??????? ??? ????????? ?? ??? ??????? ??????? ??? ????.',
                ),
                OverviewLine(
                  title: '?????? ?????? ????????',
                  description:
                      '????? ??????? ?????? ?????? ?????? ????? ?????? ????????? ?? ????????.',
                ),
                OverviewLine(
                  title: '?????? ??????? ???????',
                  description:
                      '????? ??? ?????? ?????? ????? ??????? ?? ??? ??????? ???????.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionCard(
            title: '????? ?????? ?????',
            subtitle: '??? ?????? ?????? ?? ??? ?????? ????????? ?????? ?????.',
            child: Column(
              children: attendance
                  .map((record) => AttendanceTile(record: record))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  bool _isLate(String checkIn) {
    if (checkIn == '-' || !checkIn.contains(':')) {
      return false;
    }

    final parts = checkIn.split(':');
    final hour = int.tryParse(parts.first) ?? 0;
    final minute = int.tryParse(parts.last) ?? 0;
    return hour > 8 || (hour == 8 && minute > 10);
  }
}

class _AttendanceManagerPanel extends StatelessWidget {
  const _AttendanceManagerPanel({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2ECE8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '???? ??????',
            style: TextStyle(
              color: Color(0xFF0F766E),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(color: Color(0xFF667B75), height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _AttendanceChartCard extends StatelessWidget {
  const _AttendanceChartCard({
    required this.presentCount,
    required this.absentCount,
    required this.lateCount,
    required this.averageHours,
    required this.totalCount,
  });

  final int presentCount;
  final int absentCount;
  final int lateCount;
  final double averageHours;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final safeTotal = totalCount == 0 ? 1 : totalCount;
    final presentRatio = presentCount / safeTotal;
    final absentRatio = absentCount / safeTotal;
    final lateRatio = lateCount / safeTotal;
    final hoursRatio = (averageHours / 8).clamp(0.0, 1.0).toDouble();

    return SectionCard(
      title: '?????? ?????? ??????',
      subtitle: '????? ????? ???? ?????? ??????? ???????? ?????? ????? ?????.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _AttendanceGraphBar(
                  label: '????',
                  value: '$presentCount',
                  progress: presentRatio,
                  color: const Color(0xFF16A34A),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _AttendanceGraphBar(
                  label: '????',
                  value: '$absentCount',
                  progress: absentRatio,
                  color: const Color(0xFFDC2626),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _AttendanceGraphBar(
                  label: '?????',
                  value: '$lateCount',
                  progress: lateRatio,
                  color: const Color(0xFFF59E0B),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _AttendanceGraphBar(
                  label: '???????',
                  value: averageHours.toStringAsFixed(1),
                  progress: hoursRatio,
                  color: const Color(0xFF2563EB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: presentRatio,
              minHeight: 10,
              color: const Color(0xFF16A34A),
              backgroundColor: const Color(0xFFE5EEEB),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '???? ???????? ??????? ${(presentRatio * 100).round()}% ?? ???? ??????? ${lateCount > 0 ? '???????' : '????????? ??????'} ???? ???????.',
            style: const TextStyle(color: Color(0xFF667B75), height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _AttendanceGraphBar extends StatelessWidget {
  const _AttendanceGraphBar({
    required this.label,
    required this.value,
    required this.progress,
    required this.color,
  });

  final String label;
  final String value;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 190,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAF9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.12)),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: progress.clamp(0.06, 1.0).toDouble(),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [color, color.withValues(alpha: 0.42)],
                  ),
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}


