import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/tasks/presentation/widgets/components/task_models.dart';

class TaskInsightPanel extends StatelessWidget {
  const TaskInsightPanel({
    super.key,
    required this.selectedTask,
    required this.bestTask,
    required this.delayedTask,
    required this.summary,
  });

  final TaskModel selectedTask;
  final TaskModel bestTask;
  final TaskModel delayedTask;
  final TaskSummary summary;

  @override
  Widget build(BuildContext context) {
    final insights = [
      TaskInsightData(
        title: 'أفضل مهمة حالياً',
        description: '${bestTask.title} هي الأعلى إنجازاً ويمكن غلقها أو اعتماد مكافأتها قريباً.',
        accent: const Color(0xFF16A34A),
        icon: Icons.workspace_premium_rounded,
      ),
      TaskInsightData(
        title: 'العامل تحت المتابعة',
        description: '${selectedTask.assignedTo} يعمل الآن على ${selectedTask.title} بنسبة ${(selectedTask.progress * 100).round()}%.',
        accent: const Color(0xFF2563EB),
        icon: Icons.badge_outlined,
      ),
      TaskInsightData(
        title: 'أولوية التدخل',
        description: '${delayedTask.title} هي الأبطأ الآن وقد تحتاج خصم أو إعادة جدولة أو دعم عامل إضافي.',
        accent: const Color(0xFFDC2626),
        icon: Icons.warning_amber_rounded,
      ),
    ];

    return SectionCard(
      title: 'قراءات ذكية',
      subtitle: 'مؤشرات تنفيذية تساعدك على معرفة العمال والمهام التي تحتاج تدخلاً سريعاً.',
      child: Column(
        children: insights
            .map((insight) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TaskInsightTile(data: insight),
                ))
            .toList(),
      ),
    );
  }
}

class TaskWorkerPanel extends StatelessWidget {
  const TaskWorkerPanel({super.key, required this.snapshot});

  final TaskSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final items = [
      TaskWorkerData(label: 'نسبة الإنجاز', amount: snapshot.progressPercent.toDouble(), color: const Color(0xFF0F766E)),
      TaskWorkerData(label: 'الحافز', amount: snapshot.bonus.toDouble(), color: const Color(0xFF16A34A)),
      TaskWorkerData(label: 'الخصم', amount: snapshot.deduction.toDouble(), color: const Color(0xFFDC2626)),
    ];

    return SectionCard(
      title: 'تقييم العامل والمهمة',
      subtitle: 'تفصيل مبسط يوضح حالة التنفيذ وأثرها المالي على العامل الحالي.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(snapshot.statusMessage, style: const TextStyle(color: Color(0xFF30413D), height: 1.5)),
          const SizedBox(height: 18),
          ...items.map((item) => WorkerBar(item: item, total: item.label == 'نسبة الإنجاز' ? 100 : 200)).toList(),
        ],
      ),
    );
  }
}

class TaskInsightTile extends StatelessWidget {
  const TaskInsightTile({super.key, required this.data});

  final TaskInsightData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: data.accent.withValues(alpha: 0.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: data.accent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(data.icon, color: data.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.title, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(data.description, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WorkerBar extends StatelessWidget {
  const WorkerBar({super.key, required this.item, required this.total});

  final TaskWorkerData item;
  final double total;

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : (item.amount / total).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(item.label, style: TextStyle(color: item.color, fontWeight: FontWeight.w800))),
              Text(item.label == 'نسبة الإنجاز' ? '${item.amount.round()}%' : formatMoney(item.amount), style: const TextStyle(fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(value: ratio, minHeight: 10, color: item.color, backgroundColor: const Color(0xFFD9E6E2)),
          ),
        ],
      ),
    );
  }
}
