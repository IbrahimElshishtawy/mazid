class EmployeeModel {
  const EmployeeModel({
    required this.name,
    required this.role,
    required this.efficiency,
  });

  final String name;
  final String role;
  final int efficiency;
}

class TaskModel {
  const TaskModel({
    required this.title,
    required this.description,
    required this.progress,
  });

  final String title;
  final String description;
  final double progress;
}

class ProductionPoint {
  const ProductionPoint({
    required this.label,
    required this.actual,
    required this.target,
  });

  final String label;
  final double actual;
  final double target;
}

class AlertModel {
  const AlertModel({
    required this.title,
    required this.description,
    required this.colorHex,
  });

  final String title;
  final String description;
  final int colorHex;
}
