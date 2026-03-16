import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/finance/presentation/widgets/components/finance_models.dart';

class FinanceInsightPanel extends StatelessWidget {
  const FinanceInsightPanel({
    super.key,
    required this.selectedReport,
    required this.bestReport,
    required this.pressureReport,
    required this.summary,
  });

  final FinancialReport selectedReport;
  final FinancialReport bestReport;
  final FinancialReport pressureReport;
  final FinanceSummary summary;

  @override
  Widget build(BuildContext context) {
    final insights = [
      FinanceInsightData(
        title: 'أفضل فترة للربحية',
        description: '${bestReport.period} حققت ${formatCurrency(bestReport.profit)} وهي الأعلى بين الفترات الحالية.',
        accent: const Color(0xFF16A34A),
        icon: Icons.workspace_premium_rounded,
      ),
      FinanceInsightData(
        title: 'الفترة المختارة حالياً',
        description: '${selectedReport.period} بهامش ${(summary.marginFor(selectedReport) * 100).round()}% وسيولة متاحة ${formatCurrency(FinanceSnapshot.fromReport(selectedReport).availableCash)}.',
        accent: const Color(0xFF2563EB),
        icon: Icons.radio_button_checked_rounded,
      ),
      FinanceInsightData(
        title: 'فترة تحتاج إلى تدخل',
        description: '${pressureReport.period} تستهلك ${(summary.expenseRatioFor(pressureReport) * 100).round()}% من إيرادها كمصروفات.',
        accent: const Color(0xFFF59E0B),
        icon: Icons.warning_amber_rounded,
      ),
    ];

    return SectionCard(
      title: 'قراءات ذكية',
      subtitle: 'خلاصة تنفيذية تساعدك على فهم الوضع والتحرك بشكل أسرع.',
      child: Column(
        children: insights
            .map(
              (insight) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FinanceInsightTile(data: insight),
              ),
            )
            .toList(),
      ),
    );
  }
}

class FinanceAllocationPanel extends StatelessWidget {
  const FinanceAllocationPanel({super.key, required this.snapshot});

  final FinanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final items = [
      FinanceAllocationData(label: 'تشغيل', amount: snapshot.operationalBudget, color: const Color(0xFF0F766E)),
      FinanceAllocationData(label: 'احتياطي', amount: snapshot.reserveBudget, color: const Color(0xFF2563EB)),
      FinanceAllocationData(label: 'توسع', amount: snapshot.growthBudget, color: const Color(0xFF16A34A)),
    ];

    return SectionCard(
      title: 'توزيع الربح المقترح',
      subtitle: 'تفصيل مبسط يحول الربح إلى قرارات تشغيلية واضحة.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(snapshot.statusMessage, style: const TextStyle(color: Color(0xFF30413D), height: 1.5)),
          const SizedBox(height: 18),
          ...items.map((item) => AllocationBar(item: item, total: snapshot.report.profit)),
        ],
      ),
    );
  }
}

class FinanceInsightTile extends StatelessWidget {
  const FinanceInsightTile({super.key, required this.data});

  final FinanceInsightData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: data.accent.withValues(alpha: 0.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: data.accent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(data.icon, color: data.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.title, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(data.description, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AllocationBar extends StatelessWidget {
  const AllocationBar({super.key, required this.item, required this.total});

  final FinanceAllocationData item;
  final double total;

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : (item.amount / total).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(item.label, style: TextStyle(color: item.color, fontWeight: FontWeight.w800))),
              Text(formatCurrency(item.amount), style: const TextStyle(fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 10,
              color: item.color,
              backgroundColor: const Color(0xFFD9E6E2),
            ),
          ),
        ],
      ),
    );
  }
}
