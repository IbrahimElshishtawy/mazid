import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/inventory/presentation/widgets/components/inventory_actions.dart';
import 'package:m_shop/features/inventory/presentation/widgets/components/inventory_chart.dart';
import 'package:m_shop/features/inventory/presentation/widgets/components/inventory_hero.dart';
import 'package:m_shop/features/inventory/presentation/widgets/components/inventory_insights.dart';
import 'package:m_shop/features/inventory/presentation/widgets/components/inventory_item_tile.dart';
import 'package:m_shop/features/inventory/presentation/widgets/components/inventory_metrics.dart';
import 'package:m_shop/features/inventory/presentation/widgets/components/inventory_models.dart';
import 'package:m_shop/features/inventory/presentation/widgets/components/inventory_sheet.dart';

class InventorySection extends StatefulWidget {
  const InventorySection({super.key, required this.inventory});

  final List<InventoryItem> inventory;

  @override
  State<InventorySection> createState() => _InventorySectionState();
}

class _InventorySectionState extends State<InventorySection> {
  InventoryItem? _selectedItem;

  @override
  void initState() {
    super.initState();
    if (widget.inventory.isNotEmpty) {
      _selectedItem = widget.inventory.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.inventory;
    if (items.isEmpty) {
      return const SectionCard(
        title: 'المخزون وإدارة الأصناف',
        subtitle: 'لا توجد بيانات مخزون متاحة حالياً لعرضها في هذا القسم.',
        child: SizedBox(
          height: 120,
          child: Center(
            child: Text(
              'أضف أصنافاً إلى المخزون أولاً حتى تظهر التحليلات والرسوم البيانية.',
              style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF667B75)),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final selectedItem = _selectedItem ?? items.first;
    final summary = InventorySummary.fromItems(items);
    final selectedSnapshot = InventorySnapshot.fromItem(selectedItem);
    final topItem = highestStockItem(items);
    final riskItem = highestRiskItem(items);
    final layout = InventoryLayout.fromWidth(MediaQuery.sizeOf(context).width);

    return SectionCard(
      title: 'المخزون وإدارة الأصناف',
      subtitle: 'لوحة مخزون احترافية تعرض التغطية والمخاطر وتحوّل كل إجراء إلى خطوة تشغيلية واضحة.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InventoryHero(
            summary: summary,
            selectedItem: selectedItem,
            items: items,
            onSelectItem: _selectItem,
            onOpenDetails: () => _showItemDetails(selectedItem),
            onExport: () => _exportSummary(selectedItem),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              InventoryMetricCard(
                width: layout.metricCardWidth,
                title: 'عدد الأصناف',
                value: formatInventoryNumber(summary.totalItems),
                note: 'إجمالي الأصناف التي تتم متابعتها داخل المخزون',
                accent: const Color(0xFF0F766E),
                icon: Icons.inventory_2_rounded,
              ),
              InventoryMetricCard(
                width: layout.metricCardWidth,
                title: 'إجمالي الوحدات',
                value: formatInventoryNumber(summary.totalQuantity),
                note: 'إجمالي الكميات المتاحة في جميع الأصناف',
                accent: const Color(0xFF16A34A),
                icon: Icons.warehouse_rounded,
              ),
              InventoryMetricCard(
                width: layout.metricCardWidth,
                title: 'أصناف منخفضة',
                value: formatInventoryNumber(summary.lowStockCount),
                note: 'أصناف وصلت إلى الحد الأدنى أو أقل',
                accent: const Color(0xFFDC2626),
                icon: Icons.warning_amber_rounded,
              ),
              InventoryMetricCard(
                width: layout.metricCardWidth,
                title: 'عجز مطلوب',
                value: formatInventoryNumber(summary.restockUnits),
                note: 'عدد الوحدات المطلوب توفيرها للوصول إلى الحد الأدنى',
                accent: const Color(0xFF2563EB),
                icon: Icons.local_shipping_outlined,
              ),
            ],
          ),
          const SizedBox(height: 20),
          InventoryActionPanel(
            selectedItem: selectedItem,
            topItem: topItem,
            riskItem: riskItem,
            onStockAnalysis: () => _openStockAnalysis(selectedItem),
            onCompareItems: () => _compareItems(selectedItem, topItem),
            onRestockPlan: () => _showRestockPlan(selectedItem),
            onExport: () => _exportSummary(selectedItem),
          ),
          const SizedBox(height: 20),
          InventoryChartCard(items: items, summary: summary),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: layout.primaryPanelWidth,
                child: InventoryInsightPanel(
                  selectedItem: selectedItem,
                  topItem: topItem,
                  riskItem: riskItem,
                  summary: summary,
                ),
              ),
              SizedBox(
                width: layout.secondaryPanelWidth,
                child: InventoryAllocationPanel(snapshot: selectedSnapshot),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SectionCard(
            title: 'عناصر المخزون',
            subtitle: 'كل بطاقة تعرض حالة الصنف الحالية ومعها أزرار لاختيار الصنف أو فتح تفاصيله.',
            child: Column(
              children: items
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InventoryItemTile(
                        item: item,
                        selected: item.name == selectedItem.name,
                        onSelect: () => _selectItem(item),
                        onViewDetails: () => _showItemDetails(item),
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

  void _selectItem(InventoryItem item) {
    setState(() {
      _selectedItem = item;
    });
  }

  Future<void> _openStockAnalysis(InventoryItem item) {
    final snapshot = InventorySnapshot.fromItem(item);
    return showInventoryInfoSheet(
      context: context,
      title: 'تحليل التغطية',
      subtitle: 'قراءة سريعة للصنف المختار مع أهم المؤشرات التشغيلية.',
      children: [
        InventorySheetLine(label: 'الصنف', value: item.name),
        InventorySheetLine(label: 'الكمية الحالية', value: '${formatInventoryNumber(item.quantity)} ${item.unit}'),
        InventorySheetLine(label: 'نسبة التغطية', value: '${(snapshot.coverage * 100).round()}%'),
        InventorySheetMessage(message: snapshot.statusMessage),
      ],
    );
  }

  Future<void> _compareItems(InventoryItem currentItem, InventoryItem targetItem) {
    final currentCoverage = currentItem.minimum == 0 ? 1.0 : currentItem.quantity / currentItem.minimum;
    final targetCoverage = targetItem.minimum == 0 ? 1.0 : targetItem.quantity / targetItem.minimum;

    return showInventoryInfoSheet(
      context: context,
      title: 'مقارنة الأصناف',
      subtitle: 'مقارنة عملية تساعد على تحديد الصنف الذي يحتاج إلى تدخل أسرع.',
      children: [
        InventorySheetLine(label: 'الصنف الحالي', value: currentItem.name),
        InventorySheetLine(label: 'الصنف المقارن', value: targetItem.name),
        InventorySheetLine(label: 'تغطية الحالي', value: '${(currentCoverage * 100).round()}%'),
        InventorySheetLine(label: 'تغطية المقارن', value: '${(targetCoverage * 100).round()}%'),
        InventorySheetMessage(
          message: currentCoverage >= targetCoverage
              ? 'الصنف الحالي في وضع أفضل أو مماثل للصنف المقارن من ناحية التغطية.'
              : 'الصنف الحالي يحتاج إلى دعم أسرع حتى يقترب من مستوى تغطية ${targetItem.name}.',
        ),
      ],
    );
  }

  Future<void> _showRestockPlan(InventoryItem item) {
    final snapshot = InventorySnapshot.fromItem(item);
    final urgent = snapshot.shortage;
    final buffer = (item.minimum * 0.15).round();
    final totalOrder = urgent + buffer;

    return showInventoryInfoSheet(
      context: context,
      title: 'خطة إعادة التوريد',
      subtitle: 'اقتراح سريع لتغطية العجز وإنشاء هامش أمان للصنف المختار.',
      children: [
        InventorySheetLine(label: 'العجز الحالي', value: '${formatInventoryNumber(urgent)} ${item.unit}'),
        InventorySheetLine(label: 'مخزون أمان مقترح', value: '${formatInventoryNumber(buffer)} ${item.unit}'),
        InventorySheetLine(label: 'الكمية المقترح طلبها', value: '${formatInventoryNumber(totalOrder)} ${item.unit}'),
        const InventorySheetMessage(
          message: 'يمكن اعتماد هذه الخطة كبداية قبل مراجعة المورد ووقت التسليم ومعدل الاستهلاك الفعلي.',
        ),
      ],
    );
  }

  Future<void> _showItemDetails(InventoryItem item) {
    final snapshot = InventorySnapshot.fromItem(item);
    return showInventoryInfoSheet(
      context: context,
      title: 'تفاصيل ${item.name}',
      subtitle: 'ملف مبسط للصنف مع حالته الحالية وأهم الأرقام.',
      children: [
        InventorySheetLine(label: 'الكمية الحالية', value: '${formatInventoryNumber(item.quantity)} ${item.unit}'),
        InventorySheetLine(label: 'الحد الأدنى', value: '${formatInventoryNumber(item.minimum)} ${item.unit}'),
        InventorySheetLine(label: 'العجز', value: '${formatInventoryNumber(snapshot.shortage)} ${item.unit}'),
        InventorySheetLine(label: 'نسبة التغطية', value: '${(snapshot.coverage * 100).round()}%'),
        InventorySheetMessage(message: snapshot.statusMessage),
      ],
    );
  }

  void _exportSummary(InventoryItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تجهيز ملخص ${item.name} للمشاركة والمراجعة.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
