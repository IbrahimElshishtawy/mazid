enum TaskStatus { pending, inProgress, completed }

class TaskModel {
  const TaskModel({
    required this.title,
    required this.description,
    required this.status,
    required this.progress,
  });

  final String title;
  final String description;
  final TaskStatus status;
  final double progress;
}
