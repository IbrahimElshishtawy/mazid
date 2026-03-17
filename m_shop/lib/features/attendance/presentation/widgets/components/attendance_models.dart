import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:m_shop/features/attendance/presentation/widgets/components/attendance_formatters.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class AttendanceSummary {
  const AttendanceSummary({
    required this.presentCount,
    required this.absentCount,
    required this.lateCount,
    required this.onTimeCount,
    required this.averageHours,
    required this.totalDuePay,
    required this.plannedPayroll,
    required this.overtimeHours,
    required this.totalLateMinutes,
    required this.highestDuePay,
  });

  factory AttendanceSummary.fromWorkers(List<WorkerAttendanceProfile> workers) {
    final presentCount = workers.where((worker) => worker.record.present).length;
    final absentCount = workers.length - presentCount;
    final lateCount = workers.where((worker) => worker.lateMinutes > 0).length;
    final onTimeCount = workers.where((worker) => worker.record.present && worker.lateMinutes == 0).length;
    final averageHours = workers.isEmpty ? 0.0 : workers.fold<double>(0, (sum, worker) => sum + worker.record.workedHours) / workers.length;
    final totalDuePay = workers.fold<double>(0, (sum, worker) => sum + worker.duePay);
    final plannedPayroll = workers.fold<double>(0, (sum, worker) => sum + worker.plannedPay);
    final overtimeHours = workers.fold<double>(0, (sum, worker) => sum + worker.overtimeHours);
    final totalLateMinutes = workers.fold<int>(0, (sum, worker) => sum + worker.lateMinutes);
    final highestDuePay = workers.isEmpty ? 0.0 : workers.map((worker) => worker.duePay).reduce(math.max);

    return AttendanceSummary(
      presentCount: presentCount,
      absentCount: absentCount,
      lateCount: lateCount,
      onTimeCount: onTimeCount,
      averageHours: averageHours,
      totalDuePay: totalDuePay,
      plannedPayroll: plannedPayroll,
      overtimeHours: overtimeHours,
      totalLateMinutes: totalLateMinutes,
      highestDuePay: highestDuePay,
    );
  }

  final int presentCount;
  final int absentCount;
  final int lateCount;
  final int onTimeCount;
  final double averageHours;
  final double totalDuePay;
  final double plannedPayroll;
  final double overtimeHours;
  final int totalLateMinutes;
  final double highestDuePay;

  String get commitmentLabel {
    final total = presentCount + absentCount;
    if (total == 0) return '0%';
    return '${((presentCount / total) * 100).round()}%';
  }

  String get ownerNote {
    if (absentCount > 0) {
      return 'في غياب يحتاج متابعة';
    }
    if (lateCount > 0) {
      return 'التأخير يحتاج ضبط أكثر';
    }
    return 'الوضع مستقر اليوم';
  }
}

class WorkerAttendanceProfile {
  const WorkerAttendanceProfile({
    required this.record,
    required this.shiftLabel,
    required this.scheduleStart,
    required this.scheduleEnd,
    required this.hourlyRate,
    required this.lateMinutes,
    required this.overtimeHours,
    required this.plannedPay,
    required this.duePay,
    required this.commitmentRate,
    required this.commitmentLabel,
    required this.statusLabel,
    required this.note,
    required this.accent,
    required this.icon,
  });

  factory WorkerAttendanceProfile.fromRecord(AttendanceRecord record, int index) {
    final template = shiftTemplates[index % shiftTemplates.length];
    final actualCheckIn = timeToMinutes(record.checkIn);
    final scheduledStart = timeToMinutes(template.start) ?? 0;
    final lateMinutes = record.present ? math.max(0, (actualCheckIn ?? scheduledStart) - scheduledStart) : 0;
    final overtimeHours = math.max(0.0, record.workedHours - template.hours);
    final plannedPay = template.hours * template.hourlyRate;
    final baseHours = math.min(record.workedHours, template.hours);
    final duePay = record.present ? (baseHours * template.hourlyRate) + (overtimeHours * template.hourlyRate * 1.25) : 0.0;
    final commitmentRate = record.present ? (record.workedHours / template.hours).clamp(0.0, 1.0).toDouble() : 0.0;

    final Color accent;
    final IconData icon;
    final String statusLabel;
    final String note;

    if (record.present == false) {
      accent = const Color(0xFFDC2626);
      icon = Icons.person_off_rounded;
      statusLabel = 'غائب';
      note = 'العامل لم يسجل حضوراً لذلك الأجر المستحق صفر ويحتاج مراجعة.';
    } else if (lateMinutes > 0) {
      accent = const Color(0xFFF59E0B);
      icon = Icons.warning_amber_rounded;
      statusLabel = 'متأخر';
      note = 'حضر بعد موعد الوردية بـ ${formatAttendanceMinutes(lateMinutes)} والأجر مرتبط بالساعات الفعلية.';
    } else {
      accent = const Color(0xFF16A34A);
      icon = Icons.verified_rounded;
      statusLabel = 'منضبط';
      note = 'حضر في موعده ونفذ ورديته بصورة جيدة.';
    }

    return WorkerAttendanceProfile(
      record: record,
      shiftLabel: template.label,
      scheduleStart: template.start,
      scheduleEnd: template.end,
      hourlyRate: template.hourlyRate,
      lateMinutes: lateMinutes,
      overtimeHours: overtimeHours,
      plannedPay: plannedPay,
      duePay: duePay,
      commitmentRate: commitmentRate,
      commitmentLabel: '${(commitmentRate * 100).round()}%',
      statusLabel: statusLabel,
      note: note,
      accent: accent,
      icon: icon,
    );
  }

  final AttendanceRecord record;
  final String shiftLabel;
  final String scheduleStart;
  final String scheduleEnd;
  final double hourlyRate;
  final int lateMinutes;
  final double overtimeHours;
  final double plannedPay;
  final double duePay;
  final double commitmentRate;
  final String commitmentLabel;
  final String statusLabel;
  final String note;
  final Color accent;
  final IconData icon;
}

class ShiftTemplate {
  const ShiftTemplate({
    required this.label,
    required this.start,
    required this.end,
    required this.hours,
    required this.hourlyRate,
  });

  final String label;
  final String start;
  final String end;
  final double hours;
  final double hourlyRate;
}

const shiftTemplates = [
  ShiftTemplate(label: 'وردية التشغيل الصباحية', start: '08:00', end: '16:00', hours: 8, hourlyRate: 65),
  ShiftTemplate(label: 'وردية التعبئة والتجهيز', start: '08:15', end: '16:15', hours: 8, hourlyRate: 58),
  ShiftTemplate(label: 'وردية المراجعة والتجميع', start: '09:00', end: '17:00', hours: 8, hourlyRate: 61),
  ShiftTemplate(label: 'وردية الجودة والتسليم', start: '09:30', end: '17:30', hours: 8, hourlyRate: 63),
];
