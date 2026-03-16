import 'package:flutter/material.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/inventory/presentation/widgets/components/inventory_models.dart';

class InventoryHero extends StatelessWidget {
  const InventoryHero({
    super.key,
    required this.summary,
    required this.selectedItem,
    required this.items,
    required this.onSelectItem,
    required this.onOpenDetails,
    required this.onExport,
  });

  final InventorySummary summary;
  final InventoryItem selectedItem;
  final List<InventoryItem> items;
  final ValueChanged<InventoryItem> onSelectItem;
  final VoidCallback onOpenDetails;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF111827), Color(0xFF164E63), Color(0xFF0F766E)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F766E).withValues(alpha: 0.18),
            blurRadius: 36,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -10,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -28,
            left: 30,
            child: Container(
              width: 220,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const _HeroBadge(label: 'مركز التحكم بالمخزون'),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: items
                          .map(
                            (item) => ChoiceChip(
                              label: Text(item.name),
                              selected: item.name == selectedItem.name,
                              onSelected: (_) => onSelectItem(item),
                              selectedColor: const Color(0xFFFFF7ED),
                              backgroundColor: Colors.white.withValues(alpha: 0.10),
                              labelStyle: TextStyle(
                                color: item.name == selectedItem.name ? const Color(0xFF9A3412) : Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                              side: BorderSide(color: Colors.white.withValues(alpha: 0.14)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 22,
                runSpacing: 22,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: const Color(0xFFF59E0B),
                              ),
                              child: const Icon(Icons.precision_manufacturing_rounded, color: Colors.white),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                'متابعة الأصناف بحالة ${summary.healthLabel}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  height: 1.15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'الصنف النشط الآن هو ${selectedItem.name}، وتغطيته الحالية تمنح الفريق رؤية أسرع لاتخاذ قرار التوريد أو التحويل الداخلي.',
                          style: const TextStyle(color: Color(0xE5FFFFFF), height: 1.6),
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            HeroStat(label: 'إجمالي الوحدات', value: formatInventoryNumber(summary.totalQuantity)),
                            HeroStat(label: 'أصناف منخفضة', value: formatInventoryNumber(summary.lowStockCount)),
                            HeroStat(label: 'عجز مطلوب', value: formatInventoryNumber(summary.restockUnits)),
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
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'وضع الصنف المحدد',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${formatInventoryNumber(selectedItem.quantity)} ${selectedItem.unit}',
                                style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'الحد الأدنى ${formatInventoryNumber(selectedItem.minimum)} ${selectedItem.unit}',
                                style: const TextStyle(color: Color(0xD6FFFFFF)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: onOpenDetails,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFF59E0B),
                            foregroundColor: const Color(0xFF111827),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          ),
                          icon: const Icon(Icons.visibility_rounded),
                          label: const Text('فتح ملف الصنف المختار'),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: onExport,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.24)),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          ),
                          icon: const Icon(Icons.file_download_outlined),
                          label: const Text('تجهيز ملخص للمشاركة'),
                        ),
                      ],
                    ),
                  ),
                ],
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
      width: 152,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xD3FFFFFF), fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 19)),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
    );
  }
}
