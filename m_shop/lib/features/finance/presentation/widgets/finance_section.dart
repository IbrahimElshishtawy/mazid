import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/finance/presentation/widgets/components/finance_actions.dart';
import 'package:m_shop/features/finance/presentation/widgets/components/finance_chart.dart';
import 'package:m_shop/features/finance/presentation/widgets/components/finance_hero.dart';
import 'package:m_shop/features/finance/presentation/widgets/components/finance_insights.dart';
import 'package:m_shop/features/finance/presentation/widgets/components/finance_metrics.dart';
import 'package:m_shop/features/finance/presentation/widgets/components/finance_models.dart';
import 'package:m_shop/features/finance/presentation/widgets/components/finance_report_tile.dart';
import 'package:m_shop/features/finance/presentation/widgets/components/finance_sheet.dart';

class FinanceSection extends StatefulWidget {
  const FinanceSection({super.key, required this.financialReports});

  final List<FinancialReport> financialReports;

  @override
  State<FinanceSection> createState() => _FinanceSectionState();
}

class _FinanceSectionState extends State<FinanceSection> {
  FinancialReport? _selectedReport;

  @override
  void initState() {
    super.initState();
    if (widget.financialReports.isNotEmpty) {
      _selectedReport = widget.financialReports.last;
    }
  }

