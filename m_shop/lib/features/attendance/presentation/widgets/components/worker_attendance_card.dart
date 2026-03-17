import 'package:flutter/material.dart';
import 'package:m_shop/features/attendance/presentation/widgets/components/attendance_formatters.dart';
import 'package:m_shop/features/attendance/presentation/widgets/components/attendance_models.dart';

class WorkerAttendanceCard extends StatelessWidget {
  const WorkerAttendanceCard({super.key, required this.worker});

  final WorkerAttendanceProfile worker;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: worker.accent.withValues(alpha: 0.14)),
        boxShadow: [
          BoxShadow(color: worker.accent.withValues(alpha: 0.07), blurRadius: 14, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(color: worker.accent.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(18)),
                child: Icon(worker.icon, color: worker.accent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(worker.record.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(worker.shiftLabel, style: const TextStyle(color: Color(0xFF667B75), height: 1.4)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(color: worker.accent.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(999)),
                child: Text(worker.statusLabel, style: TextStyle(color: worker.accent, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _InfoChip(label: 'موعد الوردية', value: '${worker.scheduleStart} - ${worker.scheduleEnd}', icon: Icons.event_repeat_rounded),
              _InfoChip(label: 'حضور', value: worker.record.checkIn, icon: Icons.login_rounded),
              _InfoChip(label: 'انصراف', value: worker.record.checkOut, icon: Icons.logout_rounded),
              _InfoChip(label: 'الساعات', value: formatAttendanceHours(worker.record.workedHours), icon: Icons.schedule_rounded),
              _InfoChip(label: 'أجر الساعة', value: formatAttendanceMoney(worker.hourlyRate), icon: Icons.payments_outlined),
              _InfoChip(label: 'الأجر المستحق', value: formatAttendanceMoney(worker.duePay), icon: Icons.account_balance_wallet_rounded),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: Text('نسبة الالتزام بالوردية', style: const TextStyle(fontWeight: FontWeight.w800))),
              Text(worker.commitmentLabel, style: TextStyle(color: worker.accent, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: worker.commitmentRate.clamp(0.0, 1.0).toDouble(),
              minHeight: 10,
              color: worker.accent,
              backgroundColor: const Color(0xFFDCE8E4),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _FinanceLine(title: 'تأخير', value: formatAttendanceMinutes(worker.lateMinutes), accent: worker.lateMinutes == 0 ? const Color(0xFF16A34A) : const Color(0xFFF59E0B)),
              _FinanceLine(title: 'إضافي', value: formatAttendanceHours(worker.overtimeHours), accent: worker.overtimeHours > 0 ? const Color(0xFF2563EB) : const Color(0xFF94A3B8)),
              _FinanceLine(title: 'أجر الخطة', value: formatAttendanceMoney(worker.plannedPay), accent: const Color(0xFF0F766E)),
            ],
          ),
          const SizedBox(height: 14),
          Text(worker.note, style: const TextStyle(color: Color(0xFF667B75), height: 1.6)),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2ECE8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF0F766E)),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w800)),
          Text(value, style: const TextStyle(color: Color(0xFF667B75), fontWeight: FontWeight.w700)),
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
    return Container(
      width: 170,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: accent, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        ],
      ),
    );
  }
}
