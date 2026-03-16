import 'package:flutter/material.dart';
import 'package:m_shop/features/productivity/presentation/widgets/components/productivity_models.dart';

class ProductivityHero extends StatelessWidget {
  const ProductivityHero({
    super.key,
    required this.summary,
    required this.selectedJourney,
    required this.onOpenFlow,
    required this.onOpenMachine,
  });

  final ProductivitySummary summary;
  final ProductJourney selectedJourney;
  final VoidCallback onOpenFlow;
  final VoidCallback onOpenMachine;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B1722), Color(0xFF0F766E), Color(0xFF5EEAD4)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F766E).withValues(alpha: 0.18),
            blurRadius: 32,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Wrap(
        spacing: 24,
        runSpacing: 24,
        alignment: WrapAlignment.spaceBetween,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _HeroBadge(label: 'متابعة دورة المنتج من الخام للخروج'),
                const SizedBox(height: 16),
                Text(
                  'لوحة إنتاج احترافية لحظة بلحظة',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'من هنا تقدر تتابع مراحل إنشاء المنتج، الخامات الداخلة، العامل المسؤول، الماكينات المستخدمة، ونسبة التقدم والجودة لكل دفعة تشغيل.',
                  style: TextStyle(color: Color(0xEBFFFFFF), height: 1.6),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    HeroStat(label: 'الإنجاز الكلي', value: formatPercent(summary.completionRatio)),
                    HeroStat(label: 'متوسط الجودة', value: formatPercent(summary.averageQuality)),
                    HeroStat(label: 'المكن النشطة', value: '${summary.activeMachines}/${summary.totalMachines}'),
                    HeroStat(label: 'الخطوات المكتملة', value: '${summary.completedSteps}/${summary.totalSteps}'),
                  ],
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedJourney.name,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'الخامة: ${selectedJourney.rawMaterial}',
                    style: const TextStyle(color: Color(0xDEFFFFFF), height: 1.5),
                  ),
                  const SizedBox(height: 14),
                  _InfoRow(label: 'المرحلة الحالية', value: selectedJourney.currentStage),
                  _InfoRow(label: 'المكنة الحالية', value: selectedJourney.currentMachine),
                  _InfoRow(label: 'المشرف', value: selectedJourney.supervisor),
                  _InfoRow(label: 'الكود', value: selectedJourney.sku),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: onOpenFlow,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFBBF24),
                      foregroundColor: const Color(0xFF0B1722),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    icon: const Icon(Icons.route_rounded),
                    label: const Text('فتح رحلة المنتج'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: onOpenMachine,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.22)),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    icon: const Icon(Icons.precision_manufacturing_rounded),
                    label: const Text('تفاصيل الماكينات'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeroStat extends StatelessWidget {
  const HeroStat({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
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

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

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
