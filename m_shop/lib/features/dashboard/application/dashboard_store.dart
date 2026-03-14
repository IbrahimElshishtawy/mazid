import 'package:m_shop/features/dashboard/data/dashboard_seed.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:redux/redux.dart';

enum DashboardTab { overview, operations, teams }
enum ShiftType { morning, evening, night }

class DashboardState {
  const DashboardState({
    required this.tab,
    required this.shift,
    required this.production,
    required this.tasks,
    required this.employees,
    required this.alerts,
  });

  final DashboardTab tab;
  final ShiftType shift;
  final List<ProductionPoint> production;
  final List<TaskModel> tasks;
  final List<EmployeeModel> employees;
  final List<AlertModel> alerts;

  DashboardState copyWith({
    DashboardTab? tab,
    ShiftType? shift,
  }) {
    return DashboardState(
      tab: tab ?? this.tab,
      shift: shift ?? this.shift,
      production: production,
      tasks: tasks,
      employees: employees,
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
  return Store<DashboardState>(
    dashboardReducer,
    initialState: const DashboardState(
      tab: DashboardTab.overview,
      shift: ShiftType.evening,
      production: DashboardSeed.production,
      tasks: DashboardSeed.tasks,
      employees: DashboardSeed.employees,
      alerts: DashboardSeed.alerts,
    ),
  );
}
