import 'package:flutter/material.dart';
import 'package:m_shop/features/attendance/presentation/widgets/components/attendance_formatters.dart';
import 'package:m_shop/features/attendance/presentation/widgets/components/attendance_models.dart';

class PayrollSummaryCard extends StatelessWidget {
  const PayrollSummaryCard({super.key, required this.summary});

  final AttendanceSummary summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFF7FAF9), Color(0xFFF1F7F5)],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFE2ECE8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ملخص الأجور والورديات',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          const Text(
            'هنا تشوف فرق الأجر المخطط والمستحق وأثر التأخير والإضافي.',
            style: TextStyle(color: Color(0xFF667B75), height: 1.5),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _PayrollMetric(title: 'الأجر المخطط', value: formatAttendanceMoney(summary.plannedPayroll), accent: const Color(0xFF0F766E)),
              _PayrollMetric(title: 'الأجر المستحق', value: formatAttendanceMoney(summary.totalDuePay), accent: const Color(0xFF2563EB)),
              _PayrollMetric(title: 'فرق الأجر', value: formatAttendanceMoney(summary.totalDuePay - summary.plannedPayroll), accent: const Color(0xFFF59E0B)),
              _PayrollMetric(title: 'ساعات التأخير', value: formatAttendanceMinutes(summary.totalLateMinutes), accent: const Color(0xFFDC2626)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PayrollMetric extends StatelessWidget {
  const _PayrollMetric({required this.title, required this.value, required this.accent});

  final String title;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: accent, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
