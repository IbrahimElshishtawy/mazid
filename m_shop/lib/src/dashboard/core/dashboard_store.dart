import 'package:redux/redux.dart';

enum ShiftType { morning, evening, night }

enum DashboardSection { overview, operations, teams }

enum MachineHealth { active, review, maintenance }

enum AlertSeverity { critical, warning, positive }

class ShiftSnapshot {
  const ShiftSnapshot({
    required this.productionUnits,
    required this.completedTasks,
    required this.totalTasks,
    required this.defectRate,
    required this.attendanceRate,
    required this.workersPresent,
    required this.lineEfficiency,
    required this.targetDelta,
  });

  final int productionUnits;
  final int completedTasks;
  final int totalTasks;
  final double defectRate;
  final double attendanceRate;
  final int workersPresent;
  final double lineEfficiency;
  final double targetDelta;
}

class MetricCardModel {
  const MetricCardModel({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.trendLabel,
    required this.trendUp,
    this.trendGood = true,
  });

  final String title;
  final String value;
  final String subtitle;
  final String trendLabel;
  final bool trendUp;
  final bool trendGood;
}

class MachineStatusModel {
  const MachineStatusModel({
    required this.name,
    required this.status,
    required this.progress,
    required this.health,
  });

  final String name;
  final String status;
  final double progress;
  final MachineHealth health;
}

class AlertModel {
  const AlertModel({
    required this.title,
    required this.description,
    required this.severity,
  });

  final String title;
  final String description;
  final AlertSeverity severity;
}

class TeamPerformanceModel {
  const TeamPerformanceModel({
    required this.name,
    required this.score,
    required this.tasks,
  });

  final String name;
  final int score;
  final int tasks;
}

class EnvironmentMetric {
  const EnvironmentMetric({
    required this.label,
    required this.value,
    required this.unit,
    required this.progress,
    required this.statusLabel,
  });

  final String label;
  final double value;
  final String unit;
  final double progress;
  final String statusLabel;
}

class DashboardState {
  const DashboardState({
    required this.selectedShift,
    required this.selectedSection,
    required this.shiftSnapshots,
    required this.machines,
    required this.alerts,
    required this.teams,
    required this.environment,
    required this.chartActuals,
    required this.chartTargets,
    required this.chartLabels,
    required this.forecastValue,
  });

  final ShiftType selectedShift;
  final DashboardSection selectedSection;
  final Map<ShiftType, ShiftSnapshot> shiftSnapshots;
  final List<MachineStatusModel> machines;
  final List<AlertModel> alerts;
  final List<TeamPerformanceModel> teams;
  final List<EnvironmentMetric> environment;
  final List<double> chartActuals;
  final List<double> chartTargets;
  final List<String> chartLabels;
  final double forecastValue;

  ShiftSnapshot get currentSnapshot => shiftSnapshots[selectedShift]!;

  List<MetricCardModel> get metricCards {
    final snapshot = currentSnapshot;
    return [
      MetricCardModel(
        title: 'الإنتاج اليومي',
        value: '${snapshot.productionUnits}',
        subtitle: 'وحدة مكتملة',
        trendLabel: _percentLabel(snapshot.targetDelta),
        trendUp: snapshot.targetDelta >= 0,
      ),
      MetricCardModel(
        title: 'المهام المنجزة',
        value: '${snapshot.completedTasks}',
        subtitle: 'من أصل ${snapshot.totalTasks}',
        trendLabel: '+8%',
        trendUp: true,
      ),
      MetricCardModel(
        title: 'نسبة العيوب',
        value: '${snapshot.defectRate.toStringAsFixed(1)}%',
        subtitle: 'أقل من الحد المسموح',
        trendLabel: '-0.6%',
        trendUp: false,
        trendGood: true,
      ),
      MetricCardModel(
        title: 'الحضور',
        value: '${(snapshot.attendanceRate * 100).round()}%',
        subtitle: '${snapshot.workersPresent} عامل حاضر',
        trendLabel: '+3%',
        trendUp: true,
      ),
    ];
  }

  DashboardState copyWith({
    ShiftType? selectedShift,
    DashboardSection? selectedSection,
  }) {
    return DashboardState(
      selectedShift: selectedShift ?? this.selectedShift,
      selectedSection: selectedSection ?? this.selectedSection,
      shiftSnapshots: shiftSnapshots,
      machines: machines,
      alerts: alerts,
      teams: teams,
      environment: environment,
      chartActuals: chartActuals,
      chartTargets: chartTargets,
      chartLabels: chartLabels,
      forecastValue: forecastValue,
    );
  }

  static String _percentLabel(double value) {
    final sign = value >= 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(0)}%';
  }
}

class SetShiftAction {
  const SetShiftAction(this.shift);

