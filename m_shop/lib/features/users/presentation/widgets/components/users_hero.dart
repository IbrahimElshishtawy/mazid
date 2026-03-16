import 'package:flutter/material.dart';
import 'package:m_shop/features/users/presentation/widgets/components/users_models.dart';

class UsersHero extends StatelessWidget {
  const UsersHero({super.key, required this.summary, required this.selectedProfile, required this.onOpenControl, required this.onOpenPermissions});

  final UsersSummary summary;
  final WorkerProfile selectedProfile;
  final VoidCallback onOpenControl;
  final VoidCallback onOpenPermissions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF101827), Color(0xFF0F766E), Color(0xFF22C55E)]),
        boxShadow: [BoxShadow(color: const Color(0xFF0F766E).withValues(alpha: 0.18), blurRadius: 34, offset: const Offset(0, 20))],
      ),
      child: Wrap(
        spacing: 24,
        runSpacing: 24,
        alignment: WrapAlignment.spaceBetween,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const _HeroBadge(label: 'نظام سيطرة وإدارة العمال'),
              const SizedBox(height: 16),
              Text(summary.controlState, style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900, height: 1.1)),
              const SizedBox(height: 12),
              const Text('من الشاشة دي تقدر تتحكم في العمال والمستخدمين، أماكن العمل، الصلاحيات، الأجور، الإضافة والحذف، وتبني نظام تشغيل أقرب لسيستم حقيقي للمصنع.', style: TextStyle(color: Color(0xEAFFFFFF), height: 1.6)),
              const SizedBox(height: 18),
              Wrap(spacing: 12, runSpacing: 12, children: [
                _HeroStat(label: 'المستخدمين', value: '${summary.totalUsers}'),
                _HeroStat(label: 'الحضور النشط', value: '${summary.activeUsers}'),
                _HeroStat(label: 'متوسط الأداء', value: formatPercent(summary.averagePerformance)),
                _HeroStat(label: 'المعتمدون', value: '${summary.approvers}'),
              ]),
            ]),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withValues(alpha: 0.14))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(selectedProfile.user.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24)),
                const SizedBox(height: 8),
                Text('المنطقة: ${selectedProfile.workArea}', style: const TextStyle(color: Color(0xDEFFFFFF))),
                const SizedBox(height: 12),
                _InfoLine(label: 'الدور', value: selectedProfile.user.role),
                _InfoLine(label: 'الصلاحية', value: selectedProfile.permissionLevel),
                _InfoLine(label: 'الوردية', value: selectedProfile.shift),
                _InfoLine(label: 'الأجر', value: formatMoney(selectedProfile.salary)),
                const SizedBox(height: 16),
                FilledButton.icon(onPressed: onOpenControl, style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFBBF24), foregroundColor: const Color(0xFF101827), minimumSize: const Size.fromHeight(50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))), icon: const Icon(Icons.manage_accounts_rounded), label: const Text('فتح لوحة التحكم')),
                const SizedBox(height: 10),
                OutlinedButton.icon(onPressed: onOpenPermissions, style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: BorderSide(color: Colors.white.withValues(alpha: 0.22)), minimumSize: const Size.fromHeight(50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))), icon: const Icon(Icons.admin_panel_settings_rounded), label: const Text('تفاصيل الصلاحيات')),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget { const _HeroBadge({required this.label}); final String label; @override Widget build(BuildContext context) { return Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(999), border: Border.all(color: Colors.white.withValues(alpha: 0.14))), child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800))); } }
class _HeroStat extends StatelessWidget { const _HeroStat({required this.label, required this.value}); final String label; final String value; @override Widget build(BuildContext context) { return Container(width: 150, padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withValues(alpha: 0.12))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Color(0xD8FFFFFF), fontWeight: FontWeight.w700)), const SizedBox(height: 8), Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18))])); } }
class _InfoLine extends StatelessWidget { const _InfoLine({required this.label, required this.value}); final String label; final String value; @override Widget build(BuildContext context) { return Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [Expanded(child: Text(label, style: const TextStyle(color: Color(0xD8FFFFFF), fontWeight: FontWeight.w700))), Flexible(child: Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900), textAlign: TextAlign.end))])); } }
