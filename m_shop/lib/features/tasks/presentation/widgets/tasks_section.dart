import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/tasks/presentation/widgets/components/task_actions.dart';
import 'package:m_shop/features/tasks/presentation/widgets/components/task_insights.dart';
import 'package:m_shop/features/tasks/presentation/widgets/components/task_metrics.dart';
import 'package:m_shop/features/tasks/presentation/widgets/components/task_models.dart';
import 'package:m_shop/features/tasks/presentation/widgets/components/task_sheet.dart';
import 'package:m_shop/features/tasks/presentation/widgets/components/task_worker_tile.dart';
import 'package:m_shop/features/tasks/presentation/widgets/components/tasks_chart.dart';
import 'package:m_shop/features/tasks/presentation/widgets/components/tasks_hero.dart';

class TasksSection extends StatefulWidget {
  const TasksSection({super.key, required this.tasks});

  final List<TaskModel> tasks;

  @override
  State<TasksSection> createState() => _TasksSectionState();
}

class _TasksSectionState extends State<TasksSection> {
  TaskModel? _selectedTask;

  @override
  void initState() {
    super.initState();
    if (widget.tasks.isNotEmpty) {
      _selectedTask = widget.tasks.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = widget.tasks;
    if (tasks.isEmpty) {
      return const SectionCard(
        title: 'إدارة المهام والعمال',
        subtitle: 'لا توجد مهام متاحة حالياً لعرضها في هذا القسم.',
        child: SizedBox(
          height: 120,
          child: Center(
            child: Text(
              'أضف مهام أولاً حتى تظهر المتابعة والجداول والتحليلات.',
              style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF667B75)),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final selectedTask = _selectedTask ?? tasks.first;
    final summary = TaskSummary.fromTasks(tasks);
    final snapshot = TaskSnapshot.fromTask(selectedTask);
    final topTask = bestTask(tasks);
    final delayedTask = mostDelayedTask(tasks);
    final layout = TaskLayout.fromWidth(MediaQuery.sizeOf(context).width);

    return SectionCard(
      title: 'إدارة المهام والعمال',
      subtitle: 'لوحة تشغيل عربية لتوزيع مهام العمال ومراقبة التنفيذ وتطبيق الحوافز والخصومات وإعادة الجدولة.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TasksHero(
            summary: summary,
            selectedTask: selectedTask,
            tasks: tasks,
            onSelectTask: _selectTask,
            onOpenTask: () => _showTaskDetails(selectedTask),
            onAssignTask: () => _assignTask(selectedTask),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              TaskMetricCard(
                width: layout.metricCardWidth,
                title: 'كل المهام',
                value: summary.totalTasks.toString(),
                note: 'إجمالي المهام المفتوحة والخاضعة للمتابعة حالياً',
                accent: const Color(0xFF0F766E),
                icon: Icons.assignment_rounded,
              ),
              TaskMetricCard(
                width: layout.metricCardWidth,
                title: 'مهام مكتملة',
                value: summary.completedTasks.toString(),
                note: 'مهام تم تنفيذها أو قاربت على الإغلاق النهائي',
                accent: const Color(0xFF16A34A),
                icon: Icons.task_alt_rounded,
              ),
              TaskMetricCard(
                width: layout.metricCardWidth,
                title: 'قيد التنفيذ',
                value: summary.inProgressTasks.toString(),
                note: 'مهام فعالة تحتاج متابعة أثناء اليوم',
                accent: const Color(0xFF2563EB),
                icon: Icons.pending_actions_rounded,
              ),
              TaskMetricCard(
                width: layout.metricCardWidth,
                title: 'تحتاج تدخل',
                value: summary.delayedTasks.toString(),
                note: 'مهام متأخرة قد تحتاج خصم أو دعم أو إعادة جدولة',
                accent: const Color(0xFFDC2626),
                icon: Icons.warning_amber_rounded,
              ),
            ],
          ),
          const SizedBox(height: 20),
          TaskActionPanel(
            selectedTask: selectedTask,
            bestTask: topTask,
            delayedTask: delayedTask,
            onAssignTask: () => _assignTask(selectedTask),
            onMonitorTask: () => _monitorWorker(selectedTask),
            onApplyDeduction: () => _applyDeduction(selectedTask),
            onApplyBonus: () => _applyBonus(selectedTask),
            onRescheduleTask: () => _rescheduleTask(selectedTask),
          ),
          const SizedBox(height: 20),
          TasksChartCard(tasks: tasks, summary: summary),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: layout.primaryPanelWidth,
                child: TaskInsightPanel(
                  selectedTask: selectedTask,
                  bestTask: topTask,
                  delayedTask: delayedTask,
                  summary: summary,
                ),
              ),
              SizedBox(
                width: layout.secondaryPanelWidth,
                child: TaskWorkerPanel(snapshot: snapshot),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SectionCard(
            title: 'قائمة المهام والعمال',
            subtitle: 'كل بطاقة تعرض العامل المسؤول ونسبة الإنجاز وإمكانية الدخول للتفاصيل أو اختيار المهمة النشطة.',
            child: Column(
              children: tasks
                  .map(
                    (task) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TaskWorkerTile(
                        task: task,
                        selected: task.title == selectedTask.title,
                        onSelect: () => _selectTask(task),
                        onViewDetails: () => _showTaskDetails(task),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _selectTask(TaskModel task) {
    setState(() {
      _selectedTask = task;
    });
  }

  Future<void> _assignTask(TaskModel task) {
    return showTaskInfoSheet(
      context: context,
      title: 'إسناد أو إعادة إسناد المهمة',
      subtitle: 'خطوة تشغيلية لتوزيع المهمة على عامل أو فريق آخر عند الحاجة.',
      children: [
        TaskSheetLine(label: 'المهمة', value: task.title),
        TaskSheetLine(label: 'المسند حالياً إلى', value: task.assignedTo),
        const TaskSheetLine(label: 'اقتراح التوزيع', value: 'عامل رئيسي + عامل دعم في الوردية التالية'),
        const TaskSheetMessage(message: 'يمكن اعتماد نفس المهمة للعامل الحالي أو نقلها لعامل آخر إذا كانت تحتاج سرعة أعلى أو مهارة مختلفة.'),
      ],
    );
  }

  Future<void> _monitorWorker(TaskModel task) {
    final snapshot = TaskSnapshot.fromTask(task);
    return showTaskInfoSheet(
      context: context,
      title: 'مراقبة العامل',
      subtitle: 'قراءة سريعة توضح وضع العامل الحالي على المهمة المختارة.',
      children: [
        TaskSheetLine(label: 'العامل', value: snapshot.workerName),
        TaskSheetLine(label: 'المهمة الحالية', value: task.title),
        TaskSheetLine(label: 'نسبة الإنجاز', value: '${snapshot.progressPercent}%'),
        TaskSheetLine(label: 'الحالة', value: snapshot.priorityLabel),
        TaskSheetMessage(message: snapshot.statusMessage),
      ],
    );
  }

  Future<void> _applyDeduction(TaskModel task) {
    final snapshot = TaskSnapshot.fromTask(task);
    return showTaskInfoSheet(
      context: context,
      title: 'تطبيق خصم',
      subtitle: 'تقدير مقترح للخصم في حالة التأخير أو ضعف الالتزام في التنفيذ.',
      children: [
        TaskSheetLine(label: 'العامل', value: snapshot.workerName),
        TaskSheetLine(label: 'سبب المراجعة', value: task.title),
        TaskSheetLine(label: 'نسبة الإنجاز الحالية', value: '${snapshot.progressPercent}%'),
        TaskSheetLine(label: 'قيمة الخصم المقترحة', value: formatMoney(snapshot.deduction)),
        const TaskSheetMessage(message: 'ينصح باعتماد الخصم فقط بعد مراجعة السبب الفعلي للتأخير وهل يوجد عطل أو نقص موارد أو إهمال مباشر.'),
      ],
    );
  }

  Future<void> _applyBonus(TaskModel task) {
    final snapshot = TaskSnapshot.fromTask(task);
    return showTaskInfoSheet(
      context: context,
      title: 'إضافة حافز',
      subtitle: 'اقتراح حافز للعامل عند جودة التنفيذ أو سرعة الإنجاز.',
      children: [
        TaskSheetLine(label: 'العامل', value: snapshot.workerName),
        TaskSheetLine(label: 'المهمة', value: task.title),
        TaskSheetLine(label: 'نسبة الإنجاز', value: '${snapshot.progressPercent}%'),
        TaskSheetLine(label: 'الحافز المقترح', value: formatMoney(snapshot.bonus)),
        const TaskSheetMessage(message: 'يمكن ربط الحافز بالإنجاز والجودة والانضباط في وقت التسليم لضمان عدالة التقييم.'),
      ],
    );
  }

  Future<void> _rescheduleTask(TaskModel task) {
    return showTaskInfoSheet(
      context: context,
      title: 'إعادة جدولة المهمة',
      subtitle: 'إمكانية نقل المهمة ليوم آخر أو تقسيمها على أكثر من وردية.',
      children: [
        TaskSheetLine(label: 'المهمة', value: task.title),
        TaskSheetLine(label: 'الموعد الحالي', value: task.dueDate),
        const TaskSheetLine(label: 'الموعد البديل المقترح', value: 'غداً 09:00 ص أو بعد الوردية المسائية'),
        const TaskSheetLine(label: 'خطة التنفيذ', value: 'تقسيم المهمة إلى مرحلتين مع متابعة نصف يومية'),
        const TaskSheetMessage(message: 'إعادة الجدولة مفيدة عندما يكون التأخير ناتجاً عن ضغط إنتاج أو نقص خامة أو حاجة لمهارة إضافية.'),
      ],
    );
  }

  Future<void> _showTaskDetails(TaskModel task) {
    final snapshot = TaskSnapshot.fromTask(task);
    return showTaskInfoSheet(
      context: context,
      title: 'تفاصيل المهمة',
      subtitle: 'ملف تنفيذي للمهمة يوضح العامل ونسبة الإنجاز والأثر المالي.',
      children: [
        TaskSheetLine(label: 'اسم المهمة', value: task.title),
        TaskSheetLine(label: 'العامل أو الفريق', value: task.assignedTo),
        TaskSheetLine(label: 'الحالة الحالية', value: task.status),
        TaskSheetLine(label: 'موعد التسليم', value: task.dueDate),
        TaskSheetLine(label: 'نسبة الإنجاز', value: '${snapshot.progressPercent}%'),
        TaskSheetMessage(message: snapshot.statusMessage),
      ],
    );
  }
}
