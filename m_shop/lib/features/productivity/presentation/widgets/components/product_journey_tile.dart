import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/productivity/presentation/widgets/components/productivity_models.dart';

class ProductJourneyPanel extends StatelessWidget {
  const ProductJourneyPanel({
    super.key,
    required this.selectedJourney,
    required this.selectedStepTitle,
    required this.onSelectStep,
    required this.onOpenStep,
  });

  final ProductJourney selectedJourney;
  final String selectedStepTitle;
  final ValueChanged<ProductStep> onSelectStep;
  final ValueChanged<ProductStep> onOpenStep;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'رحلة المنتج وخطوات التشغيل',
      subtitle: 'متابعة الخامات والمراحل الفعلية للمنتج مع الماكينة والعامل المسؤول عن كل خطوة.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.48), borderRadius: BorderRadius.circular(22)),
            child: Wrap(
              spacing: 18,
              runSpacing: 12,
              children: [
                _TopInfo(label: 'الخامة الأساسية', value: selectedJourney.rawMaterial),
                _TopInfo(label: 'الناتج النهائي', value: selectedJourney.output),
                _TopInfo(label: 'المشرف', value: selectedJourney.supervisor),
                _TopInfo(label: 'نسبة الإنجاز', value: formatPercent(selectedJourney.completionRatio)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...selectedJourney.steps.map(
            (step) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _StepTile(
                step: step,
                selected: step.title == selectedStepTitle,
                onTap: () => onSelectStep(step),
                onOpen: () => onOpenStep(step),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopInfo extends StatelessWidget {
  const _TopInfo({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF667B75), fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, height: 1.35)),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({required this.step, required this.selected, required this.onTap, required this.onOpen});

  final ProductStep step;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selected ? step.accent.withValues(alpha: 0.08) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: selected ? step.accent.withValues(alpha: 0.34) : const Color(0xFFE0EBE7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(step.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: step.accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)),
                child: Text(step.status, style: TextStyle(color: step.accent, fontWeight: FontWeight.w800, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(step.description, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: step.progress.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: step.accent.withValues(alpha: 0.12),
              color: step.accent,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 10,
            children: [
              _MiniInfo(label: 'الماكينة', value: step.machine),
              _MiniInfo(label: 'العامل', value: step.operator),
              _MiniInfo(label: 'المدة', value: '${step.durationHours} ساعة'),
              _MiniInfo(label: 'بوابة الجودة', value: step.qualityGate),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              OutlinedButton(onPressed: onTap, child: const Text('تحديد كمرحلة نشطة')),
              const SizedBox(width: 10),
              FilledButton(onPressed: onOpen, child: const Text('عرض التفاصيل')),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniInfo extends StatelessWidget {
  const _MiniInfo({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF667B75), fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, height: 1.35)),
        ],
      ),
    );
  }
}

