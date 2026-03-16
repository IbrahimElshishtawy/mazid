import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class ProductJourney {
  const ProductJourney({
    required this.name,
    required this.sku,
    required this.rawMaterial,
    required this.output,
    required this.supervisor,
    required this.currentStage,
    required this.currentMachine,
    required this.qualityRate,
    required this.actual,
    required this.target,
    required this.steps,
    required this.machines,
  });

  final String name;
  final String sku;
  final String rawMaterial;
  final String output;
  final String supervisor;
  final String currentStage;
  final String currentMachine;
  final double qualityRate;
  final double actual;
  final double target;
  final List<ProductStep> steps;
  final List<MachineInfo> machines;

  double get completionRatio => target == 0 ? 0.0 : (actual / target).clamp(0.0, 1.2).toDouble();

  ProductStep get currentStep => steps.firstWhere(
        (step) => step.status.contains('تشغيل') || step.status.contains('معالجة') || step.status.contains('جودة'),
        orElse: () => steps.first,
      );
}

class ProductStep {
  const ProductStep({
    required this.title,
    required this.description,
    required this.machine,
    required this.operator,
    required this.progress,
    required this.status,
    required this.durationHours,
    required this.qualityGate,
  });

  final String title;
  final String description;
  final String machine;
  final String operator;
  final double progress;
  final String status;
  final int durationHours;
  final String qualityGate;

  Color get accent {
    if (progress >= 1 || status.contains('اكتمل')) {
      return const Color(0xFF16A34A);
    }
    if (progress >= 0.55) {
      return const Color(0xFF0F766E);
    }
    if (status.contains('جودة') || status.contains('اعتماد')) {
      return const Color(0xFF2563EB);
    }
    return const Color(0xFFF59E0B);
  }
}

class MachineInfo {
  const MachineInfo({
    required this.name,
    required this.model,
    required this.currentProduct,
    required this.efficiency,
    required this.temperature,
    required this.status,
    required this.operatingHours,
    required this.queueCount,
    required this.maintenanceNote,
  });

  final String name;
  final String model;
  final String currentProduct;
  final double efficiency;
  final int temperature;
  final String status;
  final double operatingHours;
  final int queueCount;
  final String maintenanceNote;

  Color get accent {
    if (status.contains('تشغيل')) {
      return const Color(0xFF0F766E);
    }
    if (status.contains('جودة') || status.contains('متابعة')) {
      return const Color(0xFF2563EB);
    }
    if (status.contains('صيانة')) {
      return const Color(0xFFDC2626);
    }
    return const Color(0xFFF59E0B);
  }
}

class ProductivitySummary {
  const ProductivitySummary({
    required this.totalActual,
    required this.totalTarget,
    required this.completionRatio,
    required this.averageQuality,
    required this.activeMachines,
    required this.totalMachines,
    required this.completedSteps,
    required this.totalSteps,
  });

  factory ProductivitySummary.fromJourneys(List<ProductJourney> journeys) {
    final totalActual = journeys.fold<double>(0, (sum, item) => sum + item.actual);
    final totalTarget = journeys.fold<double>(0, (sum, item) => sum + item.target);
    final allSteps = journeys.expand((journey) => journey.steps).toList();
    final allMachines = journeys.expand((journey) => journey.machines).toList();
    final averageQuality = journeys.isEmpty ? 0.0 : journeys.fold<double>(0, (sum, item) => sum + item.qualityRate) / journeys.length;
    final activeMachines = allMachines.where((machine) => machine.status.contains('تشغيل') || machine.status.contains('متابعة')).length;
    final completedSteps = allSteps.where((step) => step.progress >= 1 || step.status.contains('اكتمل')).length;

    return ProductivitySummary(
      totalActual: totalActual,
      totalTarget: totalTarget,
      completionRatio: totalTarget == 0 ? 0.0 : totalActual / totalTarget,
      averageQuality: averageQuality,
      activeMachines: activeMachines,
      totalMachines: allMachines.length,
      completedSteps: completedSteps,
      totalSteps: allSteps.length,
    );
  }

