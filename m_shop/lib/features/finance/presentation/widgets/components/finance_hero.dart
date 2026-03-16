import 'package:flutter/material.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/finance/presentation/widgets/components/finance_models.dart';

class FinanceHero extends StatelessWidget {
  const FinanceHero({
    super.key,
    required this.summary,
    required this.selectedReport,
    required this.reports,
    required this.onSelectReport,
    required this.onOpenReport,
    required this.onExport,
  });

  final FinanceSummary summary;
  final FinancialReport selectedReport;
  final List<FinancialReport> reports;
  final ValueChanged<FinancialReport> onSelectReport;
  final VoidCallback onOpenReport;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF0F172A), Color(0xFF0F766E), Color(0xFF34D399)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F766E).withValues(alpha: 0.20),
            blurRadius: 28,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const _HeroBadge(label: 'لوحة مالية ذكية'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: reports
                    .map(
                      (report) => ChoiceChip(
                        label: Text(report.period),
                        selected: report.period == selectedReport.period,
                        onSelected: (_) => onSelectReport(report),
                        selectedColor: Colors.white,
                        backgroundColor: Colors.white.withValues(alpha: 0.12),
                        labelStyle: TextStyle(
                          color: report.period == selectedReport.period ? const Color(0xFF0F172A) : Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.14)),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.spaceBetween,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'حالة السيولة الحالية ${summary.healthLabel}',
                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'إجمالي التدفق المتاح الآن ${formatCurrency(summary.availableCash)} مع اعتماد فترة ${selectedReport.period} كمرجع رئيسي للمتابعة.',
                      style: const TextStyle(color: Color(0xE8FFFFFF), height: 1.55),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        HeroStat(label: 'متوسط الربح', value: formatCurrency(summary.averageProfit)),
                        HeroStat(label: 'أعلى ربح', value: formatCurrency(summary.bestProfit)),
                        HeroStat(label: 'أفضل هامش', value: '${(summary.bestMargin * 100).round()}%'),
                      ],
                    ),
                  ],
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton.icon(
                      onPressed: onOpenReport,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF0F172A),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      ),
                      icon: const Icon(Icons.visibility_rounded),
                      label: const Text('فتح تقرير الفترة المختارة'),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: onExport,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.20)),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      ),
                      icon: const Icon(Icons.file_download_outlined),
                      label: const Text('تجهيز ملخص للتصدير'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HeroStat extends StatelessWidget {
  const HeroStat({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xE8FFFFFF), fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
        ],
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
    );
  }
}
