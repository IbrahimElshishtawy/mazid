import 'package:flutter/material.dart';
import 'package:m_shop/features/dashboard/application/dashboard_store.dart';
import 'package:m_shop/features/dashboard/presentation/dashboard_vm.dart';

class DashboardHero extends StatelessWidget {
  const DashboardHero({super.key, required this.vm});

  final DashboardVm vm;

  @override
  Widget build(BuildContext context) {
    final shiftLabels = {
      ShiftType.morning: 'صباحية',
      ShiftType.evening: 'مسائية',
      ShiftType.night: 'ليلية',
    };
    final targetProduction = vm.production.fold<double>(0, (sum, item) => sum + item.target);
    final actualProduction = vm.production.fold<double>(0, (sum, item) => sum + item.actual);
    final completion = targetProduction == 0 ? 0.0 : (actualProduction / targetProduction).clamp(0.0, 1.0).toDouble();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF0F766E), Color(0xFF1D4ED8), Color(0xFF0F172A)],
          stops: [0.0, 0.58, 1.0],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x330F766E),
            blurRadius: 30,
            offset: Offset(0, 22),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            left: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -45,
            right: -10,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.factory_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مركز تشغيل المصنع',
                          style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'لوحة جذابة لقراءة الأداء والنتائج والأرباح والجرد لحظة بلحظة.',
                          style: TextStyle(color: Color(0xD7FFFFFF), height: 1.6),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'الوردية ${shiftLabels[vm.shift]}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _HeroBadge(title: 'حالة التشغيل', value: 'مستقرة', icon: Icons.bolt_rounded),
                  _HeroBadge(title: 'التنبيهات', value: '${vm.alerts.length}', icon: Icons.notifications_active_rounded),
                  _HeroBadge(title: 'المهام المفتوحة', value: '${vm.tasks.where((task) => task.progress < 1).length}', icon: Icons.assignment_turned_in_rounded),
                ],
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text('معدل تحقيق الإنتاج المستهدف', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                        ),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: completion),
                          duration: const Duration(milliseconds: 1200),
                          builder: (context, value, _) => Text(
                            '${(value * 100).round()}%',
                            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: completion),
                        duration: const Duration(milliseconds: 1200),
                        builder: (context, value, _) => LinearProgressIndicator(
                          value: value,
                          minHeight: 14,
                          backgroundColor: const Color(0x40FFFFFF),
                          color: const Color(0xFF93F5D0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'الفعلي ${actualProduction.round()} وحدة من أصل ${targetProduction.round()} وحدة مستهدفة',
                      style: const TextStyle(color: Color(0xE6FFFFFF), height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: ShiftType.values.map((shift) {
                  final selected = shift == vm.shift;
                  final label = shiftLabels[shift]!;
                  return InkWell(
                    onTap: () => vm.setShift(shift),
                    borderRadius: BorderRadius.circular(999),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: selected ? Colors.white : Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          color: selected ? const Color(0xFF0F766E) : Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.title, required this.value, required this.icon});

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Color(0xD7FFFFFF), fontSize: 12)),
              Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15)),
            ],
          ),
        ],
      ),
    );
  }
}

