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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
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
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: worker.accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16),
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
                        fontSize: 17,
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
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
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(label: 'موعد الوردية', value: '${worker.scheduleStart} - ${worker.scheduleEnd}', icon: Icons.event_repeat_rounded),
              _InfoChip(label: 'حضور', value: worker.record.checkIn, icon: Icons.login_rounded),
              _InfoChip(label: 'انصراف', value: worker.record.checkOut, icon: Icons.logout_rounded),
              _InfoChip(label: 'الساعات', value: formatAttendanceHours(worker.record.workedHours), icon: Icons.schedule_rounded),
              _InfoChip(label: 'أجر الساعة', value: formatAttendanceMoney(worker.hourlyRate), icon: Icons.payments_outlined),
              _InfoChip(label: 'الأجر المستحق', value: formatAttendanceMoney(worker.duePay), icon: Icons.account_balance_wallet_rounded),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'نسبة الالتزام بالوردية',
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
                title: 'تأخير',
                value: formatAttendanceMinutes(worker.lateMinutes),
                accent: worker.lateMinutes == 0 ? const Color(0xFF16A34A) : const Color(0xFFF59E0B),
              ),
              _FinanceLine(
                title: 'إضافي',
                value: formatAttendanceHours(worker.overtimeHours),
                accent: worker.overtimeHours > 0 ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
              ),
              _FinanceLine(
                title: 'أجر الخطة',
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
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? theme.colorScheme.surface.withValues(alpha: 0.72)
            : const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: const Color(0xFF0F766E)),
          const SizedBox(width: 7),
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
      width: 156,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: theme.brightness == Brightness.dark ? 0.14 : 0.08),
        borderRadius: BorderRadius.circular(16),
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
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}
