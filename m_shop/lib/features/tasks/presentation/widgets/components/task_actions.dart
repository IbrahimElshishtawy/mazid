import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class TaskActionPanel extends StatelessWidget {
  const TaskActionPanel({
    super.key,
    required this.selectedTask,
    required this.bestTask,
    required this.delayedTask,
    required this.onAssignTask,
    required this.onMonitorTask,
    required this.onApplyDeduction,
    required this.onApplyBonus,
    required this.onRescheduleTask,
  });

  final TaskModel selectedTask;
  final TaskModel bestTask;
  final TaskModel delayedTask;
  final VoidCallback onAssignTask;
  final VoidCallback onMonitorTask;
  final VoidCallback onApplyDeduction;
  final VoidCallback onApplyBonus;
  final VoidCallback onRescheduleTask;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'محطات العمل السريعة',
      subtitle: 'من هنا تقدر توكل العمال بالمهام، تراقب التنفيذ، وتطبق حوافز أو خصومات أو إعادة جدولة.',
      child: Wrap(
        spacing: 14,
        runSpacing: 14,
        children: [
          TaskActionButton(
            label: 'إسناد المهمة',
            note: 'توزيع أو إعادة إسناد المهمة الحالية على عامل آخر',
            icon: Icons.assignment_ind_outlined,
            accent: const Color(0xFF2563EB),
            onPressed: onAssignTask,
          ),
          TaskActionButton(
            label: 'مراقبة العامل',
            note: 'فتح تقرير متابعة للعامل ${selectedTask.assignedTo}',
            icon: Icons.visibility_outlined,
            accent: const Color(0xFF0F766E),
            onPressed: onMonitorTask,
          ),
          TaskActionButton(
            label: 'تطبيق خصم',
            note: 'خصم عند التأخير أو ضعف الإنجاز في التنفيذ',
            icon: Icons.money_off_csred_outlined,
            accent: const Color(0xFFDC2626),
            onPressed: onApplyDeduction,
          ),
          TaskActionButton(
            label: 'إضافة حافز',
            note: 'رفع مكافأة للعامل عند الإنجاز السريع أو الجيد',
            icon: Icons.add_card_rounded,
            accent: const Color(0xFF16A34A),
            onPressed: onApplyBonus,
          ),
          TaskActionButton(
            label: 'إعادة جدولة',
            note: 'ترحيل المهمة ليوم آخر أو تقسيمها على ورديات',
            icon: Icons.event_repeat_rounded,
            accent: const Color(0xFFF59E0B),
            onPressed: onRescheduleTask,
          ),
          TaskActionHint(
            title: 'قراءة سريعة',
            description: 'أفضل مهمة الآن هي ${bestTask.title} بينما المهمة الأبطأ حالياً هي ${delayedTask.title}.',
          ),
        ],
      ),
    );
  }
}

class TaskActionButton extends StatelessWidget {
  const TaskActionButton({
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
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: accent.withValues(alpha: 0.18)),
              boxShadow: [
                BoxShadow(color: accent.withValues(alpha: 0.06), blurRadius: 14, offset: const Offset(0, 8)),
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

class TaskActionHint extends StatelessWidget {
  const TaskActionHint({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 132, maxWidth: 330),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).cardColor,
            const Color(0xFF2563EB).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2563EB).withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.psychology_alt_outlined, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF2563EB))),
          const SizedBox(height: 6),
          Text(description, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.78), height: 1.45)),
        ],
      ),
    );
  }
}



