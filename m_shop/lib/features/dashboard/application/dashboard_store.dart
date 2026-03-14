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
  });

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

  DashboardState copyWith({
    DashboardTab? tab,
    ShiftType? shift,
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

DashboardState dashboardReducer(DashboardState state, dynamic action) {
  if (action is SetDashboardTabAction) {
    return state.copyWith(tab: action.tab);
  }

  if (action is SetShiftAction) {
    return state.copyWith(shift: action.shift);
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
  );

  return Store<DashboardState>(
    dashboardReducer,
    initialState: initialState,
  );
}
