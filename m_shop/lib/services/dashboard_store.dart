import 'package:m_shop/models/production.dart';
import 'package:m_shop/models/task.dart';
import 'package:m_shop/models/user.dart';
import 'package:m_shop/services/api_service.dart';
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
  });

  final DashboardTab tab;
  final ShiftType shift;
  final List<ProductionModel> production;
  final List<TaskModel> tasks;
  final List<AppUser> employees;

  DashboardState copyWith({
    DashboardTab? tab,
    ShiftType? shift,
    List<ProductionModel>? production,
    List<TaskModel>? tasks,
    List<AppUser>? employees,
  }) {
    return DashboardState(
      tab: tab ?? this.tab,
      shift: shift ?? this.shift,
      production: production ?? this.production,
      tasks: tasks ?? this.tasks,
      employees: employees ?? this.employees,
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
  final api = ApiService();
  return Store<DashboardState>(
    dashboardReducer,
    initialState: DashboardState(
      tab: DashboardTab.overview,
      shift: ShiftType.evening,
      production: await api.fetchProduction(),
      tasks: await api.fetchTasks(),
      employees: await api.fetchEmployees(),
    ),
  );
}
