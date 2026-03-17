import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/results/presentation/widgets/components/results_models.dart';

class ResultsIdeasPanel extends StatelessWidget {
  const ResultsIdeasPanel({super.key, required this.ideas, required this.decisions});

  final List<ResultIdea> ideas;
  final List<ResultDecision> decisions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: idea.accent.withValues(alpha: theme.brightness == Brightness.dark ? 0.12 : 0.06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: idea.accent.withValues(alpha: 0.16)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: idea.accent.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(idea.icon, color: idea.accent, size: 18),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  idea.title,
                                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w900),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  idea.description,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    height: 1.45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 12),
        SectionCard(
          title: 'قرارات استراتيجية مقترحة',
          subtitle: 'ترجمة النتائج الحالية إلى قرارات واضحة يمكن للإدارة التحرك بها بسرعة.',
          child: Column(
            children: decisions
                .map(
                  (decision) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: decision.accent.withValues(alpha: 0.16)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  decision.label,
                                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w900),
                                ),
                              ),
                              Text(
                                decision.value,
                                style: TextStyle(color: decision.accent, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            decision.note,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
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

