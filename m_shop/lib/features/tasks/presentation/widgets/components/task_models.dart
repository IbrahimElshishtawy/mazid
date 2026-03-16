import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class TaskSummary {
  const TaskSummary({
    required this.totalTasks,
    required this.completedTasks,
    required this.inProgressTasks,
    required this.delayedTasks,
    required this.averageProgress,
    required this.totalBonuses,
    required this.totalDeductions,
  });

  factory TaskSummary.fromTasks(List<TaskModel> tasks) {
    if (tasks.isEmpty) {
      return const TaskSummary(
        totalTasks: 0,
        completedTasks: 0,
        inProgressTasks: 0,
        delayedTasks: 0,
        averageProgress: 0,
        totalBonuses: 0,
        totalDeductions: 0,
      );
    }

    final completedTasks = tasks.where(_isCompleted).length;
    final inProgressTasks = tasks.where((task) => task.progress > 0 && task.progress < 1).length;
    final delayedTasks = tasks.where((task) => task.progress < 0.4).length;
    final averageProgress = tasks.fold<double>(0, (sum, task) => sum + task.progress) / tasks.length;
    final totalBonuses = tasks.fold<int>(0, (sum, task) => sum + _bonusFor(task));
    final totalDeductions = tasks.fold<int>(0, (sum, task) => sum + _deductionFor(task));

    return TaskSummary(
      totalTasks: tasks.length,
      completedTasks: completedTasks,
      inProgressTasks: inProgressTasks,
      delayedTasks: delayedTasks,
      averageProgress: averageProgress,
      totalBonuses: totalBonuses,
      totalDeductions: totalDeductions,
    );
  }

  final int totalTasks;
  final int completedTasks;
  final int inProgressTasks;
  final int delayedTasks;
  final double averageProgress;
  final int totalBonuses;
  final int totalDeductions;

  String get healthLabel {
    if (averageProgress >= 0.8 && delayedTasks == 0) {
      return 'ممتاز';
    }
    if (averageProgress >= 0.55) {
      return 'مستقر';
    }
    return 'بحاجة إلى تدخل';
  }

  static bool _isCompleted(TaskModel task) {
    return task.progress >= 1 || task.status.contains('مكتمل') || task.status.contains('اكتمال');
  }

  static int _bonusFor(TaskModel task) {
    if (task.progress >= 0.85) {
      return 180;
    }
    if (task.progress >= 0.6) {
      return 90;
    }
    return 0;
  }

  static int _deductionFor(TaskModel task) {
    if (task.progress < 0.25) {
      return 120;
    }
    if (task.progress < 0.4) {
      return 60;
    }
    return 0;
  }
}

class TaskSnapshot {
  const TaskSnapshot({
    required this.task,
    required this.workerName,
    required this.progressPercent,
    required this.bonus,
    required this.deduction,
    required this.statusMessage,
    required this.priorityLabel,
    required this.isDelayed,
  });

  factory TaskSnapshot.fromTask(TaskModel task) {
    final progressPercent = (task.progress * 100).round();
    final isDelayed = task.progress < 0.4;
    final bonus = progressPercent >= 85
        ? 180
        : progressPercent >= 60
            ? 90
            : 0;
    final deduction = progressPercent < 25
        ? 120
        : progressPercent < 40
            ? 60
            : 0;
    final priorityLabel = progressPercent >= 85
        ? 'جاهزة للإغلاق'
        : isDelayed
            ? 'تحتاج متابعة عاجلة'
            : 'قيد المتابعة';
    final statusMessage = progressPercent >= 85
        ? 'العامل يقترب من إنهاء المهمة ويمكن منحه حافز بعد الاعتماد.'
        : isDelayed
            ? 'المهمة متأخرة وتحتاج إعادة توزيع أو رقابة أقرب على العامل.'
            : 'المهمة تسير بشكل طبيعي وتحتاج متابعة يومية خفيفة.';

    return TaskSnapshot(
      task: task,
      workerName: task.assignedTo,
      progressPercent: progressPercent,
      bonus: bonus,
      deduction: deduction,
      statusMessage: statusMessage,
      priorityLabel: priorityLabel,
      isDelayed: isDelayed,
    );
  }

  final TaskModel task;
  final String workerName;
  final int progressPercent;
  final int bonus;
  final int deduction;
  final String statusMessage;
  final String priorityLabel;
  final bool isDelayed;
}

class TaskLayout {
  const TaskLayout({
    required this.metricCardWidth,
    required this.primaryPanelWidth,
    required this.secondaryPanelWidth,
  });

  factory TaskLayout.fromWidth(double width) {
    if (width > 1180) {
      return const TaskLayout(metricCardWidth: 248, primaryPanelWidth: 720, secondaryPanelWidth: 320);
    }
    if (width > 860) {
      return const TaskLayout(metricCardWidth: 220, primaryPanelWidth: 520, secondaryPanelWidth: 280);
    }

    final panelWidth = math.max(280.0, width - 92).toDouble();
    return TaskLayout(metricCardWidth: panelWidth, primaryPanelWidth: panelWidth, secondaryPanelWidth: panelWidth);
  }

  final double metricCardWidth;
  final double primaryPanelWidth;
  final double secondaryPanelWidth;
}

class TaskInsightData {
  const TaskInsightData({
    required this.title,
    required this.description,
    required this.accent,
    required this.icon,
  });

  final String title;
  final String description;
  final Color accent;
  final IconData icon;
}

class TaskWorkerData {
  const TaskWorkerData({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final double amount;
  final Color color;
}

TaskModel bestTask(List<TaskModel> tasks) {
  return tasks.reduce((current, next) => next.progress > current.progress ? next : current);
}

TaskModel mostDelayedTask(List<TaskModel> tasks) {
  return tasks.reduce((current, next) => next.progress < current.progress ? next : current);
}

String formatMoney(num value) {
  final rounded = value.round().toString();
  final buffer = StringBuffer();

  for (var i = 0; i < rounded.length; i++) {
    final position = rounded.length - i;
    buffer.write(rounded[i]);
    if (position > 1 && position % 3 == 1) {
      buffer.write(',');
    }
  }

  return '${buffer.toString()} ج.م';
}
