import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/results/presentation/widgets/components/results_models.dart';

class ResultsIdeasPanel extends StatelessWidget {
  const ResultsIdeasPanel({super.key, required this.ideas, required this.decisions});

  final List<ResultIdea> ideas;
  final List<ResultDecision> decisions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionCard(
          title: 'أفكار جديدة تميّز المصنع',
          subtitle: 'مقترحات عملية تساعد المصنع يبقى أقوى وأكثر تميزاً في التشغيل والنتائج.',
          child: Column(
            children: ideas
                .map(
                  (idea) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: idea.accent.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(20), border: Border.all(color: idea.accent.withValues(alpha: 0.16))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(width: 42, height: 42, decoration: BoxDecoration(color: idea.accent.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(14)), child: Icon(idea.icon, color: idea.accent)),
                          const SizedBox(width: 12),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(idea.title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 6), Text(idea.description, style: const TextStyle(color: Color(0xFF667B75), height: 1.5))])),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'قرارات استراتيجية مقترحة',
          subtitle: 'ترجمة النتائج الحالية إلى قرارات واضحة يمكن للإدارة التحرك بها بسرعة.',
          child: Column(
            children: decisions
                .map(
                  (decision) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: decision.accent.withValues(alpha: 0.14))),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [Expanded(child: Text(decision.label, style: const TextStyle(fontWeight: FontWeight.w900))), Text(decision.value, style: TextStyle(color: decision.accent, fontWeight: FontWeight.w900))]),
                        const SizedBox(height: 8),
                        Text(decision.note, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
                      ]),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
