import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class ResultsSection extends StatelessWidget {
  const ResultsSection({super.key, required this.production, required this.tasks});

  final List<ProductionPoint> production;
  final List<TaskModel> tasks;

  @override
  Widget build(BuildContext context) {
    final totalProduction = production.fold<double>(0, (sum, item) => sum + item.actual);
    final totalTarget = production.fold<double>(0, (sum, item) => sum + item.target);
    final completedTasks = tasks.where((task) => task.progress >= 1 || task.status.toLowerCase().contains('done')).length;

    return SectionCard(
      title: 'Results',
      subtitle: 'Combined outcome view for production delivery and task completion.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _ResultCard(title: 'Production', value: totalProduction.round().toString(), color: const Color(0xFF0F766E)),
              _ResultCard(title: 'Target', value: totalTarget.round().toString(), color: const Color(0xFF2563EB)),
              _ResultCard(title: 'Completed Tasks', value: completedTasks.toString(), color: const Color(0xFF16A34A)),
            ],
          ),
          const SizedBox(height: 18),
          const _ResultLine(title: 'Execution is measurable', description: 'Results are easier to track when targets and delivery are reviewed together.'),
          const _ResultLine(title: 'Progress should stay consistent', description: 'Keep unfinished work visible and compare it against expected output regularly.'),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.title, required this.value, required this.color});
  final String title;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(width: 190, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withValues(alpha: 0.12))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 34, height: 4, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999))), const SizedBox(height: 12), Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w700)), const SizedBox(height: 8), Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900))]));
  }
}

class _ResultLine extends StatelessWidget {
  const _ResultLine({required this.title, required this.description});
  final String title;
  final String description;
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(bottom: 12), child: Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFF7FAF9), borderRadius: BorderRadius.circular(18)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 6), Text(description, style: const TextStyle(color: Color(0xFF667B75), height: 1.5))])));
  }
}
