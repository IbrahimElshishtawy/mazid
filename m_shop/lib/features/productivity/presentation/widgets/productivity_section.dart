import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class ProductivitySection extends StatelessWidget {
  const ProductivitySection({super.key, required this.production});

  final List<ProductionPoint> production;

  @override
  Widget build(BuildContext context) {
    final actual = production.fold<double>(0, (sum, item) => sum + item.actual);
    final target = production.fold<double>(0, (sum, item) => sum + item.target);
    final ratio = target == 0 ? 0.0 : actual / target;

    return SectionCard(
      title: 'Productivity',
      subtitle: 'Performance against target and production trend by period.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _ProductivityStat(title: 'Actual', value: actual.round().toString(), color: const Color(0xFF0F766E)),
              _ProductivityStat(title: 'Target', value: target.round().toString(), color: const Color(0xFF2563EB)),
              _ProductivityStat(title: 'Completion', value: '${(ratio * 100).round()}%', color: const Color(0xFF16A34A)),
            ],
          ),
          const SizedBox(height: 18),
          ...production.map((point) => _ProductionTile(point: point)),
        ],
      ),
    );
  }
}

class _ProductivityStat extends StatelessWidget {
  const _ProductivityStat({required this.title, required this.value, required this.color});
  final String title;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(width: 180, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withValues(alpha: 0.12))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 34, height: 4, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999))), const SizedBox(height: 12), Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w700)), const SizedBox(height: 8), Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900))]));
  }
}

class _ProductionTile extends StatelessWidget {
  const _ProductionTile({required this.point});
  final ProductionPoint point;
  @override
  Widget build(BuildContext context) {
    final ratio = point.target == 0 ? 0.0 : (point.actual / point.target).clamp(0.0, 1.0).toDouble();
    final accent = point.actual >= point.target ? const Color(0xFF16A34A) : const Color(0xFFF59E0B);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF7FAF9), borderRadius: BorderRadius.circular(18)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Expanded(child: Text(point.label, style: const TextStyle(fontWeight: FontWeight.w800))), Text('${point.actual.round()} / ${point.target.round()}', style: TextStyle(color: accent, fontWeight: FontWeight.w800))]),
        const SizedBox(height: 8),
        ClipRRect(borderRadius: BorderRadius.circular(999), child: LinearProgressIndicator(value: ratio, minHeight: 10, color: accent, backgroundColor: accent.withValues(alpha: 0.12))),
      ]),
    );
  }
}