  final ShiftType shift;
}

class SetSectionAction {
  const SetSectionAction(this.section);

  final DashboardSection section;
}

DashboardState dashboardReducer(DashboardState state, dynamic action) {
  if (action is SetShiftAction) {
    return state.copyWith(selectedShift: action.shift);
  }

  if (action is SetSectionAction) {
    return state.copyWith(selectedSection: action.section);
  }

  return state;
}

Store<DashboardState> createDashboardStore() {
  return Store<DashboardState>(
    dashboardReducer,
    initialState: DashboardSeed.initialState,
  );
}

abstract final class DashboardSeed {
  static const Map<ShiftType, ShiftSnapshot> snapshots = {
    ShiftType.morning: ShiftSnapshot(
      productionUnits: 2100,
      completedTasks: 162,
      totalTasks: 201,
      defectRate: 2.3,
      attendanceRate: 0.91,
      workersPresent: 124,
      lineEfficiency: 0.82,
      targetDelta: 7,
    ),
    ShiftType.evening: ShiftSnapshot(
      productionUnits: 2480,
      completedTasks: 186,
      totalTasks: 214,
      defectRate: 1.8,
      attendanceRate: 0.94,
      workersPresent: 128,
      lineEfficiency: 0.86,
      targetDelta: 12,
    ),
    ShiftType.night: ShiftSnapshot(
      productionUnits: 1890,
      completedTasks: 138,
      totalTasks: 175,
      defectRate: 2.1,
      attendanceRate: 0.88,
      workersPresent: 119,
      lineEfficiency: 0.78,
      targetDelta: 5,
    ),
  };

  static const List<MachineStatusModel> machines = [
    MachineStatusModel(
      name: 'CNC-12',
      status: 'جاهزة للعمل',
      progress: 0.86,
      health: MachineHealth.active,
    ),
    MachineStatusModel(
      name: 'Line-A3',
      status: 'تحت المراجعة',
      progress: 0.48,
      health: MachineHealth.review,
    ),
    MachineStatusModel(
      name: 'Press-07',
      status: 'قيد الصيانة',
      progress: 0.22,
      health: MachineHealth.maintenance,
    ),
    MachineStatusModel(
      name: 'Pack-19',
      status: 'إنتاج نشط',
      progress: 0.91,
      health: MachineHealth.active,
    ),
  ];

  static const List<AlertModel> alerts = [
    AlertModel(
      title: 'انخفاض سرعة الخط B',
      description: 'تم رصد تراجع 14% خلال آخر 20 دقيقة ويوصى بمراجعة وحدة التغذية فورًا.',
      severity: AlertSeverity.critical,
    ),
    AlertModel(
      title: 'جدولة صيانة وقائية',
      description: 'الآلة CNC-12 ستصل إلى حد الاهتزاز المتوقع خلال 36 ساعة.',
      severity: AlertSeverity.warning,
    ),
    AlertModel(
      title: 'فريق التغليف تجاوز الهدف',
      description: 'الفريق المسائي حقق 108% من المستهدف ويمكن رفع الحصة التالية.',
      severity: AlertSeverity.positive,
    ),
  ];

  static const List<TeamPerformanceModel> teams = [
    TeamPerformanceModel(name: 'الوردية الصباحية', score: 92, tasks: 74),
    TeamPerformanceModel(name: 'الوردية المسائية', score: 87, tasks: 63),
    TeamPerformanceModel(name: 'فريق التغليف', score: 95, tasks: 49),
    TeamPerformanceModel(name: 'فريق الصيانة', score: 81, tasks: 28),
  ];

  static const List<EnvironmentMetric> environment = [
    EnvironmentMetric(
      label: 'الحرارة',
      value: 24,
      unit: '°C',
      progress: 0.64,
      statusLabel: 'طبيعي',
    ),
    EnvironmentMetric(
      label: 'الرطوبة',
      value: 46,
      unit: '%',
      progress: 0.46,
      statusLabel: 'مستقر',
    ),
    EnvironmentMetric(
      label: 'جودة الهواء',
      value: 92,
      unit: 'AQI',
      progress: 0.78,
      statusLabel: 'جيد',
    ),
  ];

  static const DashboardState initialState = DashboardState(
    selectedShift: ShiftType.evening,
    selectedSection: DashboardSection.overview,
    shiftSnapshots: snapshots,
    machines: machines,
    alerts: alerts,
    teams: teams,
    environment: environment,
    chartActuals: [72, 84, 78, 91, 88, 96],
    chartTargets: [76, 79, 82, 84, 86, 90],
    chartLabels: ['س', 'ح', 'ن', 'ث', 'ر', 'خ', 'توقع'],
    forecastValue: 104,
  );
}
