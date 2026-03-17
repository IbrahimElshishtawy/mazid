import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';

class ResultsActionPanel extends StatelessWidget {
  const ResultsActionPanel({
    super.key,
    required this.onOpenStrategy,
    required this.onOpenProfitPlan,
    required this.onOpenRiskPlan,
    required this.onOpenFactoryIdeas,
    required this.onExport,
  });

  final VoidCallback onOpenStrategy;
  final VoidCallback onOpenProfitPlan;
  final VoidCallback onOpenRiskPlan;
  final VoidCallback onOpenFactoryIdeas;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'قرارات الإدارة السريعة',
      subtitle: 'كل زر يفتح قرار تنفيذي يساعد المصنع يحوّل النتائج الحالية إلى خطة عمل واضحة.',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _ActionCard(label: 'الخطة الاستراتيجية', icon: Icons.flag_rounded, accent: const Color(0xFF0F766E), onTap: onOpenStrategy),
          _ActionCard(label: 'خطة تعظيم الربح', icon: Icons.attach_money_rounded, accent: const Color(0xFF16A34A), onTap: onOpenProfitPlan),
          _ActionCard(label: 'خطة تقليل المخاطر', icon: Icons.shield_moon_rounded, accent: const Color(0xFFDC2626), onTap: onOpenRiskPlan),
          _ActionCard(label: 'أفكار تطوير المصنع', icon: Icons.lightbulb_rounded, accent: const Color(0xFF2563EB), onTap: onOpenFactoryIdeas),
          _ActionCard(label: 'تجهيز تقرير تنفيذي', icon: Icons.file_present_rounded, accent: const Color(0xFF7C3AED), onTap: onExport),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.label, required this.icon, required this.accent, required this.onTap});

  final String label;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 208,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: accent.withValues(alpha: 0.14))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: accent)),
          const SizedBox(height: 14),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w800, height: 1.35)),
          const SizedBox(height: 8),
          Text('خطوة مباشرة قابلة للتنفيذ داخل المصنع.', style: const TextStyle(color: Color(0xFF667B75), height: 1.4)),
        ]),
      ),
    );
  }
}

