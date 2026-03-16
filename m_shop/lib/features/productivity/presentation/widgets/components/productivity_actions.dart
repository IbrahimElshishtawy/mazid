import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/productivity/presentation/widgets/components/productivity_models.dart';

class ProductivityActionPanel extends StatelessWidget {
  const ProductivityActionPanel({
    super.key,
    required this.selectedJourney,
    required this.onManageSteps,
    required this.onAssignMachine,
    required this.onReviewQuality,
    required this.onReschedule,
    required this.onExport,
  });

  final ProductJourney selectedJourney;
  final VoidCallback onManageSteps;
  final VoidCallback onAssignMachine;
  final VoidCallback onReviewQuality;
  final VoidCallback onReschedule;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'أوامر تشغيل سريعة',
      subtitle: 'كل زر يفتح خطوة تنفيذية واضحة لإدارة مراحل المنتج والمكن والمراجعة والجودة.',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _ActionButton(label: 'إدارة خطوات المنتج', productName: selectedJourney.name, icon: Icons.alt_route_rounded, accent: const Color(0xFF0F766E), onTap: onManageSteps),
          _ActionButton(label: 'تغيير أو تثبيت الماكينة', productName: selectedJourney.name, icon: Icons.precision_manufacturing_rounded, accent: const Color(0xFF2563EB), onTap: onAssignMachine),
          _ActionButton(label: 'فتح مراجعة الجودة', productName: selectedJourney.name, icon: Icons.fact_check_rounded, accent: const Color(0xFF16A34A), onTap: onReviewQuality),
          _ActionButton(label: 'ترحيل لليوم التالي', productName: selectedJourney.name, icon: Icons.event_repeat_rounded, accent: const Color(0xFFF59E0B), onTap: onReschedule),
          _ActionButton(label: 'تجهيز ملخص للإدارة', productName: selectedJourney.name, icon: Icons.file_download_done_rounded, accent: const Color(0xFF7C3AED), onTap: onExport),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.productName, required this.icon, required this.accent, required this.onTap});

  final String label;
  final String productName;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 204,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accent.withValues(alpha: 0.14)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: accent),
            ),
            const SizedBox(height: 14),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w800, height: 1.35)),
            const SizedBox(height: 8),
            Text('للمنتج: $productName', style: const TextStyle(color: Color(0xFF667B75), height: 1.4)),
          ],
        ),
      ),
    );
  }
}
