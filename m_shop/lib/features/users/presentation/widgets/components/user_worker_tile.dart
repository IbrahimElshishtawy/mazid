import 'package:flutter/material.dart';
import 'package:m_shop/features/users/presentation/widgets/components/users_models.dart';

class UserWorkerTile extends StatelessWidget {
  const UserWorkerTile({
    super.key,
    required this.profile,
    required this.selected,
    required this.onSelect,
    required this.onView,
    required this.onPromote,
    required this.onDelete,
  });

  final WorkerProfile profile;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback onView;
  final VoidCallback onPromote;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selected ? profile.accent.withValues(alpha: 0.08) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: selected ? profile.accent.withValues(alpha: 0.26) : const Color(0xFFE0EBE7)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(backgroundColor: profile.accent.withValues(alpha: 0.14), foregroundColor: profile.accent, child: Text(profile.user.name.isNotEmpty ? profile.user.name[0] : '?', style: const TextStyle(fontWeight: FontWeight.w900))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(profile.user.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)), const SizedBox(height: 4), Text('${profile.user.role} • ${profile.workArea}', style: const TextStyle(color: Color(0xFF667B75), height: 1.4))])),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: profile.accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)), child: Text(profile.user.status, style: TextStyle(color: profile.accent, fontWeight: FontWeight.w800, fontSize: 12))),
        ]),
        const SizedBox(height: 14),
        Wrap(spacing: 16, runSpacing: 10, children: [
          _Mini(label: 'الصلاحية', value: profile.permissionLevel),
          _Mini(label: 'الأجر', value: formatMoney(profile.salary)),
          _Mini(label: 'الأداء', value: formatPercent(profile.performance)),
          _Mini(label: 'الوردية', value: profile.shift),
        ]),
        const SizedBox(height: 14),
        Row(children: [OutlinedButton(onPressed: onSelect, child: const Text('تحديد')), const SizedBox(width: 8), FilledButton(onPressed: onView, child: const Text('عرض')), const SizedBox(width: 8), OutlinedButton.icon(onPressed: onPromote, icon: const Icon(Icons.trending_up_rounded, size: 18), label: const Text('تحسين')), const Spacer(), IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline_rounded), color: const Color(0xFFDC2626))]),
      ]),
    );
  }
}

class _Mini extends StatelessWidget { const _Mini({required this.label, required this.value}); final String label; final String value; @override Widget build(BuildContext context) { return SizedBox(width: 150, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Color(0xFF667B75), fontSize: 12, fontWeight: FontWeight.w700)), const SizedBox(height: 4), Text(value, style: const TextStyle(fontWeight: FontWeight.w800, height: 1.35))])); } }
