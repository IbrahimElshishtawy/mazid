import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class WorkerProfile {
  const WorkerProfile({
    required this.user,
    required this.workArea,
    required this.salary,
    required this.permissionLevel,
    required this.shift,
    required this.performance,
    required this.tasksHandled,
    required this.canApprove,
  });

  final UserModel user;
  final String workArea;
  final double salary;
  final String permissionLevel;
  final String shift;
  final double performance;
  final int tasksHandled;
  final bool canApprove;

  Color get accent {
    if (permissionLevel.contains('كاملة')) return const Color(0xFF7C3AED);
    if (performance >= 0.85) return const Color(0xFF16A34A);
    if (user.status.contains('استراحة')) return const Color(0xFFF59E0B);
    return const Color(0xFF0F766E);
  }

  WorkerProfile copyWith({
    UserModel? user,
    String? workArea,
    double? salary,
    String? permissionLevel,
    String? shift,
    double? performance,
    int? tasksHandled,
    bool? canApprove,
  }) {
    return WorkerProfile(
      user: user ?? this.user,
      workArea: workArea ?? this.workArea,
      salary: salary ?? this.salary,
      permissionLevel: permissionLevel ?? this.permissionLevel,
      shift: shift ?? this.shift,
      performance: performance ?? this.performance,
      tasksHandled: tasksHandled ?? this.tasksHandled,
      canApprove: canApprove ?? this.canApprove,
    );
  }
}

class UsersSummary {
  const UsersSummary({
    required this.totalUsers,
    required this.activeUsers,
    required this.supervisors,
    required this.averageSalary,
    required this.approvers,
    required this.averagePerformance,
  });

  factory UsersSummary.fromProfiles(List<WorkerProfile> profiles) {
    final activeUsers = profiles.where((profile) => profile.user.status.contains('نشط') || profile.user.status.contains('وردية')).length;
    final supervisors = profiles.where((profile) => profile.user.role.toLowerCase().contains('supervisor') || profile.user.role.contains('مدير') || profile.user.role.contains('مشرف')).length;
    final averageSalary = profiles.isEmpty ? 0.0 : profiles.fold<double>(0, (sum, item) => sum + item.salary) / profiles.length;
    final approvers = profiles.where((profile) => profile.canApprove).length;
    final averagePerformance = profiles.isEmpty ? 0.0 : profiles.fold<double>(0, (sum, item) => sum + item.performance) / profiles.length;
    return UsersSummary(
      totalUsers: profiles.length,
      activeUsers: activeUsers,
      supervisors: supervisors,
      averageSalary: averageSalary,
      approvers: approvers,
      averagePerformance: averagePerformance,
    );
  }

  final int totalUsers;
  final int activeUsers;
  final int supervisors;
  final double averageSalary;
  final int approvers;
  final double averagePerformance;

  String get controlState {
    if (averagePerformance >= 0.88 && activeUsers >= math.max(1, totalUsers - 1)) return 'سيطرة قوية على الفريق';
    if (averagePerformance >= 0.72) return 'إدارة مستقرة';
    return 'تحتاج ضبط الصلاحيات والتوزيع';
  }
}

class UsersLayout {
  const UsersLayout({required this.metricWidth, required this.primaryWidth, required this.secondaryWidth});

  factory UsersLayout.fromWidth(double width) {
    if (width > 1220) {
      return const UsersLayout(metricWidth: 248, primaryWidth: 720, secondaryWidth: 340);
    }
    if (width > 900) {
      return const UsersLayout(metricWidth: 220, primaryWidth: 540, secondaryWidth: 300);
    }
    final panel = math.max(280.0, width - 92).toDouble();
    return UsersLayout(metricWidth: panel, primaryWidth: panel, secondaryWidth: panel);
  }

  final double metricWidth;
  final double primaryWidth;
  final double secondaryWidth;
}

List<WorkerProfile> buildWorkerProfiles(List<UserModel> users) {
  const workAreas = ['خط القص', 'خط التجميع', 'الفحص والجودة', 'المخزن', 'التغليف', 'غرفة التحكم'];
  const permissions = ['صلاحيات تشغيل', 'صلاحيات متابعة', 'صلاحيات اعتماد', 'صلاحيات كاملة'];
  const shifts = ['صباحية', 'مسائية', 'ليلية'];
  return List<WorkerProfile>.generate(users.length, (index) {
    final user = users[index];
    return WorkerProfile(
      user: user,
      workArea: workAreas[index % workAreas.length],
      salary: 4200 + (index * 650).toDouble(),
      permissionLevel: permissions[index % permissions.length],
      shift: shifts[index % shifts.length],
      performance: (0.66 + (index * 0.07)).clamp(0.0, 0.97).toDouble(),
      tasksHandled: 8 + (index * 3),
      canApprove: index % 2 == 0 || user.role.toLowerCase().contains('manager'),
    );
  });
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

String formatPercent(double value) => '${(value * 100).round()}%';
