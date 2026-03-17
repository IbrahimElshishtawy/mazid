import 'package:flutter/material.dart';
import 'package:m_shop/features/attendance/presentation/widgets/components/attendance_formatters.dart';
import 'package:m_shop/features/attendance/presentation/widgets/components/attendance_models.dart';

class AttendanceHero extends StatelessWidget {
  const AttendanceHero({super.key, required this.summary});

  final AttendanceSummary summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF0B1320), Color(0xFF123A67), Color(0xFF0F766E)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF123A67).withValues(alpha: 0.16),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        alignment: WrapAlignment.spaceBetween,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: const [
                    _HeroBadge(label: 'متابعة العمال'),
                    _HeroBadge(label: 'ربط الأجر بالموعد'),
                    _HeroBadge(label: 'قرار يومي سريع'),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'لوحة حضور وأجور احترافية',
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, height: 1.15),
                ),
                const SizedBox(height: 12),
                const Text(
                  'من هنا تراقب الحضور الفعلي مقابل موعد الوردية وتشوف الأجر المستحق لكل عامل بشكل مباشر.',
                  style: TextStyle(color: Color(0xE7FFFFFF), height: 1.7),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _HeroValue(label: 'الأجر المستحق', value: formatAttendanceMoney(summary.totalDuePay)),
                    _HeroValue(label: 'أجر الخطة', value: formatAttendanceMoney(summary.plannedPayroll)),
                    _HeroValue(label: 'ساعات إضافية', value: formatAttendanceHours(summary.overtimeHours)),
                  ],
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'قراءة المشرف',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  _HeroLine(label: 'نسبة الالتزام', value: summary.commitmentLabel),
                  _HeroLine(label: 'عمال منضبطون', value: '${summary.onTimeCount}'),
                  _HeroLine(label: 'أعلى استحقاق', value: formatAttendanceMoney(summary.highestDuePay)),
                  _HeroLine(label: 'ملاحظة اليوم', value: summary.ownerNote),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
    );
  }
}

class _HeroValue extends StatelessWidget {
  const _HeroValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xD8FFFFFF), fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
        ],
      ),
    );
  }
}

class _HeroLine extends StatelessWidget {
  const _HeroLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Color(0xD8FFFFFF), fontWeight: FontWeight.w700))),
          Flexible(child: Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900), textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}
