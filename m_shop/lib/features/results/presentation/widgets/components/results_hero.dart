import 'package:flutter/material.dart';
import 'package:m_shop/features/results/presentation/widgets/components/results_models.dart';

class ResultsHero extends StatelessWidget {
  const ResultsHero({
    super.key,
    required this.summary,
    required this.onOpenStrategy,
    required this.onOpenFactoryMap,
  });

  final ResultsSummary summary;
  final VoidCallback onOpenStrategy;
  final VoidCallback onOpenFactoryMap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B1320), Color(0xFF123A67), Color(0xFF0F766E)],
        ),
        boxShadow: [BoxShadow(color: const Color(0xFF123A67).withValues(alpha: 0.18), blurRadius: 34, offset: const Offset(0, 20))],
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
                const _HeroTag(label: 'لوحة نتائج استراتيجية للمصنع'),
                const SizedBox(height: 16),
                Text('حالة النتائج الآن: ${summary.strategicState}', style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900, height: 1.1)),
                const SizedBox(height: 12),
                const Text('الشاشة دي بتجمع التنفيذ والإنتاج والربحية والمخاطر والمخزون في مكان واحد، عشان الإدارة تاخد قرارات واضحة ومبنية على بيانات حقيقية.', style: TextStyle(color: Color(0xEAFFFFFF), height: 1.6)),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _StatChip(label: 'التنفيذ', value: formatPercent(summary.executionRate)),
                    _StatChip(label: 'الربحية الصافية', value: formatCurrency(summary.netResult)),
                    _StatChip(label: 'المخاطر', value: formatPercent(summary.riskRate)),
                    _StatChip(label: 'الحضور', value: formatPercent(summary.attendanceRate)),
                  ],
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
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
                  const Text('ملخص القرار التنفيذي', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 14),
                  _SideLine(label: 'الإنتاج مقابل المستهدف', value: '${summary.totalActual.round()} / ${summary.totalTarget.round()}'),
                  _SideLine(label: 'المهام المكتملة', value: '${summary.completedTasks}'),
                  _SideLine(label: 'التنبيهات المفتوحة', value: '${summary.alertCount}'),
                  _SideLine(label: 'صافي النتيجة', value: formatCurrency(summary.netResult)),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: onOpenStrategy,
                    style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFBBF24), foregroundColor: const Color(0xFF0B1320), minimumSize: const Size.fromHeight(50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                    icon: const Icon(Icons.auto_graph_rounded),
                    label: const Text('فتح الخطة الاستراتيجية'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: onOpenFactoryMap,
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: BorderSide(color: Colors.white.withValues(alpha: 0.22)), minimumSize: const Size.fromHeight(50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                    icon: const Icon(Icons.map_outlined),
                    label: const Text('خريطة النتائج داخل المصنع'),
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

class _HeroTag extends StatelessWidget {
  const _HeroTag({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(999), border: Border.all(color: Colors.white.withValues(alpha: 0.14))),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withValues(alpha: 0.12))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Color(0xD8FFFFFF), fontWeight: FontWeight.w700)), const SizedBox(height: 8), Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900))]),
    );
  }
}

class _SideLine extends StatelessWidget {
  const _SideLine({required this.label, required this.value});
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
