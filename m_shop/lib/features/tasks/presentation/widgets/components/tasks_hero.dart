import 'package:flutter/material.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/tasks/presentation/widgets/components/task_models.dart';

class TasksHero extends StatelessWidget {
  const TasksHero({
    super.key,
    required this.summary,
    required this.selectedTask,
    required this.tasks,
    required this.onSelectTask,
    required this.onOpenTask,
    required this.onAssignTask,
  });

  final TaskSummary summary;
  final TaskModel selectedTask;
  final List<TaskModel> tasks;
  final ValueChanged<TaskModel> onSelectTask;
  final VoidCallback onOpenTask;
  final VoidCallback onAssignTask;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF111827), Color(0xFF1D4ED8), Color(0xFF0F766E)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D4ED8).withValues(alpha: 0.16),
            blurRadius: 34,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -20,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
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
                  const _HeroBadge(label: 'غرفة متابعة العمال والمهام'),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 580),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tasks
                          .map(
                            (task) => ChoiceChip(
                              label: Text(task.title),
                              selected: task.title == selectedTask.title,
                              onSelected: (_) => onSelectTask(task),
                              selectedColor: const Color(0xFFDBEAFE),
                              backgroundColor: Colors.white.withValues(alpha: 0.10),
                              labelStyle: TextStyle(
                                color: task.title == selectedTask.title ? const Color(0xFF1E3A8A) : Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                              side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
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
                        Text(
                          'جاهزية التنفيذ ${summary.healthLabel}',
                          style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'تقدر من هنا توزع الشغل على العمال، تراجع الأداء، ترفع حوافز، تخصم عند التأخير، وتعيد جدولة المهام للأيام التالية من نفس الصفحة.',
                          style: const TextStyle(color: Color(0xE7FFFFFF), height: 1.6),
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            HeroStat(label: 'متوسط الإنجاز', value: '${(summary.averageProgress * 100).round()}%'),
                            HeroStat(label: 'إجمالي الحوافز', value: formatMoney(summary.totalBonuses)),
                            HeroStat(label: 'إجمالي الخصومات', value: formatMoney(summary.totalDeductions)),
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
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('المهمة الحالية', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                              const SizedBox(height: 10),
                              Text(selectedTask.title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                              const SizedBox(height: 6),
                              Text('العامل: ${selectedTask.assignedTo}', style: const TextStyle(color: Color(0xD8FFFFFF))),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: onOpenTask,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFFBBF24),
                            foregroundColor: const Color(0xFF111827),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          ),
                          icon: const Icon(Icons.visibility_rounded),
                          label: const Text('فتح ملف المهمة'),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: onAssignTask,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.22)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          ),
                          icon: const Icon(Icons.assignment_ind_outlined),
                          label: const Text('توزيع أو إعادة إسناد'),
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
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xDBFFFFFF), fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
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
