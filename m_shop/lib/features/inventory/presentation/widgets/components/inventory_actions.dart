import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class InventoryActionPanel extends StatelessWidget {
  const InventoryActionPanel({
    super.key,
    required this.selectedItem,
    required this.topItem,
    required this.riskItem,
    required this.onStockAnalysis,
    required this.onCompareItems,
    required this.onRestockPlan,
    required this.onExport,
  });

  final InventoryItem selectedItem;
  final InventoryItem topItem;
  final InventoryItem riskItem;
  final VoidCallback onStockAnalysis;
  final VoidCallback onCompareItems;
  final VoidCallback onRestockPlan;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'محطات العمل السريعة',
      subtitle: 'اختصارات عملية للقراءة والتحليل والتوريد دون الخروج من الصفحة.',
      child: Wrap(
        spacing: 14,
        runSpacing: 14,
        children: [
          InventoryActionButton(
            label: 'تحليل التغطية',
            note: 'يفتح قراءة مباشرة للصنف ${selectedItem.name}',
            icon: Icons.analytics_outlined,
            accent: const Color(0xFF2563EB),
            onPressed: onStockAnalysis,
          ),
          InventoryActionButton(
            label: 'مقارنة الأصناف',
            note: 'يقارن الصنف الحالي مع ${topItem.name}',
            icon: Icons.compare_arrows_rounded,
            accent: const Color(0xFF16A34A),
            onPressed: onCompareItems,
          ),
          InventoryActionButton(
            label: 'خطة إعادة التوريد',
            note: 'اقتراح سريع لتغطية العجز الحالي',
            icon: Icons.local_shipping_outlined,
            accent: const Color(0xFFF59E0B),
            onPressed: onRestockPlan,
          ),
          InventoryActionButton(
            label: 'تصدير ملخص',
            note: 'تجهيز إشعار بالموقف الحالي للمخزون',
            icon: Icons.ios_share_rounded,
            accent: const Color(0xFF0F766E),
            onPressed: onExport,
          ),
          InventoryActionHint(
            title: 'نقطة خطر حالية',
            description: 'الصنف ${riskItem.name} هو الأقرب لنقص تشغيلي إذا لم يتم تعويضه سريعاً.',
          ),
        ],
      ),
    );
  }
}

class InventoryActionButton extends StatelessWidget {
  const InventoryActionButton({
    super.key,
    required this.label,
    required this.note,
    required this.icon,
    required this.accent,
    required this.onPressed,
  });

  final String label;
  final String note;
  final IconData icon;
  final Color accent;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 228,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: accent.withValues(alpha: 0.18)),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.06),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, color: accent),
                    ),
                    const Spacer(),
                    Icon(Icons.arrow_forward_rounded, color: accent, size: 18),
                  ],
                ),
                const SizedBox(height: 14),
                Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                const SizedBox(height: 6),
                Text(note, style: const TextStyle(color: Color(0xFF667B75), height: 1.45)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InventoryActionHint extends StatelessWidget {
  const InventoryActionHint({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 132, maxWidth: 330),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFBEB), Color(0xFFFFF1F2)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.crisis_alert_rounded, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF92400E))),
          const SizedBox(height: 6),
          Text(description, style: const TextStyle(color: Color(0xFF7C5A10), height: 1.45)),
        ],
      ),
    );
  }
}
