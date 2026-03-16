import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/inventory/presentation/widgets/components/inventory_models.dart';

class InventoryInsightPanel extends StatelessWidget {
  const InventoryInsightPanel({
    super.key,
    required this.selectedItem,
    required this.topItem,
    required this.riskItem,
    required this.summary,
  });

  final InventoryItem selectedItem;
  final InventoryItem topItem;
  final InventoryItem riskItem;
  final InventorySummary summary;

  @override
  Widget build(BuildContext context) {
    final insights = [
      InventoryInsightData(
        title: 'أعلى كمية متاحة',
        description: '${topItem.name} يملك ${formatInventoryNumber(topItem.quantity)} ${topItem.unit} وهو الأعلى بين الأصناف الحالية.',
        accent: const Color(0xFF16A34A),
        icon: Icons.workspace_premium_rounded,
      ),
      InventoryInsightData(
        title: 'الصنف المختار الآن',
        description: '${selectedItem.name} يغطي ${(InventorySnapshot.fromItem(selectedItem).coverage * 100).round()}% من الحد الأدنى المطلوب.',
        accent: const Color(0xFF2563EB),
        icon: Icons.radio_button_checked_rounded,
      ),
      InventoryInsightData(
        title: 'أولوية المتابعة',
        description: '${riskItem.name} هو الأكثر احتياجاً للمراجعة لأن مستوى تغطيته هو الأقل في القائمة.',
        accent: const Color(0xFFF59E0B),
        icon: Icons.warning_amber_rounded,
      ),
    ];

    return SectionCard(
      title: 'قراءات ذكية',
      subtitle: 'ملخص تنفيذي يساعدك على معرفة أولويات المخزون بسرعة.',
      child: Column(
        children: insights
            .map(
              (insight) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InventoryInsightTile(data: insight),
              ),
            )
            .toList(),
      ),
    );
  }
}

class InventoryAllocationPanel extends StatelessWidget {
  const InventoryAllocationPanel({super.key, required this.snapshot});

  final InventorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final current = snapshot.item.quantity.toDouble();
    final minimum = snapshot.item.minimum.toDouble();
    final shortage = snapshot.shortage.toDouble();
    final items = [
      InventoryAllocationData(label: 'المتاح', amount: current, color: const Color(0xFF0F766E)),
      InventoryAllocationData(label: 'الحد الأدنى', amount: minimum, color: const Color(0xFF2563EB)),
      InventoryAllocationData(label: 'العجز', amount: shortage, color: const Color(0xFFDC2626)),
    ];

    return SectionCard(
      title: 'وضع الصنف المختار',
      subtitle: 'تفصيل مبسط يوضح الكمية الحالية مقابل المطلوب لهذا الصنف.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(snapshot.statusMessage, style: const TextStyle(color: Color(0xFF30413D), height: 1.5)),
          const SizedBox(height: 18),
          ...items.map((item) => AllocationBar(item: item, total: minimum == 0 ? 1 : minimum)),
        ],
      ),
    );
  }
}

class InventoryInsightTile extends StatelessWidget {
  const InventoryInsightTile({super.key, required this.data});

  final InventoryInsightData data;

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

  final InventoryAllocationData item;
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
              Text(formatInventoryNumber(item.amount), style: const TextStyle(fontWeight: FontWeight.w900)),
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
