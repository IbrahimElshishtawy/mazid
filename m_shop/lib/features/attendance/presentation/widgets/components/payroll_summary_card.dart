import 'package:flutter/material.dart';
import 'package:m_shop/features/attendance/presentation/widgets/components/attendance_formatters.dart';
import 'package:m_shop/features/attendance/presentation/widgets/components/attendance_models.dart';

class PayrollSummaryCard extends StatelessWidget {
  const PayrollSummaryCard({super.key, required this.summary});

  final AttendanceSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: isDark
              ? const [Color(0xFF0B1522), Color(0xFF102033)]
              : const [Color(0xFFF7FAF9), Color(0xFFF1F7F5)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ملخص الأجور والورديات',
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'هنا تشوف فرق الأجر المخطط والمستحق وأثر التأخير والإضافي.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _PayrollMetric(
                title: 'الأجر المخطط',
                value: formatAttendanceMoney(summary.plannedPayroll),
                accent: const Color(0xFF0F766E),
              ),
              _PayrollMetric(
                title: 'الأجر المستحق',
                value: formatAttendanceMoney(summary.totalDuePay),
                accent: const Color(0xFF2563EB),
              ),
              _PayrollMetric(
                title: 'فرق الأجر',
                value: formatAttendanceMoney(summary.totalDuePay - summary.plannedPayroll),
                accent: const Color(0xFFF59E0B),
              ),
              _PayrollMetric(
                title: 'ساعات التأخير',
                value: formatAttendanceMinutes(summary.totalLateMinutes),
                accent: const Color(0xFFDC2626),
              ),
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
    final theme = Theme.of(context);

    return Container(
      width: 172,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: accent, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

