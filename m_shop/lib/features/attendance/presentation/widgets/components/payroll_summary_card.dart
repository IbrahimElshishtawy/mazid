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
              : [theme.cardColor, const Color(0xFF0F766E).withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\u0645\u0644\u062e\u0635 \u0627\u0644\u0623\u062c\u0648\u0631 \u0648\u0627\u0644\u0648\u0631\u062f\u064a\u0627\u062a',
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '\u0647\u0646\u0627 \u062a\u0634\u0648\u0641 \u0641\u0631\u0642 \u0627\u0644\u0623\u062c\u0631 \u0627\u0644\u0645\u062e\u0637\u0637 \u0648\u0627\u0644\u0645\u0633\u062a\u062d\u0642 \u0648\u0623\u062b\u0631 \u0627\u0644\u062a\u0623\u062e\u064a\u0631 \u0648\u0627\u0644\u0625\u0636\u0627\u0641\u064a.',
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
                title: '\u0627\u0644\u0623\u062c\u0631 \u0627\u0644\u0645\u062e\u0637\u0637',
                value: formatAttendanceMoney(summary.plannedPayroll),
                accent: const Color(0xFF0F766E),
              ),
              _PayrollMetric(
                title: '\u0627\u0644\u0623\u062c\u0631 \u0627\u0644\u0645\u0633\u062a\u062d\u0642',
                value: formatAttendanceMoney(summary.totalDuePay),
                accent: const Color(0xFF2563EB),
              ),
              _PayrollMetric(
                title: '\u0641\u0631\u0642 \u0627\u0644\u0623\u062c\u0631',
                value: formatAttendanceMoney(summary.totalDuePay - summary.plannedPayroll),
                accent: const Color(0xFFF59E0B),
              ),
              _PayrollMetric(
                title: '\u0633\u0627\u0639\u0627\u062a \u0627\u0644\u062a\u0623\u062e\u064a\u0631',
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