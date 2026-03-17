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
    required this.themePreference,
    required this.textScale,
    required this.notificationsEnabled,
    required this.storagePermissionEnabled,
    required this.cameraPermissionEnabled,
    required this.reportsPermissionEnabled,
    required this.setTab,
    required this.setShift,
    required this.setThemePreference,
    required this.setTextScale,
    required this.togglePermission,
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
  final AppThemePreference themePreference;
  final AppTextScale textScale;
  final bool notificationsEnabled;
  final bool storagePermissionEnabled;
  final bool cameraPermissionEnabled;
  final bool reportsPermissionEnabled;
  final ValueChanged<DashboardTab> setTab;
  final ValueChanged<ShiftType> setShift;
  final ValueChanged<AppThemePreference> setThemePreference;
  final ValueChanged<AppTextScale> setTextScale;
  final ValueChanged<SystemPermission> togglePermission;

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
      themePreference: state.themePreference,
      textScale: state.textScale,
      notificationsEnabled: state.notificationsEnabled,
      storagePermissionEnabled: state.storagePermissionEnabled,
      cameraPermissionEnabled: state.cameraPermissionEnabled,
      reportsPermissionEnabled: state.reportsPermissionEnabled,
      setTab: (tab) => store.dispatch(SetDashboardTabAction(tab)),
      setShift: (shift) => store.dispatch(SetShiftAction(shift)),
      setThemePreference: (theme) => store.dispatch(SetThemePreferenceAction(theme)),
      setTextScale: (scale) => store.dispatch(SetTextScaleAction(scale)),
      togglePermission: (permission) => store.dispatch(ToggleSystemPermissionAction(permission)),
    );
  }
}
