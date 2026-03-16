import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class FinanceSummary {
  const FinanceSummary({
    required this.totalIncome,
    required this.totalExpenses,
    required this.totalProfit,
    required this.availableCash,
    required this.averageProfit,
    required this.bestProfit,
    required this.bestMargin,
  });

  factory FinanceSummary.fromReports(List<FinancialReport> reports) {
    if (reports.isEmpty) {
      return const FinanceSummary(
        totalIncome: 0,
        totalExpenses: 0,
        totalProfit: 0,
        availableCash: 0,
        averageProfit: 0,
        bestProfit: 0,
        bestMargin: 0,
      );
    }

    final totalIncome = reports.fold<double>(0, (sum, report) => sum + report.income);
    final totalExpenses = reports.fold<double>(0, (sum, report) => sum + report.expenses);
    final totalProfit = reports.fold<double>(0, (sum, report) => sum + report.profit);

    return FinanceSummary(
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      totalProfit: totalProfit,
      availableCash: totalIncome - (totalExpenses * 0.82),
      averageProfit: totalProfit / reports.length,
      bestProfit: reports.map((report) => report.profit).reduce(math.max).toDouble(),
      bestMargin: reports.map(_marginFor).reduce(math.max).toDouble(),
    );
  }

  final double totalIncome;
  final double totalExpenses;
  final double totalProfit;
  final double availableCash;
  final double averageProfit;
  final double bestProfit;
  final double bestMargin;

  double get margin => totalIncome == 0 ? 0.0 : totalProfit / totalIncome;
  double get expenseRatio => totalIncome == 0 ? 0.0 : totalExpenses / totalIncome;

  String get healthLabel {
    if (margin >= 0.30) {
      return 'ممتاز';
    }
    if (margin >= 0.20) {
      return 'جيد';
    }
    return 'بحاجة إلى متابعة';
  }

  double marginFor(FinancialReport report) => _marginFor(report);

  double expenseRatioFor(FinancialReport report) {
    if (report.income == 0) {
      return 0.0;
    }
    return report.expenses / report.income;
  }

  static double _marginFor(FinancialReport report) {
    if (report.income == 0) {
      return 0.0;
    }
    return report.profit / report.income;
  }
}

class FinanceSnapshot {
  const FinanceSnapshot({
    required this.report,
    required this.margin,
    required this.availableCash,
    required this.operationalBudget,
    required this.reserveBudget,
    required this.growthBudget,
    required this.statusMessage,
  });

  factory FinanceSnapshot.fromReport(FinancialReport report) {
    final margin = report.income == 0 ? 0.0 : report.profit / report.income;
    final statusMessage = margin >= 0.30
        ? 'الفترة تحقق ربحية قوية ويمكن البناء عليها في التوسع.'
        : margin >= 0.18
            ? 'الفترة مستقرة وتحتاج فقط إلى تحسينات بسيطة في ضبط التكلفة.'
            : 'الفترة تحتاج إلى تدخل أسرع لخفض الهدر ورفع كفاءة التشغيل.';

    return FinanceSnapshot(
      report: report,
      margin: margin,
      availableCash: report.income - (report.expenses * 0.82),
      operationalBudget: report.profit * 0.40,
      reserveBudget: report.profit * 0.35,
      growthBudget: report.profit * 0.25,
      statusMessage: statusMessage,
    );
  }

  final FinancialReport report;
  final double margin;
  final double availableCash;
  final double operationalBudget;
  final double reserveBudget;
  final double growthBudget;
  final String statusMessage;
}

class FinanceLayout {
  const FinanceLayout({
    required this.metricCardWidth,
    required this.primaryPanelWidth,
    required this.secondaryPanelWidth,
  });

  factory FinanceLayout.fromWidth(double width) {
    if (width > 1180) {
      return const FinanceLayout(
        metricCardWidth: 248,
        primaryPanelWidth: 720,
        secondaryPanelWidth: 320,
      );
    }
    if (width > 860) {
      return const FinanceLayout(
        metricCardWidth: 220,
        primaryPanelWidth: 520,
        secondaryPanelWidth: 280,
      );
    }

    final panelWidth = math.max(280.0, width - 92).toDouble();
    return FinanceLayout(
      metricCardWidth: panelWidth,
      primaryPanelWidth: panelWidth,
      secondaryPanelWidth: panelWidth,
    );
  }

  final double metricCardWidth;
  final double primaryPanelWidth;
  final double secondaryPanelWidth;
}

class FinanceInsightData {
  const FinanceInsightData({
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

class FinanceAllocationData {
  const FinanceAllocationData({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final double amount;
  final Color color;
}

FinancialReport bestProfitReport(List<FinancialReport> reports) {
  return reports.reduce((current, next) => next.profit > current.profit ? next : current);
}

FinancialReport highestExpensePressureReport(List<FinancialReport> reports) {
  return reports.reduce((current, next) {
    final currentRatio = current.income == 0 ? 0.0 : current.expenses / current.income;
    final nextRatio = next.income == 0 ? 0.0 : next.expenses / next.income;
    return nextRatio > currentRatio ? next : current;
  });
}

String formatCurrency(double value) {
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
