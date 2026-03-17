import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/users/presentation/widgets/components/users_models.dart';

class UsersInsightsPanel extends StatelessWidget {
  const UsersInsightsPanel({super.key, required this.selectedProfile});

  final WorkerProfile selectedProfile;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'ملف العامل أو المستخدم',
      subtitle: 'تفاصيل تشغيلية تساعدك تسيطر على الدور والمكان والأجر والصلاحية للمستخدم المحدد.',
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: selectedProfile.accent.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(22), border: Border.all(color: selectedProfile.accent.withValues(alpha: 0.16))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(selectedProfile.user.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22)),
            const SizedBox(height: 8),
            Text(selectedProfile.user.email, style: const TextStyle(color: Color(0xFF667B75))),
            const SizedBox(height: 14),
            _Line(label: 'الدور', value: selectedProfile.user.role),
            _Line(label: 'مكان العمل', value: selectedProfile.workArea),
            _Line(label: 'الصلاحية', value: selectedProfile.permissionLevel),
            _Line(label: 'الوردية', value: selectedProfile.shift),
            _Line(label: 'الأجر', value: formatMoney(selectedProfile.salary)),
            _Line(label: 'المهام المنجزة', value: '${selectedProfile.tasksHandled}'),
            _Line(label: 'مستوى الأداء', value: formatPercent(selectedProfile.performance)),
          ]),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.48), borderRadius: BorderRadius.circular(20)),
          child: Text(selectedProfile.canApprove ? 'المستخدم ده يقدر يعتمد أوامر أو يراجع تشغيل حسب صلاحياته الحالية.' : 'المستخدم ده يحتاج ترقية صلاحية لو مطلوب منه اعتماد أو مراجعة أقسام حساسة.', style: const TextStyle(color: Color(0xFF30413D), height: 1.5)),
        ),
      ]),
    );
  }
}

class _Line extends StatelessWidget { const _Line({required this.label, required this.value}); final String label; final String value; @override Widget build(BuildContext context) { return Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [Expanded(child: Text(label, style: const TextStyle(color: Color(0xFF667B75), fontWeight: FontWeight.w700))), Flexible(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w900), textAlign: TextAlign.end))])); } }

