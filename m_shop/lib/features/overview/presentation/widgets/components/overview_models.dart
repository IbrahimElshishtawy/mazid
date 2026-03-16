import 'dart:math' as math;

import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class OverviewSummary {
  const OverviewSummary({
    required this.workersOnShift,
    required this.presentWorkers,
    required this.machineEfficiency,
    required this.totalProfit,
    required this.totalLosses,
    required this.totalPayroll,
    required this.totalDeductions,
    required this.cameraCoverage,
    required this.activeAlerts,
    required this.maintenanceReadiness,
  });

  factory OverviewSummary.fromData({
    required List<UserModel> users,
    required List<AttendanceRecord> attendance,
    required List<ProductionPoint> production,
    required List<TaskModel> tasks,
    required List<InventoryItem> inventory,
    required List<FinancialReport> financialReports,
    required List<AlertModel> alerts,
  }) {
    final workersOnShift = users
        .where(
          (user) =>
              user.status.contains('نشط') || user.status.contains('وردية'),
        )
        .length;
    final presentWorkers = attendance.where((record) => record.present).length;
    final totalActual = production.fold<double>(
      0,
      (sum, point) => sum + point.actual,
    );
    final totalTarget = production.fold<double>(
      0,
      (sum, point) => sum + point.target,
    );
    final machineEfficiency = totalTarget == 0
        ? 0.0
        : totalActual / totalTarget;
    final totalProfit = financialReports.fold<double>(
      0,
      (sum, report) => sum + report.profit,
    );
    final totalExpenses = financialReports.fold<double>(
      0,
      (sum, report) => sum + report.expenses,
    );
    final totalLosses = totalExpenses * 0.09;
    final totalPayroll = attendance.fold<double>(
      0,
      (sum, record) => sum + (record.workedHours * 85),
    );
    final totalDeductions = tasks.fold<double>(
      0,
      (sum, task) => sum + _taskDeduction(task),
    );
    final cameraCoverage =
        ((alerts.length + users.length) / math.max(1, users.length + 5))
            .clamp(0.0, 1.0)
            .toDouble();
    final activeAlerts = alerts.length;
    final maintenanceReadiness =
        (1 -
                (tasks.where((task) => task.title.contains('صيانة')).length /
                    math.max(1, tasks.length)))
            .clamp(0.0, 1.0)
            .toDouble();

    return OverviewSummary(
      workersOnShift: workersOnShift,
      presentWorkers: presentWorkers,
      machineEfficiency: machineEfficiency,
      totalProfit: totalProfit,
      totalLosses: totalLosses,
      totalPayroll: totalPayroll,
      totalDeductions: totalDeductions,
      cameraCoverage: cameraCoverage,
      activeAlerts: activeAlerts,
      maintenanceReadiness: maintenanceReadiness,
    );
  }

  final int workersOnShift;
  final int presentWorkers;
  final double machineEfficiency;
  final double totalProfit;
  final double totalLosses;
  final double totalPayroll;
  final double totalDeductions;
  final double cameraCoverage;
  final int activeAlerts;
  final double maintenanceReadiness;

  String get factoryState {
    if (machineEfficiency >= 0.95 && activeAlerts <= 1) {
      return 'تحت السيطرة';
    }
    if (machineEfficiency >= 0.8) {
      return 'مستقر';
    }
    return 'يحتاج تدخل';
  }

  static double _taskDeduction(TaskModel task) {
    if (task.progress < 0.25) {
      return 120;
    }
    if (task.progress < 0.4) {
      return 60;
    }
    return 0;
  }
}

class OverviewLayout {
  const OverviewLayout({
    required this.metricWidth,
    required this.primaryWidth,
    required this.secondaryWidth,
  });

  factory OverviewLayout.fromWidth(double width) {
    if (width > 1200) {
      return const OverviewLayout(
        metricWidth: 248,
        primaryWidth: 720,
        secondaryWidth: 320,
      );
    }
    if (width > 860) {
      return const OverviewLayout(
        metricWidth: 220,
        primaryWidth: 520,
        secondaryWidth: 280,
      );
    }
    final panel = math.max(280.0, width - 92).toDouble();
    return OverviewLayout(
      metricWidth: panel,
      primaryWidth: panel,
      secondaryWidth: panel,
    );
  }

  final double metricWidth;
  final double primaryWidth;
  final double secondaryWidth;
}

class CameraPoint {
  const CameraPoint({
    required this.name,
    required this.coverage,
    required this.online,
  });

  final String name;
  final double coverage;
  final bool online;
}

class PayrollPoint {
  const PayrollPoint({
    required this.name,
    required this.salary,
    required this.deduction,
  });

  final String name;
  final double salary;
  final double deduction;
}

List<CameraPoint> buildCameraPoints(List<AlertModel> alerts) {
  return [
    CameraPoint(name: 'كاميرا البوابة', coverage: 0.96, online: true),
    CameraPoint(
      name: 'كاميرا خط A',
      coverage: alerts.any((a) => a.title.contains('الخط B')) ? 0.72 : 0.91,
      online: true,
    ),
    CameraPoint(name: 'كاميرا المخزن', coverage: 0.88, online: true),
    CameraPoint(
      name: 'كاميرا الجودة',
      coverage: 0.64,
      online: alerts.length < 4,
    ),
  ];
}

List<PayrollPoint> buildPayrollPoints(List<AttendanceRecord> attendance) {
  return attendance
      .map(
        (record) => PayrollPoint(
          name: record.name,
          salary: record.workedHours * 85,
          deduction: record.present ? (record.workedHours < 7.9 ? 25 : 0) : 90,
        ),
      )
      .toList();
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
