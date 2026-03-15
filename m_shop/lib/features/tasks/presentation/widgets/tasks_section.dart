import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class TasksSection extends StatelessWidget {
  const TasksSection({super.key, required this.tasks});

  final List<TaskModel> tasks;

  @override
  Widget build(BuildContext context) {
    final completed = tasks.where((task) => task.progress >= 1 || task.status.toLowerCase().contains('done')).length;
    final inProgress = tasks.where((task) => task.progress > 0 && task.progress < 1).length;
    final delayed = tasks.where((task) => task.progress < 0.4).length;

    return SectionCard(
      title: 'Tasks',
      subtitle: 'Task status, progress level, and delivery follow-up.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _TaskStatCard(title: 'All Tasks', value: tasks.length.toString(), color: const Color(0xFF0F766E)),
              _TaskStatCard(title: 'Completed', value: completed.toString(), color: const Color(0xFF16A34A)),
              _TaskStatCard(title: 'In Progress', value: inProgress.toString(), color: const Color(0xFF2563EB)),
              _TaskStatCard(title: 'Needs Follow-up', value: delayed.toString(), color: const Color(0xFFF59E0B)),
            ],
          ),
          const SizedBox(height: 18),
          ...tasks.map((task) => _TaskTile(task: task)),
        ],
      ),
    );
  }
}

class _TaskStatCard extends StatelessWidget {
  const _TaskStatCard({required this.title, required this.value, required this.color});
  final String title;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(width: 180, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withValues(alpha: 0.12))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 34, height: 4, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999))), const SizedBox(height: 12), Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w700)), const SizedBox(height: 8), Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900))]));
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.task});
  final TaskModel task;
  @override
  Widget build(BuildContext context) {
    final accent = task.progress >= 1 ? const Color(0xFF16A34A) : task.progress < 0.4 ? const Color(0xFFF59E0B) : const Color(0xFF2563EB);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF7FAF9), borderRadius: BorderRadius.circular(18)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Expanded(child: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w800))), Text('${(task.progress * 100).round()}%', style: TextStyle(color: accent, fontWeight: FontWeight.w800))]),
        const SizedBox(height: 6),
        Text(task.description, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
        const SizedBox(height: 10),
        ClipRRect(borderRadius: BorderRadius.circular(999), child: LinearProgressIndicator(value: task.progress.clamp(0.0, 1.0).toDouble(), minHeight: 10, color: accent, backgroundColor: accent.withValues(alpha: 0.12))),
        const SizedBox(height: 8),
        Text('Assigned to ${task.assignedTo} • Due ${task.dueDate} • Status ${task.status}', style: const TextStyle(color: Color(0xFF667B75))),
      ]),
    );
  }
}
