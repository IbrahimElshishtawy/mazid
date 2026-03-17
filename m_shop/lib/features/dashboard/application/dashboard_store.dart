import 'package:m_shop/features/dashboard/data/dashboard_seed.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:redux/redux.dart';

enum DashboardTab {
  overview,
  profile,
  users,
  attendance,
  productivity,
  results,
  tasks,
  inventory,
  finance,
  settings,
}

enum ShiftType { morning, evening, night }

enum AppThemePreference { light, dark }

enum AppTextScale { compact, normal, large }

enum SystemPermission { notifications, storage, camera, reports }

class DashboardState {
  DashboardState({
    required this.tab,
    required this.shift,
    required this.users,
    required this.attendance,
    required this.production,
    required this.tasks,
    required this.inventory,
    required this.financialReports,
    required this.alerts,
    AppThemePreference? themePreference,
    AppTextScale? textScale,
    bool? notificationsEnabled,
    bool? storagePermissionEnabled,
    bool? cameraPermissionEnabled,
    bool? reportsPermissionEnabled,
  })  : _themePreference = themePreference,
        _textScale = textScale,
        _notificationsEnabled = notificationsEnabled,
        _storagePermissionEnabled = storagePermissionEnabled,
        _cameraPermissionEnabled = cameraPermissionEnabled,
        _reportsPermissionEnabled = reportsPermissionEnabled;

  final DashboardTab tab;
  final ShiftType shift;
  final List<UserModel> users;
  List<UserModel> get employees => users;
  final List<AttendanceRecord> attendance;
  final List<ProductionPoint> production;
  final List<TaskModel> tasks;
  final List<InventoryItem> inventory;
  final List<FinancialReport> financialReports;
  final List<AlertModel> alerts;

  final AppThemePreference? _themePreference;
  final AppTextScale? _textScale;
  final bool? _notificationsEnabled;
  final bool? _storagePermissionEnabled;
  final bool? _cameraPermissionEnabled;
  final bool? _reportsPermissionEnabled;

  AppThemePreference get themePreference => _themePreference ?? AppThemePreference.light;
  AppTextScale get textScale => _textScale ?? AppTextScale.normal;
  bool get notificationsEnabled => _notificationsEnabled ?? true;
  bool get storagePermissionEnabled => _storagePermissionEnabled ?? true;
  bool get cameraPermissionEnabled => _cameraPermissionEnabled ?? true;
  bool get reportsPermissionEnabled => _reportsPermissionEnabled ?? false;

  DashboardState copyWith({
    DashboardTab? tab,
    ShiftType? shift,
    AppThemePreference? themePreference,
    AppTextScale? textScale,
    bool? notificationsEnabled,
    bool? storagePermissionEnabled,
    bool? cameraPermissionEnabled,
    bool? reportsPermissionEnabled,
  }) {
    return DashboardState(
      tab: tab ?? this.tab,
      shift: shift ?? this.shift,
      users: users,
      attendance: attendance,
      production: production,
      tasks: tasks,
      inventory: inventory,
      financialReports: financialReports,
      alerts: alerts,
      themePreference: themePreference ?? this.themePreference,
      textScale: textScale ?? this.textScale,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      storagePermissionEnabled: storagePermissionEnabled ?? this.storagePermissionEnabled,
      cameraPermissionEnabled: cameraPermissionEnabled ?? this.cameraPermissionEnabled,
      reportsPermissionEnabled: reportsPermissionEnabled ?? this.reportsPermissionEnabled,
    );
  }
}

class SetDashboardTabAction {
  const SetDashboardTabAction(this.tab);

  final DashboardTab tab;
}

class SetShiftAction {
  const SetShiftAction(this.shift);

  final ShiftType shift;
}

class SetThemePreferenceAction {
  const SetThemePreferenceAction(this.themePreference);

  final AppThemePreference themePreference;
}

class SetTextScaleAction {
  const SetTextScaleAction(this.textScale);

  final AppTextScale textScale;
}

class ToggleSystemPermissionAction {
  const ToggleSystemPermissionAction(this.permission);

  final SystemPermission permission;
}

DashboardState dashboardReducer(DashboardState state, dynamic action) {
  if (action is SetDashboardTabAction) {
    return state.copyWith(tab: action.tab);
  }

  if (action is SetShiftAction) {
    return state.copyWith(shift: action.shift);
  }

  if (action is SetThemePreferenceAction) {
    return state.copyWith(themePreference: action.themePreference);
  }

  if (action is SetTextScaleAction) {
    return state.copyWith(textScale: action.textScale);
  }

  if (action is ToggleSystemPermissionAction) {
    switch (action.permission) {
      case SystemPermission.notifications:
        return state.copyWith(notificationsEnabled: state.notificationsEnabled == false);
      case SystemPermission.storage:
        return state.copyWith(storagePermissionEnabled: state.storagePermissionEnabled == false);
      case SystemPermission.camera:
        return state.copyWith(cameraPermissionEnabled: state.cameraPermissionEnabled == false);
      case SystemPermission.reports:
        return state.copyWith(reportsPermissionEnabled: state.reportsPermissionEnabled == false);
    }
  }

  return state;
}

Future<Store<DashboardState>> createDashboardStore() async {
  final initialState = DashboardState(
    tab: DashboardTab.overview,
    shift: ShiftType.evening,
    users: DashboardSeed.users,
    attendance: DashboardSeed.attendance,
    production: DashboardSeed.production,
    tasks: DashboardSeed.tasks,
    inventory: DashboardSeed.inventory,
    financialReports: DashboardSeed.financialReports,
    alerts: DashboardSeed.alerts,
    themePreference: AppThemePreference.light,
    textScale: AppTextScale.normal,
    notificationsEnabled: true,
    storagePermissionEnabled: true,
    cameraPermissionEnabled: true,
    reportsPermissionEnabled: false,
  );

  return Store<DashboardState>(
    dashboardReducer,
    initialState: initialState,
  );
}
