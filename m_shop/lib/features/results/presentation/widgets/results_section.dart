import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/results/presentation/widgets/components/results_actions.dart';
import 'package:m_shop/features/results/presentation/widgets/components/results_charts.dart';
import 'package:m_shop/features/results/presentation/widgets/components/results_hero.dart';
import 'package:m_shop/features/results/presentation/widgets/components/results_ideas.dart';
import 'package:m_shop/features/results/presentation/widgets/components/results_metrics.dart';
import 'package:m_shop/features/results/presentation/widgets/components/results_models.dart';
import 'package:m_shop/features/results/presentation/widgets/components/results_sheet.dart';

class ResultsSection extends StatelessWidget {
  const ResultsSection({
    super.key,
    required this.production,
    required this.tasks,
    required this.inventory,
    required this.financialReports,
    required this.attendance,
    required this.alerts,
  });

  final List<ProductionPoint> production;
  final List<TaskModel> tasks;
  final List<InventoryItem> inventory;
  final List<FinancialReport> financialReports;
  final List<AttendanceRecord> attendance;
  final List<AlertModel> alerts;

  @override
  Widget build(BuildContext context) {
    final summary = ResultsSummary.fromData(
      production: production,
      tasks: tasks,
      inventory: inventory,
      financialReports: financialReports,
      attendance: attendance,
      alerts: alerts,
    );
    final layout = ResultsLayout.fromWidth(MediaQuery.sizeOf(context).width);
    final ideas = buildFactoryIdeas(summary);
    final decisions = buildStrategicDecisions(summary);

    return SectionCard(
      title: 'لوحة النتائج الاستراتيجية',
      subtitle: 'واجهة احترافية تجمع نتائج المصنع وتحوّلها إلى قرارات تشغيلية وربحية ومخاطر وفرص تطوير بشكل منظم وواضح.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ResultsHero(
            summary: summary,
            onOpenStrategy: () => _showStrategy(context, summary),
            onOpenFactoryMap: () => _showFactoryMap(context, summary),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ResultsMetricCard(width: layout.metricWidth, title: 'التنفيذ الكلي', value: formatPercent(summary.executionRate), note: 'نسبة الإنتاج الفعلي مقارنة بالمستهدف العام للمصنع.', accent: const Color(0xFF0F766E), icon: Icons.factory_rounded),
              ResultsMetricCard(width: layout.metricWidth, title: 'صافي النتيجة', value: formatCurrency(summary.netResult), note: 'قراءة مالية مبسطة بعد خصم ضغط المصروفات التشغيلية.', accent: const Color(0xFF16A34A), icon: Icons.ssid_chart_rounded),
              ResultsMetricCard(width: layout.metricWidth, title: 'المخاطر الحالية', value: formatPercent(summary.riskRate), note: 'مؤشر مركب من التنبيهات وتأخر المهام والضغط التشغيلي.', accent: const Color(0xFFDC2626), icon: Icons.warning_amber_rounded),
              ResultsMetricCard(width: layout.metricWidth, title: 'المخزون المتاح', value: '${summary.totalInventory.round()}', note: 'إجمالي الكميات المتاحة حالياً للعناصر الأساسية بالمصنع.', accent: const Color(0xFF2563EB), icon: Icons.inventory_2_rounded),
            ],
          ),
          const SizedBox(height: 20),
          ResultsActionPanel(
            onOpenStrategy: () => _showStrategy(context, summary),
            onOpenProfitPlan: () => _showProfitPlan(context, summary),
            onOpenRiskPlan: () => _showRiskPlan(context, summary),
            onOpenFactoryIdeas: () => _showIdeas(context, ideas),
            onExport: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تجهيز تقرير تنفيذي للنتائج بنجاح.'))),
          ),
          const SizedBox(height: 20),
          ResultsChartsGrid(
            production: production,
            tasks: tasks,
            inventory: inventory,
            financialReports: financialReports,
            attendance: attendance,
            alerts: alerts,
            summary: summary,
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(width: layout.primaryWidth, child: ResultsIdeasPanel(ideas: ideas, decisions: decisions)),
              SizedBox(
                width: layout.secondaryWidth,
                child: SectionCard(
                  title: 'ملخص تنفيذي سريع',
                  subtitle: 'ماذا يجب أن تفعله الإدارة الآن بناءً على النتائج المعروضة.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _QuickLine(title: 'الأولوية الأولى', text: summary.riskRate > 0.35 ? 'تقليل الضغط على الماكينات ومراجعة التنبيهات المفتوحة فوراً.' : 'دفع المنتجات القريبة من الاكتمال لزيادة التسليم السريع.'),
                      _QuickLine(title: 'الأولوية الثانية', text: summary.executionRate < 0.85 ? 'إعادة توزيع العمال أو إضافة دعم على الخطوط الأبطأ.' : 'تثبيت الوتيرة الحالية مع مراقبة الجودة اليومية.'),
                      _QuickLine(title: 'الأولوية الثالثة', text: summary.netResult > 0 ? 'استثمار جزء من الربح في صيانة وقائية وتحسين مسار الخامات.' : 'إعادة ضبط التكلفة وتقليل الهدر قبل التوسع.'),
                      const SizedBox(height: 8),
                      FilledButton.icon(onPressed: () => _showFactoryMap(context, summary), icon: const Icon(Icons.analytics_outlined), label: const Text('قراءة الصورة النهائية')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showStrategy(BuildContext context, ResultsSummary summary) {
    return showResultsInfoSheet(
      context: context,
      title: 'الخطة الاستراتيجية',
      subtitle: 'ماذا تقول نتائج المصنع الآن؟',
      children: [
        ResultsSheetLine(label: 'حالة التنفيذ', value: formatPercent(summary.executionRate)),
        ResultsSheetLine(label: 'صافي النتيجة', value: formatCurrency(summary.netResult)),
        ResultsSheetLine(label: 'مستوى المخاطر', value: formatPercent(summary.riskRate)),
        ResultsSheetLine(label: 'الحضور', value: formatPercent(summary.attendanceRate)),
        ResultsSheetMessage(message: 'الأفضل حالياً هو ربط الإنتاج بالربحية والمخاطر في قرار واحد: ارفع التنفيذ فقط في الخطوط التي تحافظ على الجودة ولا تضاعف التنبيهات.'),
      ],
    );
  }

  Future<void> _showFactoryMap(BuildContext context, ResultsSummary summary) {
    return showResultsInfoSheet(
      context: context,
      title: 'خريطة النتائج داخل المصنع',
      subtitle: 'قراءة تربط بين المخزون والتنفيذ والماليات والضغط التشغيلي.',
      children: [
        ResultsSheetLine(label: 'الإنتاج الفعلي', value: '${summary.totalActual.round()}'),
        ResultsSheetLine(label: 'المخزون الحالي', value: '${summary.totalInventory.round()}'),
        ResultsSheetLine(label: 'التنبيهات', value: '${summary.alertCount}'),
        ResultsSheetLine(label: 'المهام المكتملة', value: '${summary.completedTasks}'),
        ResultsSheetMessage(message: 'لو المخزون كافٍ والتنفيذ منخفض، فالمشكلة غالباً في الاختناقات أو توزيع العمل، وليس في توافر الخامات فقط.'),
      ],
    );
  }

  Future<void> _showProfitPlan(BuildContext context, ResultsSummary summary) {
    return showResultsInfoSheet(
      context: context,
      title: 'خطة تعظيم الربح',
      subtitle: 'خطوات مقترحة لرفع النتيجة الصافية من غير ضغط غير محسوب على المصنع.',
      children: [
        ResultsSheetLine(label: 'إجمالي الربح', value: formatCurrency(summary.totalProfit)),
        ResultsSheetLine(label: 'إجمالي المصروفات', value: formatCurrency(summary.totalExpenses)),
        ResultsSheetLine(label: 'النتيجة الصافية', value: formatCurrency(summary.netResult)),
        const ResultsSheetMessage(message: 'ركّز على تقليل الهدر، تسريع المنتجات القريبة من الاكتمال، واختيار أوامر التشغيل الأعلى هامشاً بدلاً من ملاحقة الحجم فقط.'),
      ],
    );
  }

  Future<void> _showRiskPlan(BuildContext context, ResultsSummary summary) {
    return showResultsInfoSheet(
      context: context,
      title: 'خطة تقليل المخاطر',
      subtitle: 'قراءة عملية لتقليل التوقفات والتأخير والضغط التشغيلي.',
      children: [
        ResultsSheetLine(label: 'المخاطر الحالية', value: formatPercent(summary.riskRate)),
        ResultsSheetLine(label: 'التنبيهات المفتوحة', value: '${summary.alertCount}'),
        ResultsSheetLine(label: 'المهام الجارية', value: '${summary.inProgressTasks}'),
        const ResultsSheetMessage(message: 'ابدأ بالخطوط التي تجمع بين تأخر المهام وكثرة التنبيهات، ثم ثبّت الصيانة الوقائية قبل توسيع التشغيل.'),
      ],
    );
  }

  Future<void> _showIdeas(BuildContext context, List<ResultIdea> ideas) {
    return showResultsInfoSheet(
      context: context,
      title: 'أفكار تطوير المصنع',
      subtitle: 'أفكار جديدة قابلة للتنفيذ بناءً على البيانات الحالية.',
      children: [
        ...ideas.map((idea) => ResultsSheetLine(label: idea.title, value: 'جاهزة للتنفيذ')),
        const ResultsSheetMessage(message: 'اختيار فكرتين فقط للتجربة كل أسبوع أفضل من فتح مبادرات كثيرة في نفس الوقت من غير متابعة واضحة.'),
      ],
    );
  }
}

class _QuickLine extends StatelessWidget {
  const _QuickLine({required this.title, required this.text});
  final String title;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.48), borderRadius: BorderRadius.circular(18)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 6), Text(text, style: const TextStyle(color: Color(0xFF667B75), height: 1.5))]),
      ),
    );
  }
}

