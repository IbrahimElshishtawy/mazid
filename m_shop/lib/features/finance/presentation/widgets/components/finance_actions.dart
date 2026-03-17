import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class FinanceActionPanel extends StatelessWidget {
  const FinanceActionPanel({
    super.key,
    required this.selectedReport,
    required this.bestReport,
    required this.pressureReport,
    required this.onExpenseAnalysis,
    required this.onComparePeriods,
    required this.onBudgetPlan,
    required this.onExport,
  });

  final FinancialReport selectedReport;
  final FinancialReport bestReport;
  final FinancialReport pressureReport;
  final VoidCallback onExpenseAnalysis;
  final VoidCallback onComparePeriods;
  final VoidCallback onBudgetPlan;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'إجراءات سريعة',
      subtitle: 'كل زر هنا ينفذ خطوة واضحة داخل الصفحة حتى تكون المتابعة عملية وليست شكلية.',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          FinanceActionButton(
            label: 'تحليل المصروفات',
            note: 'يفتح قراءة مباشرة لفترة ${selectedReport.period}',
            icon: Icons.receipt_long_rounded,
            accent: const Color(0xFFF59E0B),
            onPressed: onExpenseAnalysis,
          ),
          FinanceActionButton(
            label: 'مقارنة الأداء',
            note: 'يقارن الفترة الحالية مع ${bestReport.period}',
            icon: Icons.compare_arrows_rounded,
            accent: const Color(0xFF2563EB),
            onPressed: onComparePeriods,
          ),
          FinanceActionButton(
            label: 'خطة توزيع الربح',
            note: 'اقتراح توزيع تشغيلي للفترة المختارة',
            icon: Icons.auto_graph_rounded,
            accent: const Color(0xFF16A34A),
            onPressed: onBudgetPlan,
          ),
          FinanceActionButton(
            label: 'تصدير ملخص',
            note: 'تجهيز إشعار سريع للمراجعة',
            icon: Icons.ios_share_rounded,
            accent: const Color(0xFF0F766E),
            onPressed: onExport,
          ),
          FinanceActionHint(
            title: 'أعلى ضغط مالي',
            description: 'فترة ${pressureReport.period} تحتاج إلى متابعة دقيقة لأنها صاحبة أعلى معدل مصروفات مقابل الإيراد.',
          ),
        ],
      ),
    );
  }
}

class FinanceActionButton extends StatelessWidget {
  const FinanceActionButton({
    super.key,
    required this.label,
    required this.note,
    required this.icon,
    required this.accent,
    required this.onPressed,
  });

  final String label;
  final String note;
  final IconData icon;
  final Color accent;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(22),
          child: Ink(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: accent.withValues(alpha: 0.16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: accent),
                ),
                const SizedBox(height: 14),
                Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(note, style: const TextStyle(color: Color(0xFF667B75), height: 1.45)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FinanceActionHint extends StatelessWidget {
  const FinanceActionHint({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 120, maxWidth: 320),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFF8FCFB), Color(0xFFEAF7F3)],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2ECE8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.insights_rounded, color: Color(0xFF0F766E)),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(description, style: const TextStyle(color: Color(0xFF667B75), height: 1.45)),
        ],
      ),
    );
  }
}

