import 'package:m_shop/models/production.dart';
import 'package:m_shop/models/task.dart';
import 'package:m_shop/models/user.dart';

class ApiService {
  Future<List<ProductionModel>> fetchProduction() async {
    return const [
      ProductionModel(label: 'س', actual: 72, target: 76),
      ProductionModel(label: 'ح', actual: 84, target: 79),
      ProductionModel(label: 'ن', actual: 78, target: 82),
      ProductionModel(label: 'ث', actual: 91, target: 84),
      ProductionModel(label: 'ر', actual: 88, target: 86),
      ProductionModel(label: 'خ', actual: 96, target: 90),
    ];
  }

  Future<List<TaskModel>> fetchTasks() async {
    return const [
      TaskModel(
        title: 'فحص خط التعبئة',
        description: 'مراجعة الحساسات وخط التغليف.',
        status: TaskStatus.inProgress,
        progress: 0.6,
      ),
      TaskModel(
        title: 'صيانة وقائية للآلة CNC-12',
        description: 'استبدال القطع المعرضة للاهتزاز.',
        status: TaskStatus.pending,
        progress: 0.2,
      ),
    ];
  }

  Future<List<AppUser>> fetchEmployees() async {
    return const [
      AppUser(name: 'أحمد علي', email: 'ahmed@factory.com', role: 'Supervisor'),
      AppUser(name: 'سارة محمد', email: 'sara@factory.com', role: 'Worker'),
      AppUser(name: 'يوسف خالد', email: 'yousef@factory.com', role: 'Worker'),
    ];
  }
}
