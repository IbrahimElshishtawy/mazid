import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/productivity/presentation/widgets/components/machine_status_panel.dart';
import 'package:m_shop/features/productivity/presentation/widgets/components/product_journey_tile.dart';
import 'package:m_shop/features/productivity/presentation/widgets/components/productivity_actions.dart';
import 'package:m_shop/features/productivity/presentation/widgets/components/productivity_charts.dart';
import 'package:m_shop/features/productivity/presentation/widgets/components/productivity_hero.dart';
import 'package:m_shop/features/productivity/presentation/widgets/components/productivity_metrics.dart';
import 'package:m_shop/features/productivity/presentation/widgets/components/productivity_models.dart';
import 'package:m_shop/features/productivity/presentation/widgets/components/productivity_sheet.dart';

class ProductivitySection extends StatefulWidget {
  const ProductivitySection({super.key, required this.production});

  final List<ProductionPoint> production;

  @override
  State<ProductivitySection> createState() => _ProductivitySectionState();
}

class _ProductivitySectionState extends State<ProductivitySection> {
  late final List<ProductJourney> _journeys;
  ProductJourney? _selectedJourney;
  ProductStep? _selectedStep;
  MachineInfo? _selectedMachine;

  @override
  void initState() {
    super.initState();
    _journeys = buildProductJourneys(widget.production);
    if (_journeys.isNotEmpty) {
      _selectedJourney = _journeys.first;
      _selectedStep = _journeys.first.steps.first;
      _selectedMachine = _journeys.first.machines.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_journeys.isEmpty) {
      return const SectionCard(
        title: 'متابعة دورة المنتج',
        subtitle: 'لا توجد بيانات إنتاج كافية لعرض رحلة المنتجات حالياً.',
        child: SizedBox(
          height: 120,
          child: Center(
            child: Text(
              'أضف بيانات الإنتاج أولاً حتى تظهر متابعة الخامات والمراحل والمكن والجرافات.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF667B75)),
            ),
          ),
        ),
      );
    }

    final selectedJourney = _selectedJourney ?? _journeys.first;
    final selectedStep = _selectedStep ?? selectedJourney.steps.first;
    final selectedMachine = _selectedMachine ?? selectedJourney.machines.first;
    final summary = ProductivitySummary.fromJourneys(_journeys);
    final layout = ProductivityLayout.fromWidth(MediaQuery.sizeOf(context).width);
    final mergedMachines = _journeys.expand((journey) => journey.machines).toList();

    return SectionCard(
      title: 'متابعة دورة المنتج',
      subtitle: 'شاشة عربية احترافية لمتابعة المنتجات من أول الخامات إلى الخروج النهائي مع التحكم في الخطوات والمكن والمراجعة التشغيلية.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProductivityHero(
            summary: summary,
            selectedJourney: selectedJourney,
            onOpenFlow: () => _showJourneyFlow(selectedJourney),
            onOpenMachine: () => _showMachineReport(selectedMachine),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _journeys.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final journey = _journeys[index];
                final selected = journey.sku == selectedJourney.sku;
                return ChoiceChip(
                  selected: selected,
                  label: Text(journey.name),
                  onSelected: (_) => _selectJourney(journey),
                  selectedColor: const Color(0xFF0F766E),
                  backgroundColor: const Color(0xFFF1F5F4),
                  labelStyle: TextStyle(color: selected ? Colors.white : const Color(0xFF1F2937), fontWeight: FontWeight.w800),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999), side: BorderSide(color: selected ? const Color(0xFF0F766E) : const Color(0xFFDCE8E4))),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ProductivityMetricCard(
                width: layout.metricWidth,
                title: 'الإنتاج الفعلي',
                value: formatQuantity(summary.totalActual),
                note: 'إجمالي الوحدات أو الدفعات التي تم تنفيذها فعلياً عبر المنتجات المعروضة.',
                accent: const Color(0xFF0F766E),
                icon: Icons.factory_rounded,
              ),
              ProductivityMetricCard(
                width: layout.metricWidth,
                title: 'الإنتاج المستهدف',
                value: formatQuantity(summary.totalTarget),
                note: 'المستهدف التشغيلي الحالي الذي تتم مقارنة الدفعات الفعلية به.',
                accent: const Color(0xFF2563EB),
                icon: Icons.flag_circle_rounded,
              ),
              ProductivityMetricCard(
                width: layout.metricWidth,
                title: 'جودة المنتج',
                value: formatPercent(selectedJourney.qualityRate),
                note: 'معدل الجودة الخاص بالمنتج المحدد بناءً على الفحص والمعالجة.',
                accent: const Color(0xFF16A34A),
                icon: Icons.verified_rounded,
              ),
              ProductivityMetricCard(
                width: layout.metricWidth,
                title: 'عدد المراحل',
                value: '${selectedJourney.steps.length}',
                note: 'عدد خطوات التشغيل الفعلية التي يمر بها المنتج من الخام وحتى الخروج.',
                accent: const Color(0xFFF59E0B),
                icon: Icons.account_tree_rounded,
              ),
            ],
          ),
          const SizedBox(height: 20),
          ProductivityActionPanel(
            selectedJourney: selectedJourney,
            onManageSteps: () => _showManageSteps(selectedJourney),
            onAssignMachine: () => _showAssignMachine(selectedJourney),
            onReviewQuality: () => _showQualityReview(selectedJourney),
            onReschedule: () => _showReschedule(selectedJourney),
            onExport: _exportSummary,
          ),
          const SizedBox(height: 20),
          ProductivityCharts(production: widget.production, machines: mergedMachines),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: layout.primaryWidth,
                child: ProductJourneyPanel(
                  selectedJourney: selectedJourney,
                  selectedStepTitle: selectedStep.title,
                  onSelectStep: _selectStep,
                  onOpenStep: _showStepDetails,
                ),
              ),
              SizedBox(
                width: layout.secondaryWidth,
                child: MachineStatusPanel(
                  selectedJourney: selectedJourney,
                  selectedMachineName: selectedMachine.name,
                  onSelectMachine: _selectMachine,
                  onOpenMachine: _showMachineReport,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _selectJourney(ProductJourney journey) {
    setState(() {
      _selectedJourney = journey;
      _selectedStep = journey.steps.first;
      _selectedMachine = journey.machines.first;
    });
  }

  void _selectStep(ProductStep step) {
    setState(() {
      _selectedStep = step;
      final journey = _selectedJourney;
      if (journey != null) {
        final matchedMachine = journey.machines.where((machine) => machine.name == step.machine).toList();
        if (matchedMachine.isNotEmpty) {
          _selectedMachine = matchedMachine.first;
        }
      }
    });
  }

  void _selectMachine(MachineInfo machine) {
    setState(() {
      _selectedMachine = machine;
    });
  }

  Future<void> _showJourneyFlow(ProductJourney journey) {
    return showProductivityInfoSheet(
      context: context,
      title: 'رحلة المنتج',
      subtitle: 'ملخص تنفيذي لمسار المنتج من الخامة حتى الخروج النهائي.',
      children: [
        ProductivitySheetLine(label: 'اسم المنتج', value: journey.name),
        ProductivitySheetLine(label: 'الخامة', value: journey.rawMaterial),
        ProductivitySheetLine(label: 'المرحلة الحالية', value: journey.currentStage),
        ProductivitySheetLine(label: 'الماكينة الحالية', value: journey.currentMachine),
        ProductivitySheetLine(label: 'الناتج النهائي', value: journey.output),
        ProductivitySheetMessage(message: 'يمكنك استخدام نفس الصفحة لتغيير المرحلة النشطة ومراجعة الجودة أو نقل التشغيل ليوم آخر إذا كان هناك ضغط على الخط.'),
      ],
    );
  }

  Future<void> _showMachineReport(MachineInfo machine) {
    return showProductivityInfoSheet(
      context: context,
      title: 'تقرير الماكينة',
      subtitle: 'تفاصيل تشغيلية وصيانة سريعة للماكينة المحددة.',
      children: [
        ProductivitySheetLine(label: 'اسم الماكينة', value: machine.name),
        ProductivitySheetLine(label: 'الموديل', value: machine.model),
        ProductivitySheetLine(label: 'الحالة', value: machine.status),
        ProductivitySheetLine(label: 'الكفاءة', value: formatPercent(machine.efficiency)),
        ProductivitySheetLine(label: 'درجة الحرارة', value: '${machine.temperature}°'),
        ProductivitySheetLine(label: 'المنتج الجاري', value: machine.currentProduct),
        ProductivitySheetMessage(message: machine.maintenanceNote),
      ],
    );
  }

  Future<void> _showManageSteps(ProductJourney journey) {
    return showProductivityInfoSheet(
      context: context,
      title: 'إدارة خطوات المنتج',
      subtitle: 'مراجعة سريعة للمراحل التي يمكن تحريكها أو تثبيتها أثناء التنفيذ.',
      children: [
        ...journey.steps.map((step) => ProductivitySheetLine(label: step.title, value: '${formatPercent(step.progress)} - ${step.status}')),
        const ProductivitySheetMessage(message: 'تقدر تحدد المرحلة الحالية من البطاقات داخل الصفحة، وده بيساعد الإدارة تتابع المنتج بدقة أعلى أثناء الشيفت.'),
      ],
    );
  }

  Future<void> _showAssignMachine(ProductJourney journey) {
    return showProductivityInfoSheet(
      context: context,
      title: 'تثبيت أو تغيير الماكينة',
      subtitle: 'عرض الماكينات المتاحة للمنتج المحدد مع توزيع الحمل الحالي.',
      children: [
        ...journey.machines.map((machine) => ProductivitySheetLine(label: machine.name, value: '${machine.status} - ${formatPercent(machine.efficiency)}')),
        const ProductivitySheetMessage(message: 'اختيار الماكينة الأنسب يعتمد على الكفاءة الحالية، الطابور المنتظر، وحالة الصيانة قبل اعتماد النقل.'),
      ],
    );
  }

  Future<void> _showQualityReview(ProductJourney journey) {
    final finalStep = journey.steps.last;
    return showProductivityInfoSheet(
      context: context,
      title: 'مراجعة الجودة',
      subtitle: 'قراءة سريعة لنقاط الاعتماد والفحص للمنتج المحدد.',
      children: [
        ProductivitySheetLine(label: 'المنتج', value: journey.name),
        ProductivitySheetLine(label: 'معدل الجودة', value: formatPercent(journey.qualityRate)),
        ProductivitySheetLine(label: 'بوابة الاعتماد الأخيرة', value: finalStep.qualityGate),
        ProductivitySheetLine(label: 'المشرف', value: journey.supervisor),
        const ProductivitySheetMessage(message: 'لو الجودة أقل من المطلوب، يفضّل إعادة الفحص بعد خطوة المعالجة الأساسية قبل الانتقال للتغليف النهائي.'),
      ],
    );
  }

  Future<void> _showReschedule(ProductJourney journey) {
    return showProductivityInfoSheet(
      context: context,
      title: 'ترحيل أو إعادة جدولة',
      subtitle: 'اقتراح تشغيل مرن في حالة ضغط الماكينات أو الحاجة لتأجيل المرحلة التالية.',
      children: [
        ProductivitySheetLine(label: 'المنتج', value: journey.name),
        ProductivitySheetLine(label: 'المرحلة الحالية', value: journey.currentStage),
        const ProductivitySheetLine(label: 'الخطة المقترحة', value: 'نقل المعالجة الأساسية لبداية وردية الغد'),
        const ProductivitySheetLine(label: 'سبب الاقتراح', value: 'تخفيف الضغط على الماكينات الرئيسية ورفع جودة التنفيذ'),
        const ProductivitySheetMessage(message: 'إعادة الجدولة هنا لا توقف المتابعة، لكنها تساعدك توازن بين الحمل التشغيلي والجودة وسرعة التسليم.'),
      ],
    );
  }

  Future<void> _showStepDetails(ProductStep step) {
    return showProductivityInfoSheet(
      context: context,
      title: 'تفاصيل المرحلة',
      subtitle: 'بيانات تنفيذية عن المرحلة المختارة داخل رحلة المنتج.',
      children: [
        ProductivitySheetLine(label: 'اسم المرحلة', value: step.title),
        ProductivitySheetLine(label: 'الماكينة', value: step.machine),
        ProductivitySheetLine(label: 'العامل', value: step.operator),
        ProductivitySheetLine(label: 'نسبة التقدم', value: formatPercent(step.progress)),
        ProductivitySheetLine(label: 'بوابة الجودة', value: step.qualityGate),
        ProductivitySheetMessage(message: step.description),
      ],
    );
  }

  void _exportSummary() {
    final journey = _selectedJourney;
    if (journey == null) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم تجهيز ملخص إداري سريع للمنتج ${journey.name} بنجاح.')),
    );
  }
}
