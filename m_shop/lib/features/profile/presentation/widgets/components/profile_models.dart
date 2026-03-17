import 'dart:math' as math;

import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class CompanyMarket {
  const CompanyMarket({required this.name, required this.share, required this.currency, required this.growth});

  final String name;
  final double share;
  final String currency;
  final double growth;
}

class CurrencyPoint {
  const CurrencyPoint({required this.code, required this.value, required this.change});

  final String code;
  final double value;
  final double change;
}

class CompanyInfoItem {
  const CompanyInfoItem({required this.title, required this.value, required this.note});

  final String title;
  final String value;
  final String note;
}

class ProfileSummary {
  const ProfileSummary({
    required this.totalIncome,
    required this.availableCash,
    required this.totalProfit,
    required this.totalExpenses,
    required this.totalProduction,
    required this.totalTarget,
    required this.alertCount,
    required this.teamSize,
    required this.netMargin,
    required this.totalTasks,
    required this.completedTasks,
    required this.delayedTasks,
    required this.lowStockItems,
  });

  factory ProfileSummary.fromData({
    required List<UserModel> users,
    required List<ProductionPoint> production,
    required List<FinancialReport> financialReports,
    required List<InventoryItem> inventory,
    required List<TaskModel> tasks,
    required List<AlertModel> alerts,
  }) {
    final totalIncome = financialReports.fold<double>(0, (sum, item) => sum + item.income);
    final totalProfit = financialReports.fold<double>(0, (sum, item) => sum + item.profit);
    final totalExpenses = financialReports.fold<double>(0, (sum, item) => sum + item.expenses);
    final totalProduction = production.fold<double>(0, (sum, item) => sum + item.actual);
    final totalTarget = production.fold<double>(0, (sum, item) => sum + item.target);
    final completedTasks = tasks.where((task) => task.progress >= 0.85 || task.status.contains('\u0627\u0643\u062A\u0645\u0627\u0644') || task.status.contains('\u0645\u0643\u062A\u0645\u0644') || task.status.contains('\u0634\u0627\u0631\u0641\u062A')).length;
    final delayedTasks = tasks.where((task) => task.progress < 0.45 || task.status.contains('\u0645\u062A\u0623\u062E\u0631') || task.status.contains('\u062A\u0639\u0637\u064A\u0644')).length;
    final lowStockItems = inventory.where((item) => item.quantity <= item.minimum).length;

    return ProfileSummary(
      totalIncome: totalIncome,
      availableCash: totalIncome - (totalExpenses * 0.82),
      totalProfit: totalProfit,
      totalExpenses: totalExpenses,
      totalProduction: totalProduction,
      totalTarget: totalTarget,
      alertCount: alerts.length,
      teamSize: users.length,
      netMargin: totalIncome == 0 ? 0.0 : totalProfit / totalIncome,
      totalTasks: tasks.length,
      completedTasks: completedTasks,
      delayedTasks: delayedTasks,
      lowStockItems: lowStockItems,
    );
  }

  final double totalIncome;
  final double availableCash;
  final double totalProfit;
  final double totalExpenses;
  final double totalProduction;
  final double totalTarget;
  final int alertCount;
  final int teamSize;
  final double netMargin;
  final int totalTasks;
  final int completedTasks;
  final int delayedTasks;
  final int lowStockItems;

  double get productionRate {
    if (totalTarget == 0) return 0.0;
    return totalProduction / totalTarget;
  }

  double get taskCompletionRate {
    if (totalTasks == 0) return 0.0;
    return completedTasks / totalTasks;
  }

  double get expenseShare {
    if (totalIncome == 0) return 0.0;
    return totalExpenses / totalIncome;
  }

