import 'package:flutter/material.dart';
import 'package:m_shop/features/attendance/presentation/widgets/components/attendance_formatters.dart';
import 'package:m_shop/features/attendance/presentation/widgets/components/attendance_models.dart';
class WorkerAttendanceCard extends StatelessWidget {
  const WorkerAttendanceCard({super.key, required this.worker});
  final WorkerAttendanceProfile worker;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: worker.accent.withValues(alpha: 0.16)),
        boxShadow: [
          BoxShadow(
            color: worker.accent.withValues(alpha: theme.brightness == Brightness.dark ? 0.09 : 0.07),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: worker.accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(worker.icon, color: worker.accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      worker.record.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      worker.shiftLabel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: worker.accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  worker.statusLabel,
                  style: TextStyle(color: worker.accent, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              _InfoChip(label: '\u0645\u0648\u0639\u062f \u0627\u0644\u0648\u0631\u062f\u064a\u0629', value: '${worker.scheduleStart} - ${worker.scheduleEnd}', icon: Icons.event_repeat_rounded),
              _InfoChip(label: '\u062d\u0636\u0648\u0631', value: worker.record.checkIn, icon: Icons.login_rounded),
              _InfoChip(label: '\u0627\u0646\u0635\u0631\u0627\u0641', value: worker.record.checkOut, icon: Icons.logout_rounded),
              _InfoChip(label: '\u0627\u0644\u0633\u0627\u0639\u0627\u062a', value: formatAttendanceHours(worker.record.workedHours), icon: Icons.schedule_rounded),
              _InfoChip(label: '\u0623\u062c\u0631 \u0627\u0644\u0633\u0627\u0639\u0629', value: formatAttendanceMoney(worker.hourlyRate), icon: Icons.payments_outlined),
              _InfoChip(label: '\u0627\u0644\u0623\u062c\u0631 \u0627\u0644\u0645\u0633\u062a\u062d\u0642', value: formatAttendanceMoney(worker.duePay), icon: Icons.account_balance_wallet_rounded),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  '\u0646\u0633\u0628\u0629 \u0627\u0644\u0627\u0644\u062a\u0632\u0627\u0645 \u0628\u0627\u0644\u0648\u0631\u062f\u064a\u0629',
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              Text(worker.commitmentLabel, style: TextStyle(color: worker.accent, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: worker.commitmentRate.clamp(0.0, 1.0).toDouble(),
              minHeight: 8,
              color: worker.accent,
              backgroundColor: theme.dividerColor.withValues(alpha: 0.45),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _FinanceLine(
                title: '\u062a\u0623\u062e\u064a\u0631',
                value: formatAttendanceMinutes(worker.lateMinutes),
                accent: worker.lateMinutes == 0 ? const Color(0xFF16A34A) : const Color(0xFFF59E0B),
              ),
              _FinanceLine(
                title: '\u0625\u0636\u0627\u0641\u064a',
                value: formatAttendanceHours(worker.overtimeHours),
                accent: worker.overtimeHours > 0 ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
              ),
              _FinanceLine(
                title: '\u0623\u062c\u0631 \u0627\u0644\u062e\u0637\u0629',
                value: formatAttendanceMoney(worker.plannedPay),
                accent: const Color(0xFF0F766E),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            worker.note,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}
class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? theme.colorScheme.surface.withValues(alpha: 0.72)
            : theme.colorScheme.surface.withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF0F766E)),
          const SizedBox(width: 6),
          Text('$label: ', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800)),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
class _FinanceLine extends StatelessWidget {
  const _FinanceLine({required this.title, required this.value, required this.accent});
  final String title;
  final String value;
  final Color accent;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 146,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: theme.brightness == Brightness.dark ? 0.14 : 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: accent, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}