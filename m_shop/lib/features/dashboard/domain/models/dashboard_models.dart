class UserModel {
  const UserModel({
    required this.name,
    required this.email,
    required this.role,
    required this.status,
  });

  final String name;
  final String email;
  final String role;
  final String status;
}

class AttendanceRecord {
  const AttendanceRecord({
    required this.name,
    required this.checkIn,
    required this.checkOut,
    required this.workedHours,
    required this.present,
  });

  final String name;
  final String checkIn;
  final String checkOut;
  final double workedHours;
  final bool present;
}

class TaskModel {
  const TaskModel({
    required this.title,
    required this.description,
    required this.progress,
    required this.assignedTo,
    required this.status,
    required this.dueDate,
  });

  final String title;
  final String description;
  final double progress;
  final String assignedTo;
  final String status;
  final String dueDate;
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

class InventoryItem {
  const InventoryItem({
    required this.name,
    required this.quantity,
    required this.minimum,
    required this.unit,
  });

  final String name;
  final int quantity;
  final int minimum;
  final String unit;
}

class FinancialReport {
  const FinancialReport({
    required this.period,
    required this.income,
    required this.expenses,
    required this.profit,
  });

  final String period;
  final double income;
  final double expenses;
  final double profit;
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
