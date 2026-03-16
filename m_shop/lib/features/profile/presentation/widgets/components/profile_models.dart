import 'dart:math' as math;

import 'package:flutter/material.dart';
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
    required this.availableCash,
    required this.totalProfit,
    required this.totalExpenses,
    required this.totalProduction,
    required this.totalTarget,
    required this.alertCount,
    required this.teamSize,
    required this.netMargin,
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
    return ProfileSummary(
      availableCash: totalIncome - (totalExpenses * 0.82),
      totalProfit: totalProfit,
      totalExpenses: totalExpenses,
      totalProduction: totalProduction,
      totalTarget: totalTarget,
      alertCount: alerts.length,
      teamSize: users.length,
      netMargin: totalIncome == 0 ? 0.0 : totalProfit / totalIncome,
    );
  }

  final double availableCash;
  final double totalProfit;
  final double totalExpenses;
  final double totalProduction;
  final double totalTarget;
  final int alertCount;
  final int teamSize;
  final double netMargin;

  String get ownerState {
    if (netMargin >= 0.28 && alertCount <= 1) return 'ملف قيادي قوي';
    if (netMargin >= 0.18) return 'إدارة مستقرة';
    return 'تحتاج تدخل مالي وتشغيلي';
  }
}

class ProfileLayout {
  const ProfileLayout({required this.metricWidth, required this.primaryWidth, required this.secondaryWidth});
  factory ProfileLayout.fromWidth(double width) {
    if (width > 1220) return const ProfileLayout(metricWidth: 248, primaryWidth: 720, secondaryWidth: 340);
    if (width > 900) return const ProfileLayout(metricWidth: 220, primaryWidth: 540, secondaryWidth: 300);
    final panel = math.max(280.0, width - 92).toDouble();
    return ProfileLayout(metricWidth: panel, primaryWidth: panel, secondaryWidth: panel);
  }
  final double metricWidth;
  final double primaryWidth;
  final double secondaryWidth;
}

List<CompanyMarket> buildCompanyMarkets() {
  return const [
    CompanyMarket(name: 'السوق المحلي', share: 0.42, currency: 'EGP', growth: 0.12),
    CompanyMarket(name: 'الخليج', share: 0.26, currency: 'SAR', growth: 0.18),
    CompanyMarket(name: 'شمال أفريقيا', share: 0.14, currency: 'USD', growth: 0.09),
    CompanyMarket(name: 'شرق أفريقيا', share: 0.10, currency: 'USD', growth: 0.07),
    CompanyMarket(name: 'أوروبا التصديرية', share: 0.08, currency: 'EUR', growth: 0.11),
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
    CompanyInfoItem(title: 'اسم الشركة', value: 'مصنع مازيد للصناعات الذكية', note: 'الهوية الرسمية المستخدمة في المتابعة والتصدير'),
    CompanyInfoItem(title: 'نوع النشاط', value: 'تصنيع وتشغيل وتغليف صناعي', note: 'إنتاج متدرج من الخامة حتى التسليم النهائي'),
    CompanyInfoItem(title: 'عدد الفريق', value: '${summary.teamSize}', note: 'الإدارة والمشرفون والعمال داخل المنظومة الحالية'),
    CompanyInfoItem(title: 'صافي الهامش', value: formatPercent(summary.netMargin), note: 'نسبة الربحية بعد مقارنة الأرباح بالدخل الكلي'),
    CompanyInfoItem(title: 'الإنتاج الكلي', value: '${summary.totalProduction.round()}', note: 'إجمالي التنفيذ الفعلي عبر الفترات الحالية'),
    CompanyInfoItem(title: 'التنبيهات المفتوحة', value: '${summary.alertCount}', note: 'تنبيهات تشغيلية تحتاج مراجعة أو متابعة'),
    CompanyInfoItem(title: 'السيولة المتاحة', value: formatMoney(summary.availableCash), note: 'قراءة تقريبية تساعد صاحب المصنع في القرار السريع'),
  ];
}

String formatMoney(num value) {
  final rounded = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < rounded.length; i++) {
    final position = rounded.length - i;
    buffer.write(rounded[i]);
    if (position > 1 && position % 3 == 1) buffer.write(',');
  }
  return '${buffer.toString()} ج.م';
}

String formatPercent(double value) => '${(value * 100).round()}%';
