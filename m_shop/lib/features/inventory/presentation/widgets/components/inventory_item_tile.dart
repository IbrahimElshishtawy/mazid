import 'package:flutter/material.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/inventory/presentation/widgets/components/inventory_models.dart';

class InventoryItemTile extends StatelessWidget {
  const InventoryItemTile({
    super.key,
    required this.item,
    required this.selected,
    required this.onSelect,
    required this.onViewDetails,
  });

  final InventoryItem item;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    final snapshot = InventorySnapshot.fromItem(item);
    final accent = snapshot.isLowStock ? const Color(0xFFDC2626) : const Color(0xFF0F766E);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: selected
              ? const [Color(0xFFF3FBF9), Color(0xFFFFFFFF)]
              : const [Color(0xFFF8FBFB), Color(0xFFFFFFFF)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: selected ? accent : const Color(0xFFE2ECE8), width: selected ? 1.5 : 1),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: selected ? 0.08 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(snapshot.isLowStock ? Icons.inventory_2_outlined : Icons.verified_outlined, color: accent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 6),
                    Text(snapshot.statusMessage, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  snapshot.isLowStock ? 'منخفض' : 'آمن',
                  style: TextStyle(color: accent, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ItemChip(label: 'الكمية', value: '${formatInventoryNumber(item.quantity)} ${item.unit}', color: const Color(0xFF0F766E)),
              ItemChip(label: 'الحد الأدنى', value: '${formatInventoryNumber(item.minimum)} ${item.unit}', color: const Color(0xFF2563EB)),
              ItemChip(label: 'التغطية', value: '${(snapshot.coverage * 100).round()}%', color: accent),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onSelect,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: Icon(selected ? Icons.check_circle_rounded : Icons.touch_app_rounded),
                  label: Text(selected ? 'مفعل الآن' : 'اختيار الصنف'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onViewDetails,
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
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

class ItemChip extends StatelessWidget {
  const ItemChip({
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2ECE8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w700)),
          Text(value, style: const TextStyle(color: Color(0xFF667B75))),
        ],
      ),
    );
  }
}
