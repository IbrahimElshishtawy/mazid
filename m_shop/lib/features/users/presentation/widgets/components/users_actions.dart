import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';

class UsersActionPanel extends StatelessWidget {
  const UsersActionPanel({
    super.key,
    required this.onAddUser,
    required this.onPromoteSalary,
    required this.onChangePermissions,
    required this.onChangeArea,
    required this.onExport,
  });

  final VoidCallback onAddUser;
  final VoidCallback onPromoteSalary;
  final VoidCallback onChangePermissions;
  final VoidCallback onChangeArea;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'أوامر الإدارة السريعة',
      subtitle: 'أزرار تنفيذية تخلّي إدارة العمال والمستخدمين أقرب لنظام تشغيل حقيقي.',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _ActionCard(label: 'إضافة عامل جديد', icon: Icons.person_add_alt_1_rounded, accent: const Color(0xFF0F766E), onTap: onAddUser),
          _ActionCard(label: 'تحسين الأجور', icon: Icons.savings_rounded, accent: const Color(0xFF16A34A), onTap: onPromoteSalary),
          _ActionCard(label: 'تحديث الصلاحيات', icon: Icons.admin_panel_settings_rounded, accent: const Color(0xFF2563EB), onTap: onChangePermissions),
          _ActionCard(label: 'نقل مكان العمل', icon: Icons.swap_horiz_rounded, accent: const Color(0xFFF59E0B), onTap: onChangeArea),
          _ActionCard(label: 'تصدير كشف المستخدمين', icon: Icons.file_download_done_rounded, accent: const Color(0xFF7C3AED), onTap: onExport),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.label, required this.icon, required this.accent, required this.onTap});
  final String label; final IconData icon; final Color accent; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 206,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: accent.withValues(alpha: 0.14))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: accent)),
          const SizedBox(height: 14),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w800, height: 1.35)),
          const SizedBox(height: 8),
          Text('مخصص لإدارة الفريق داخل المصنع.', style: const TextStyle(color: Color(0xFF667B75), height: 1.4)),
        ]),
      ),
    );
  }
}

