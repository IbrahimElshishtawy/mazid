import 'package:flutter/material.dart';
import 'package:m_shop/features/dashboard/application/dashboard_store.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:redux/redux.dart';

class DashboardVm {
  const DashboardVm({
    required this.tab,
    required this.shift,
    required this.users,
    required this.attendance,
    required this.production,
    required this.tasks,
    required this.inventory,
    required this.financialReports,
    required this.alerts,
    required this.setTab,
    required this.setShift,
  });

  final DashboardTab tab;
  final ShiftType shift;
  final List<UserModel> users;
  final List<AttendanceRecord> attendance;
  final List<ProductionPoint> production;
  final List<TaskModel> tasks;
  final List<InventoryItem> inventory;
  final List<FinancialReport> financialReports;
  final List<AlertModel> alerts;
  final ValueChanged<DashboardTab> setTab;
  final ValueChanged<ShiftType> setShift;

  static DashboardVm fromStore(Store<DashboardState> store) {
    final state = store.state;
    return DashboardVm(
      tab: state.tab,
      shift: state.shift,
      users: state.users,
      attendance: state.attendance,
      production: state.production,
      tasks: state.tasks,
      inventory: state.inventory,
      financialReports: state.financialReports,
      alerts: state.alerts,
      setTab: (tab) => store.dispatch(SetDashboardTabAction(tab)),
      setShift: (shift) => store.dispatch(SetShiftAction(shift)),
    );
  }
}
