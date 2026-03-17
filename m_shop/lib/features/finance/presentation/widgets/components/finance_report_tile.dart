import 'package:flutter/material.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/finance/presentation/widgets/components/finance_models.dart';

class FinanceReportTile extends StatelessWidget {
  const FinanceReportTile({
    super.key,
    required this.report,
    required this.selected,
    required this.onSelect,
    required this.onViewDetails,
  });

  final FinancialReport report;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    final snapshot = FinanceSnapshot.fromReport(report);
    final accent = snapshot.margin >= 0.30 ? const Color(0xFF16A34A) : const Color(0xFFF59E0B);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF0F766E).withValues(alpha: 0.10) : Theme.of(context).colorScheme.surface.withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: selected ? accent : const Color(0xFFE2ECE8),
          width: selected ? 1.4 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(report.period, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 6),
                    Text(snapshot.statusMessage, style: const TextStyle(color: Color(0xFF667B75), height: 1.45)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'هامش ${(snapshot.margin * 100).round()}%',
                  style: TextStyle(color: accent, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ReportChip(label: 'الإيراد', value: formatCurrency(report.income), color: const Color(0xFF0F766E)),
              ReportChip(label: 'المصروفات', value: formatCurrency(report.expenses), color: const Color(0xFFDC2626)),
              ReportChip(label: 'الربح', value: formatCurrency(report.profit), color: const Color(0xFF2563EB)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onSelect,
                  icon: Icon(selected ? Icons.check_circle_rounded : Icons.touch_app_rounded),
                  label: Text(selected ? 'مفعلة الآن' : 'اختيار الفترة'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onViewDetails,
                  icon: const Icon(Icons.visibility_rounded),
                  label: const Text('عرض التفاصيل'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReportChip extends StatelessWidget {
  const ReportChip({
    super.key,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2ECE8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w700)),
          Text(value, style: const TextStyle(color: Color(0xFF667B75))),
        ],
      ),
    );
  }
}