  String get ownerState {
    if (netMargin >= 0.28 && alertCount <= 1 && lowStockItems == 0) return '\u0645\u0644\u0641 \u0642\u064A\u0627\u062F\u064A \u0642\u0648\u064A';
    if (netMargin >= 0.18 && delayedTasks <= 1) return '\u0625\u062F\u0627\u0631\u0629 \u0645\u0633\u062A\u0642\u0631\u0629';
    return '\u062A\u062D\u062A\u0627\u062C \u062A\u062F\u062E\u0644 \u0645\u0627\u0644\u064A \u0648\u062A\u0634\u063A\u064A\u0644\u064A';
  }

  String get actionMessage {
    if (netMargin < 0.18) {
      return '\u0631\u0627\u062C\u0639 \u0627\u0644\u062A\u0643\u0644\u0641\u0629 \u0642\u0628\u0644 \u0627\u0644\u062A\u0648\u0633\u0639.';
    }
    if (lowStockItems > 0) {
      return '\u0641\u064A \u062E\u0627\u0645\u0627\u062A \u062A\u062D\u062A\u0627\u062C \u062F\u0639\u0645\u0627 \u0633\u0631\u064A\u0639\u0627.';
    }
    if (delayedTasks > 1) {
      return '\u0627\u0631\u0641\u0639 \u0645\u062A\u0627\u0628\u0639\u0629 \u0627\u0644\u0645\u0647\u0627\u0645 \u0627\u0644\u0645\u062A\u0623\u062E\u0631\u0629.';
    }
    return '\u0627\u0644\u0648\u0636\u0639 \u062C\u064A\u062F \u0648\u064A\u0645\u0643\u0646 \u062F\u0641\u0639 \u0627\u0644\u0628\u064A\u0639.';
  }
}

class ProfileLayout {
  const ProfileLayout({required this.metricWidth, required this.primaryWidth, required this.secondaryWidth});

  factory ProfileLayout.fromWidth(double width) {
    if (width > 1220) return const ProfileLayout(metricWidth: 228, primaryWidth: 680, secondaryWidth: 320);
    if (width > 900) return const ProfileLayout(metricWidth: 204, primaryWidth: 500, secondaryWidth: 276);
    final panel = math.max(268.0, width - 92).toDouble();
    return ProfileLayout(metricWidth: panel, primaryWidth: panel, secondaryWidth: panel);
  }

  final double metricWidth;
  final double primaryWidth;
  final double secondaryWidth;
}

List<CompanyMarket> buildCompanyMarkets() {
  return const [
    CompanyMarket(name: '\u0627\u0644\u0633\u0648\u0642 \u0627\u0644\u0645\u062D\u0644\u064A', share: 0.42, currency: 'EGP', growth: 0.12),
    CompanyMarket(name: '\u0627\u0644\u062E\u0644\u064A\u062C', share: 0.26, currency: 'SAR', growth: 0.18),
    CompanyMarket(name: '\u0634\u0645\u0627\u0644 \u0623\u0641\u0631\u064A\u0642\u064A\u0627', share: 0.14, currency: 'USD', growth: 0.09),
    CompanyMarket(name: '\u0634\u0631\u0642 \u0623\u0641\u0631\u064A\u0642\u064A\u0627', share: 0.10, currency: 'USD', growth: 0.07),
    CompanyMarket(name: '\u0623\u0648\u0631\u0648\u0628\u0627 \u0627\u0644\u062A\u0635\u062F\u064A\u0631\u064A\u0629', share: 0.08, currency: 'EUR', growth: 0.11),
  ];
}

List<CurrencyPoint> buildCurrencyPoints() {
  return const [
    CurrencyPoint(code: 'EGP', value: 1.0, change: 0.00),
    CurrencyPoint(code: 'USD', value: 49.1, change: 0.03),
    CurrencyPoint(code: 'EUR', value: 53.4, change: 0.02),
    CurrencyPoint(code: 'SAR', value: 13.0, change: 0.01),
    CurrencyPoint(code: 'AED', value: 13.4, change: 0.015),
  ];
}

