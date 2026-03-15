import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class FinanceSection extends StatelessWidget {
  const FinanceSection({super.key, required this.financialReports});

  final List<FinancialReport> financialReports;

  @override
  Widget build(BuildContext context) {
    final totalIncome = financialReports.fold<double>(0, (sum, report) => sum + report.income);
    final totalExpenses = financialReports.fold<double>(0, (sum, report) => sum + report.expenses);
    final totalProfit = financialReports.fold<double>(0, (sum, report) => sum + report.profit);
    final profitMargin = totalIncome == 0 ? 0.0 : totalProfit / totalIncome;
    final losses = (totalExpenses * 0.11).roundToDouble();

    return SectionCard(
      title: 'Finance',
      subtitle: 'Financial performance overview with monthly summaries and key indicators.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FinanceStatCard(
                title: 'Total Income',
                value: totalIncome.round().toString(),
                note: 'Accumulated from all reports',
                color: const Color(0xFF0F766E),
                icon: Icons.account_balance_wallet_rounded,
              ),
              FinanceStatCard(
                title: 'Net Profit',
                value: totalProfit.round().toString(),
                note: 'Current total profitability',
                color: const Color(0xFF16A34A),
                icon: Icons.payments_rounded,
              ),
              FinanceStatCard(
                title: 'Estimated Losses',
                value: losses.round().toString(),
                note: 'Calculated from expense pressure',
                color: const Color(0xFFDC2626),
                icon: Icons.trending_down_rounded,
              ),
              FinanceStatCard(
                title: 'Profit Margin',
                value: '${(profitMargin * 100).round()}%',
                note: 'Margin relative to income',
                color: const Color(0xFF2563EB),
                icon: Icons.insights_rounded,
              ),
            ],
          ),
          const SizedBox(height: 18),
          const SectionCard(
            title: 'Finance Notes',
            subtitle: 'Operational observations that affect cash flow and planning.',
            child: Column(
              children: [
                FinanceNoteLine(
                  title: 'Expense control remains important',
                  description: 'Reducing unnecessary operational spending will improve net results quickly.',
                ),
                FinanceNoteLine(
                  title: 'Cash flow is stable',
                  description: 'The current pace supports purchasing and payroll commitments without pressure.',
                ),
                FinanceNoteLine(
                  title: 'Revenue growth opportunity',
                  description: 'Better client retention and upselling can raise monthly income further.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionCard(
            title: 'Monthly Reports',
            subtitle: 'Detailed breakdown for each financial report entry.',
            child: Column(
              children: financialReports.map((report) => FinanceTile(report: report)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class FinanceStatCard extends StatelessWidget {
  const FinanceStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.note,
    required this.color,
    required this.icon,
  });

  final String title;
  final String value;
  final String note;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const Spacer(),
              Container(
                width: 34,
                height: 4,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(note, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
        ],
      ),
    );
  }
}

class FinanceTile extends StatelessWidget {
  const FinanceTile({super.key, required this.report});

  final FinancialReport report;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2ECE8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  report.period,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0x140F766E),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  report.profit.round().toString(),
                  style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _FinanceMetric(
                  label: 'Income',
                  value: report.income.round().toString(),
                  color: const Color(0xFF16A34A),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FinanceMetric(
                  label: 'Expenses',
                  value: report.expenses.round().toString(),
                  color: const Color(0xFFDC2626),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FinanceMetric(
                  label: 'Profit',
                  value: report.profit.round().toString(),
                  color: const Color(0xFF2563EB),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FinanceMetric extends StatelessWidget {
  const _FinanceMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class FinanceNoteLine extends StatelessWidget {
  const FinanceNoteLine({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAF9),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(description, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
          ],
        ),
      ),
    );
  }
}