  @override
  Widget build(BuildContext context) {
    final reports = widget.financialReports;
    if (reports.isEmpty) {
      return const SectionCard(
        title: 'التمويل والتحليل المالي',
        subtitle: 'لا توجد بيانات مالية متاحة حالياً لعرضها في هذا القسم.',
        child: SizedBox(
          height: 120,
          child: Center(
            child: Text(
              'أضف تقارير مالية أولاً حتى تظهر التحليلات والرسوم البيانية.',
              style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF667B75)),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final selectedReport = _selectedReport ?? reports.last;
    final summary = FinanceSummary.fromReports(reports);
    final selectedSummary = FinanceSnapshot.fromReport(selectedReport);
    final bestReport = bestProfitReport(reports);
    final pressureReport = highestExpensePressureReport(reports);
    final layout = FinanceLayout.fromWidth(MediaQuery.sizeOf(context).width);

    return SectionCard(
      title: 'التمويل والتحليل المالي',
      subtitle: 'لوحة مالية احترافية تعرض الأداء وتحول كل إجراء داخل الصفحة إلى خطوة عملية قابلة للتنفيذ.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FinanceHero(
            summary: summary,
            selectedReport: selectedReport,
            reports: reports,
            onSelectReport: _selectReport,
            onOpenReport: () => _showReportDetails(selectedReport),
            onExport: () => _exportSummary(selectedReport),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FinanceMetricCard(
                width: layout.metricCardWidth,
                title: 'إجمالي الإيرادات',
                value: formatCurrency(summary.totalIncome),
                note: 'إجمالي التدفقات الداخلة من جميع الفترات',
                accent: const Color(0xFF0F766E),
                icon: Icons.account_balance_wallet_rounded,
              ),
              FinanceMetricCard(
                width: layout.metricCardWidth,
                title: 'صافي الربح',
                value: formatCurrency(summary.totalProfit),
                note: 'بعد خصم المصروفات المباشرة والتشغيلية',
                accent: const Color(0xFF16A34A),
                icon: Icons.savings_rounded,
              ),
              FinanceMetricCard(
                width: layout.metricCardWidth,
                title: 'نسبة المصروفات',
                value: '${(summary.expenseRatio * 100).round()}%',
                note: 'مستوى الضغط على السيولة مقارنة بالإيراد',
                accent: const Color(0xFFF59E0B),
                icon: Icons.pie_chart_outline_rounded,
              ),
              FinanceMetricCard(
                width: layout.metricCardWidth,
                title: 'الهامش الربحي',
                value: '${(summary.margin * 100).round()}%',
                note: 'يعكس جودة التسعير وكفاءة التشغيل',
                accent: const Color(0xFF2563EB),
                icon: Icons.show_chart_rounded,
              ),
            ],
          ),
          const SizedBox(height: 20),
          FinanceActionPanel(
            selectedReport: selectedReport,
            bestReport: bestReport,
            pressureReport: pressureReport,
            onExpenseAnalysis: () => _openExpenseAnalysis(selectedReport),
            onComparePeriods: () => _compareWith(selectedReport, bestReport),
            onBudgetPlan: () => _showBudgetPlan(selectedReport),
            onExport: () => _exportSummary(selectedReport),
          ),
          const SizedBox(height: 20),
          FinanceChartCard(reports: reports, summary: summary),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: layout.primaryPanelWidth,
                child: FinanceInsightPanel(
                  selectedReport: selectedReport,
                  bestReport: bestReport,
                  pressureReport: pressureReport,
                  summary: summary,
                ),
              ),
              SizedBox(
                width: layout.secondaryPanelWidth,
                child: FinanceAllocationPanel(snapshot: selectedSummary),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SectionCard(
            title: 'الفترات المالية',
            subtitle: 'كل بطاقة تعرض ملخصاً سريعاً ومعها أزرار لاختيار الفترة أو عرض تفاصيلها.',
            child: Column(
              children: reports
                  .map(
                    (report) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: FinanceReportTile(
                        report: report,
                        selected: report.period == selectedReport.period,
                        onSelect: () => _selectReport(report),
                        onViewDetails: () => _showReportDetails(report),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _selectReport(FinancialReport report) {
    setState(() {
      _selectedReport = report;
    });
  }

  Future<void> _openExpenseAnalysis(FinancialReport report) {
    final ratio = report.income == 0 ? 0.0 : report.expenses / report.income;
    final message = ratio >= 0.7
        ? 'المصروفات مرتفعة في ${report.period}. يفضل مراجعة التكاليف الثابتة أولاً.'
        : 'المصروفات تحت السيطرة في ${report.period} ويمكن التوسع بحذر.';

    return showFinanceInfoSheet(
      context: context,
      title: 'تحليل المصروفات',
      subtitle: 'قراءة سريعة للفترة المختارة مع توصية تنفيذية مباشرة.',
      children: [
        FinanceSheetLine(label: 'الفترة', value: report.period),
        FinanceSheetLine(label: 'المصروفات', value: formatCurrency(report.expenses)),
        FinanceSheetLine(label: 'النسبة من الإيراد', value: '${(ratio * 100).round()}%'),
        FinanceSheetMessage(message: message),
      ],
    );
  }

  Future<void> _compareWith(FinancialReport currentReport, FinancialReport targetReport) {
    final profitGap = targetReport.profit - currentReport.profit;
    final incomeGap = targetReport.income - currentReport.income;
    final title = targetReport.period == currentReport.period
        ? 'الفترة الحالية هي الأفضل بالفعل'
        : 'مقارنة ${currentReport.period} مع ${targetReport.period}';

    return showFinanceInfoSheet(
      context: context,
      title: title,
      subtitle: 'مقارنة عملية تساعدك على تحديد أين التحسين المطلوب.',
      children: [
        FinanceSheetLine(label: 'ربح الفترة الحالية', value: formatCurrency(currentReport.profit)),
        FinanceSheetLine(label: 'ربح الفترة المقارنة', value: formatCurrency(targetReport.profit)),
        FinanceSheetLine(label: 'فارق الربح', value: formatCurrency(profitGap.abs())),
        FinanceSheetLine(label: 'فارق الإيراد', value: formatCurrency(incomeGap.abs())),
        FinanceSheetMessage(
          message: profitGap <= 0
              ? 'الفترة الحالية تتفوق أو تساوي الفترة المقارنة في الربحية.'
              : 'رفع المبيعات أو خفض المصروفات بنفس قيمة الفارق سيقرب الأداء من ${targetReport.period}.',
        ),
      ],
    );
  }

  Future<void> _showBudgetPlan(FinancialReport report) {
    final reserve = report.profit * 0.35;
    final operations = report.profit * 0.40;
    final growth = report.profit * 0.25;

    return showFinanceInfoSheet(
      context: context,
      title: 'خطة توزيع الربح',
      subtitle: 'تقسيم عملي للفترة المختارة لتسهيل اتخاذ القرار.',
      children: [
        FinanceSheetLine(label: 'احتياطي سيولة', value: formatCurrency(reserve)),
        FinanceSheetLine(label: 'تشغيل وتحسين جودة', value: formatCurrency(operations)),
        FinanceSheetLine(label: 'توسع وتسويق', value: formatCurrency(growth)),
        const FinanceSheetMessage(
          message: 'يمكن استخدام هذه الخطة كنقطة بداية قبل اعتماد الميزانية النهائية مع الإدارة.',
        ),
      ],
    );
  }

  Future<void> _showReportDetails(FinancialReport report) {
    final snapshot = FinanceSnapshot.fromReport(report);

    return showFinanceInfoSheet(
      context: context,
      title: 'تفاصيل ${report.period}',
      subtitle: 'ملف مبسط للفترة مع أهم الأرقام والنسبة الحرجة.',
      children: [
        FinanceSheetLine(label: 'الإيراد', value: formatCurrency(report.income)),
        FinanceSheetLine(label: 'المصروفات', value: formatCurrency(report.expenses)),
        FinanceSheetLine(label: 'الربح', value: formatCurrency(report.profit)),
        FinanceSheetLine(label: 'الهامش الربحي', value: '${(snapshot.margin * 100).round()}%'),
        FinanceSheetLine(label: 'السيولة المتاحة', value: formatCurrency(snapshot.availableCash)),
        FinanceSheetMessage(message: snapshot.statusMessage),
      ],
    );
  }

  void _exportSummary(FinancialReport report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تجهيز ملخص ${report.period} للتصدير والمراجعة.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