  final double totalActual;
  final double totalTarget;
  final double completionRatio;
  final double averageQuality;
  final int activeMachines;
  final int totalMachines;
  final int completedSteps;
  final int totalSteps;

  String get stateLabel {
    if (completionRatio >= 0.95 && averageQuality >= 0.92) {
      return 'تشغيل ممتاز';
    }
    if (completionRatio >= 0.82) {
      return 'تشغيل مستقر';
    }
    return 'يحتاج متابعة لصيقة';
  }
}

class ProductivityLayout {
  const ProductivityLayout({
    required this.metricWidth,
    required this.primaryWidth,
    required this.secondaryWidth,
  });

  factory ProductivityLayout.fromWidth(double width) {
    if (width >= 1220) {
      return const ProductivityLayout(metricWidth: 252, primaryWidth: 740, secondaryWidth: 340);
    }
    if (width >= 920) {
      return const ProductivityLayout(metricWidth: 220, primaryWidth: 560, secondaryWidth: 300);
    }
    final fullWidth = math.max(280.0, width - 92).toDouble();
    return ProductivityLayout(metricWidth: fullWidth, primaryWidth: fullWidth, secondaryWidth: fullWidth);
  }

  final double metricWidth;
  final double primaryWidth;
  final double secondaryWidth;
}

