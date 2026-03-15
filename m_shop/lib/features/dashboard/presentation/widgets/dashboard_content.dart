import 'package:flutter/material.dart';
import 'package:m_shop/features/dashboard/application/dashboard_store.dart';
import 'package:m_shop/features/dashboard/presentation/dashboard_vm.dart';
import 'package:m_shop/features/dashboard/presentation/widgets/sections/dashboard_sections.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key, required this.vm});

  final DashboardVm vm;

  @override
  Widget build(BuildContext context) {
    switch (vm.tab) {
      case DashboardTab.overview:
        return OverviewSection(alerts: vm.alerts);
      case DashboardTab.profile:
        return ProfileSection(user: vm.users.first, users: vm.users);
      case DashboardTab.users:
        return UsersSection(users: vm.users);
      case DashboardTab.attendance:
        return AttendanceSection(attendance: vm.attendance);
      case DashboardTab.productivity:
        return ProductivitySection(production: vm.production);
      case DashboardTab.results:
        return ResultsSection(production: vm.production, tasks: vm.tasks);
      case DashboardTab.tasks:
        return TasksSection(tasks: vm.tasks);
      case DashboardTab.inventory:
        return InventorySection(inventory: vm.inventory);
      case DashboardTab.finance:
        return FinanceSection(financialReports: vm.financialReports);
      case DashboardTab.settings:
        return const SettingsSection();
    }
  }
}