List<CompanyInfoItem> buildCompanyInfo(ProfileSummary summary) {
  return [
    CompanyInfoItem(title: '\u0627\u0633\u0645 \u0627\u0644\u0643\u064A\u0627\u0646', value: 'Mazid Smart Factory', note: '\u0627\u0644\u0627\u0633\u0645 \u0627\u0644\u0631\u0633\u0645\u064A \u0641\u064A \u0644\u0648\u062D\u0629 \u0627\u0644\u0645\u062A\u0627\u0628\u0639\u0629.'),
    CompanyInfoItem(title: '\u0646\u0645\u0648\u0630\u062C \u0627\u0644\u062A\u0634\u063A\u064A\u0644', value: '\u062A\u0635\u0646\u064A\u0639 \u0648\u062A\u0634\u063A\u064A\u0644 \u0648\u062A\u063A\u0644\u064A\u0641', note: '\u0645\u0646 \u0627\u0644\u062E\u0627\u0645\u0629 \u062D\u062A\u0649 \u0627\u0644\u062A\u0633\u0644\u064A\u0645.'),
    CompanyInfoItem(title: '\u0627\u0644\u0623\u0633\u0648\u0627\u0642 \u0627\u0644\u0646\u0634\u0637\u0629', value: '5 \u0623\u0633\u0648\u0627\u0642', note: '\u0645\u062D\u0644\u064A \u0648\u062E\u0644\u064A\u062C \u0648\u0623\u0641\u0631\u064A\u0642\u064A\u0627 \u0648\u0623\u0648\u0631\u0648\u0628\u0627.'),
    CompanyInfoItem(title: '\u0627\u0644\u0639\u0645\u0644\u0627\u062A \u0627\u0644\u0645\u062A\u0627\u0628\u0639\u0629', value: 'EGP | USD | EUR | SAR | AED', note: '\u062A\u0624\u062B\u0631 \u0639\u0644\u0649 \u0627\u0644\u062A\u0633\u0639\u064A\u0631 \u0648\u0627\u0644\u0647\u0627\u0645\u0634.'),
    CompanyInfoItem(title: '\u0642\u0648\u0629 \u0627\u0644\u0641\u0631\u064A\u0642', value: '${summary.teamSize} \u0639\u0636\u0648', note: '\u0625\u062F\u0627\u0631\u0629 \u0648\u0645\u0634\u0631\u0641\u0648\u0646 \u0648\u0639\u0645\u0627\u0644.'),
    CompanyInfoItem(title: '\u062A\u062D\u0642\u064A\u0642 \u0627\u0644\u0645\u0633\u062A\u0647\u062F\u0641', value: '${(summary.productionRate * 100).round()}%', note: '\u0627\u0644\u0625\u0646\u062A\u0627\u062C \u0627\u0644\u0641\u0639\u0644\u064A \u0645\u0642\u0627\u0628\u0644 \u0627\u0644\u062E\u0637\u0629.'),
    CompanyInfoItem(title: '\u0627\u0644\u0633\u064A\u0648\u0644\u0629 \u0627\u0644\u0645\u062A\u0627\u062D\u0629', value: formatMoney(summary.availableCash), note: '\u0645\u0624\u0634\u0631 \u0627\u0644\u0642\u0631\u0627\u0631 \u0627\u0644\u0645\u0627\u0644\u064A \u0627\u0644\u0633\u0631\u064A\u0639.'),
  ];
}

String formatMoney(num value) {
  final isNegative = value < 0;
  final rounded = value.abs().round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < rounded.length; i++) {
    final position = rounded.length - i;
    buffer.write(rounded[i]);
    if (position > 1 && position % 3 == 1) buffer.write(',');
  }
  final formatted = '${buffer.toString()} \u062C.\u0645';
  return isNegative ? '-$formatted' : formatted;
}

String formatPercent(double value) => '${(value * 100).round()}%';