List<ProductJourney> buildProductJourneys(List<ProductionPoint> production) {
  final source = production.isEmpty
      ? const [
          ProductionPoint(label: 'أ', actual: 76, target: 88),
          ProductionPoint(label: 'ب', actual: 84, target: 90),
          ProductionPoint(label: 'ج', actual: 68, target: 80),
        ]
      : production;

  const names = ['وحدة تغليف صناعي', 'قطعة تشغيل معدنية', 'لوح تجهيز نهائي', 'مكوّن تجميع دقيق', 'قالب تصنيع سريع', 'مجموعة فرز وتغليف'];
  const raws = ['صفائح خام + مواد عزل', 'سبائك معدنية + سوائل تبريد', 'ألواح معالجة + طبقة حماية', 'مكوّنات دقيقة + مادة لاصقة', 'قوالب أولية + مثبتات', 'كرتون صناعي + شرائط تثبيت'];
  const outputs = ['تغليف جاهز للشحن', 'قطعة معالجة نهائية', 'منتج نصف نهائي معتمد', 'مكوّن جاهز للتجميع', 'وحدة جاهزة للفحص', 'دفعة تغليف مكتملة'];
  const supervisors = ['أحمد علي', 'سارة محمد', 'يوسف خالد', 'ليلى أحمد', 'فريق التشغيل', 'مشرف الجودة'];

  return List<ProductJourney>.generate(source.length, (index) {
    final point = source[index];
    final name = names[index % names.length];
    final raw = raws[index % raws.length];
    final output = outputs[index % outputs.length];
    final supervisor = supervisors[index % supervisors.length];
    final baseCompletion = point.target == 0 ? 0.0 : (point.actual / point.target).clamp(0.0, 1.15).toDouble();
    final steps = [
      ProductStep(
        title: 'استلام الخامات',
        description: 'مراجعة الكمية والحالة واعتماد دخول الخام قبل بدء التشغيل.',
        machine: 'منطقة الفحص الأولي',
        operator: 'فريق الخامات',
        progress: 1,
        status: 'اكتمل',
        durationHours: 2,
        qualityGate: 'مطابقة الخامة وختم الاستلام',
      ),
      ProductStep(
        title: 'التجهيز والقص',
        description: 'تحديد المقاسات وتهيئة المنتج قبل إدخاله على الماكينات الرئيسية.',
        machine: 'Cutter-X${index + 1}',
        operator: supervisor,
        progress: (baseCompletion + 0.12).clamp(0.25, 1.0).toDouble(),
        status: baseCompletion > 0.85 ? 'اكتمل' : 'قيد التشغيل',
        durationHours: 3,
        qualityGate: 'مراجعة المقاس قبل النقل للخط',
      ),
      ProductStep(
        title: 'المعالجة الأساسية',
        description: 'تنفيذ التشغيل الرئيسي وإعداد المنتج وفق مواصفات الخط.',
        machine: 'CNC-${12 + index}',
        operator: supervisors[(index + 1) % supervisors.length],
        progress: (baseCompletion - 0.06).clamp(0.18, 0.96).toDouble(),
        status: baseCompletion > 0.72 ? 'قيد المعالجة' : 'بانتظار الدور',
        durationHours: 5,
        qualityGate: 'فحص القياس والحرارة أثناء التشغيل',
      ),
      ProductStep(
        title: 'الجودة والاعتماد',
        description: 'قياس دقة المنتج واعتماد الجودة قبل مرحلة الخروج.',
        machine: 'Quality Desk ${index + 1}',
        operator: 'مشرف الجودة',
        progress: (baseCompletion - 0.24).clamp(0.0, 0.9).toDouble(),
        status: baseCompletion > 0.9 ? 'اعتماد نهائي' : 'قيد الجودة',
        durationHours: 2,
        qualityGate: 'اعتماد الجودة النهائي',
      ),
      ProductStep(
        title: 'التغليف والخروج',
        description: 'تغليف المنتج وتسليمه لمنطقة الخروج أو الشحن الداخلي.',
        machine: 'Packing Line ${String.fromCharCode(65 + index)}',
        operator: 'فريق التغليف',
        progress: (baseCompletion - 0.38).clamp(0.0, 0.86).toDouble(),
        status: baseCompletion > 0.98 ? 'اكتمل' : 'مجدولة',
        durationHours: 2,
        qualityGate: 'مطابقة التغليف والباركود',
      ),
    ];

    final machines = [
      MachineInfo(
        name: 'Cutter-X${index + 1}',
        model: 'CUT-${430 + index}',
        currentProduct: name,
        efficiency: (baseCompletion + 0.08).clamp(0.45, 0.97).toDouble(),
        temperature: 40 + index * 2,
        status: 'تشغيل',
        operatingHours: 6.5 + index,
        queueCount: 2 + index,
        maintenanceNote: 'مراجعة سكاكين القص نهاية الوردية.',
      ),
      MachineInfo(
        name: 'CNC-${12 + index}',
        model: 'CNC-PRO-${index + 1}',
        currentProduct: name,
        efficiency: (baseCompletion - 0.03).clamp(0.4, 0.94).toDouble(),
        temperature: 52 + index * 3,
        status: baseCompletion > 0.68 ? 'تشغيل' : 'متابعة',
        operatingHours: 8.0 + index,
        queueCount: 3,
        maintenanceNote: 'متابعة الاهتزاز وتغيير زيت التبريد بعد الشيفت.',
      ),
      MachineInfo(
        name: 'Quality Desk ${index + 1}',
        model: 'Q-${220 + index}',
        currentProduct: name,
        efficiency: (baseCompletion + 0.04).clamp(0.48, 0.98).toDouble(),
        temperature: 29 + index,
        status: 'متابعة جودة',
        operatingHours: 4.5 + index,
        queueCount: 1,
        maintenanceNote: 'معايرة الحساسات قبل دفعة الغد.',
      ),
    ];

    return ProductJourney(
      name: name,
      sku: 'PRD-${point.label}${index + 101}',
      rawMaterial: raw,
      output: output,
      supervisor: supervisor,
      currentStage: steps[2].title,
      currentMachine: steps[2].machine,
      qualityRate: (0.78 + index * 0.03).clamp(0.0, 0.98).toDouble(),
      actual: point.actual,
      target: point.target,
      steps: steps,
      machines: machines,
    );
  });
}

String formatQuantity(double value) {
  if (value % 1 == 0) {
    return value.toInt().toString();
  }
  return value.toStringAsFixed(1);
}

String formatPercent(double value) => '${(value * 100).round()}%';
