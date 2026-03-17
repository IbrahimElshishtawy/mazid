import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class ResultsSummary {
  const ResultsSummary({
    required this.totalActual,
    required this.totalTarget,
    required this.totalProfit,
    required this.totalExpenses,
    required this.totalInventory,
    required this.completedTasks,
    required this.inProgressTasks,
    required this.alertCount,
    required this.attendanceRate,
    required this.netResult,
    required this.executionRate,
    required this.riskRate,
  });

  factory ResultsSummary.fromData({
    required List<ProductionPoint> production,
    required List<TaskModel> tasks,
    required List<InventoryItem> inventory,
    required List<FinancialReport> financialReports,
    required List<AttendanceRecord> attendance,
    required List<AlertModel> alerts,
  }) {
    final totalActual = production.fold<double>(0, (sum, item) => sum + item.actual);
    final totalTarget = production.fold<double>(0, (sum, item) => sum + item.target);
    final totalProfit = financialReports.fold<double>(0, (sum, item) => sum + item.profit);
    final totalExpenses = financialReports.fold<double>(0, (sum, item) => sum + item.expenses);
    final totalInventory = inventory.fold<int>(0, (sum, item) => sum + item.quantity).toDouble();
    final completedTasks = tasks.where((task) => task.progress >= 0.85 || task.status.contains('اكتمال') || task.status.contains('شارفت')).length;
    final inProgressTasks = tasks.where((task) => task.progress > 0.01 && task.progress < 0.85).length;
    final attendanceRate = attendance.isEmpty ? 0.0 : attendance.where((item) => item.present).length / attendance.length;
    final executionRate = totalTarget == 0 ? 0.0 : totalActual / totalTarget;
    final alertPressure = alerts.isEmpty ? 0.0 : alerts.length / math.max(3, tasks.length + 1);
    final delayedPressure = tasks.isEmpty ? 0.0 : tasks.where((task) => task.progress < 0.45).length / tasks.length;
    final riskRate = ((alertPressure * 0.55) + (delayedPressure * 0.45)).clamp(0.0, 1.0).toDouble();

    return ResultsSummary(
      totalActual: totalActual,
      totalTarget: totalTarget,
      totalProfit: totalProfit,
      totalExpenses: totalExpenses,
      totalInventory: totalInventory,
      completedTasks: completedTasks,
      inProgressTasks: inProgressTasks,
      alertCount: alerts.length,
      attendanceRate: attendanceRate,
      netResult: totalProfit - (totalExpenses * 0.18),
      executionRate: executionRate,
      riskRate: riskRate,
    );
  }

  final double totalActual;
  final double totalTarget;
  final double totalProfit;
  final double totalExpenses;
  final double totalInventory;
  final int completedTasks;
  final int inProgressTasks;
  final int alertCount;
  final double attendanceRate;
  final double netResult;
  final double executionRate;
  final double riskRate;

  String get strategicState {
    if (executionRate >= 0.95 && riskRate <= 0.22) {
      return 'نتائج تشغيلية قوية';
    }
    if (executionRate >= 0.82 && riskRate <= 0.4) {
      return 'أداء مستقر مع فرص تحسين';
    }
    return 'تحتاج تدخل استراتيجي سريع';
  }
}

class ResultsLayout {
  const ResultsLayout({required this.metricWidth, required this.primaryWidth, required this.secondaryWidth});

  factory ResultsLayout.fromWidth(double width) {
    if (width > 1220) {
      return const ResultsLayout(metricWidth: 228, primaryWidth: 680, secondaryWidth: 320);
    }
    if (width > 900) {
      return const ResultsLayout(metricWidth: 204, primaryWidth: 500, secondaryWidth: 276);
    }
    final panel = math.max(268.0, width - 92).toDouble();
    return ResultsLayout(metricWidth: panel, primaryWidth: panel, secondaryWidth: panel);
  }

  final double metricWidth;
  final double primaryWidth;
  final double secondaryWidth;
}

class ResultIdea {
  const ResultIdea({required this.title, required this.description, required this.accent, required this.icon});

  final String title;
  final String description;
  final Color accent;
  final IconData icon;
}

class ResultDecision {
  const ResultDecision({required this.label, required this.value, required this.note, required this.accent});

  final String label;
  final String value;
  final String note;
  final Color accent;
}

List<ResultIdea> buildFactoryIdeas(ResultsSummary summary) {
  return [
    ResultIdea(
      title: 'تجميع قرارات أول الشيفت',
      description: 'ابدأ اليوم بتقرير قصير يربط بين الإنتاج المتأخر، التنبيهات، والماكينات عالية الحمل قبل توزيع العمال.',
      accent: const Color(0xFF0F766E),
      icon: Icons.tips_and_updates_rounded,
    ),
    ResultIdea(
      title: 'خطة تقليل الهدر في الخامات',
      description: 'لو التنفيذ أقل من المستهدف، اربط نسبة الهدر بكل مرحلة تشغيل لمعرفة أين يحدث الفاقد الحقيقي داخل المصنع.',
      accent: const Color(0xFF2563EB),
      icon: Icons.recycling_rounded,
    ),
    ResultIdea(
      title: 'مراجعة تنقل المنتج بين الماكينات',
      description: 'قياس زمن الانتقال بين الماكينات يكشف اختناقات خفية حتى لو كان الإنتاج الكلي يبدو مستقراً.',
      accent: const Color(0xFF16A34A),
      icon: Icons.precision_manufacturing_rounded,
    ),
    ResultIdea(
      title: 'ربط الخصومات بالأثر الفعلي',
      description: 'راجع كل خصم مقابل تأخير حقيقي أو تراجع جودة، وليس بمجرد تأخر شكلي، للحفاظ على عدالة التشغيل.',
      accent: const Color(0xFFF59E0B),
      icon: Icons.balance_rounded,
    ),
    ResultIdea(
      title: 'غرفة نتائج أسبوعية',
      description: 'اعمل مراجعة أسبوعية للنتائج تضم الإنتاج والماليات والمخزون والصيانة عشان القرارات تبقى مبنية على صورة كاملة.',
      accent: const Color(0xFF7C3AED),
      icon: Icons.meeting_room_rounded,
    ),
  ];
}

List<ResultDecision> buildStrategicDecisions(ResultsSummary summary) {
  return [
    ResultDecision(
      label: 'قرار التنفيذ',
      value: formatPercent(summary.executionRate),
      note: 'اعتماد وردية دعم إضافية لو ظل التنفيذ أقل من 85% لفترتين متتاليتين.',
      accent: const Color(0xFF0F766E),
    ),
    ResultDecision(
      label: 'قرار الربحية',
      value: formatCurrency(summary.netResult),
      note: 'التركيز على المنتجات الأعلى هامشاً قبل زيادة الإنتاج الكمي فقط.',
      accent: const Color(0xFF16A34A),
    ),
    ResultDecision(
      label: 'قرار المخاطر',
      value: formatPercent(summary.riskRate),
      note: 'لو المخاطر ارتفعت، ابدأ بالصيانة الوقائية قبل توسيع الخطة الإنتاجية.',
      accent: const Color(0xFFDC2626),
    ),
  ];
}

String formatCurrency(num value) {
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

String formatPercent(double value) => '${(value * 100).round()}%';

