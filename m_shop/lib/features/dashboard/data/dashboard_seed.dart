import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

abstract final class DashboardSeed {
  static const production = [
    ProductionPoint(label: 'س', actual: 72, target: 76),
    ProductionPoint(label: 'ح', actual: 84, target: 79),
    ProductionPoint(label: 'ن', actual: 78, target: 82),
    ProductionPoint(label: 'ث', actual: 91, target: 84),
    ProductionPoint(label: 'ر', actual: 88, target: 86),
    ProductionPoint(label: 'خ', actual: 96, target: 90),
  ];

  static const tasks = [
    TaskModel(
      title: 'فحص خط التعبئة',
      description: 'مراجعة الحساسات ووحدة التغذية قبل الوردية التالية.',
      progress: 0.62,
    ),
    TaskModel(
      title: 'صيانة وقائية للآلة CNC-12',
      description: 'استبدال القطع المعرضة للاهتزاز وتأكيد الضبط النهائي.',
      progress: 0.24,
    ),
    TaskModel(
      title: 'مراجعة جودة التغليف',
      description: 'مطابقة التغليف مع آخر متطلبات قسم الجودة.',
      progress: 0.84,
    ),
  ];

  static const employees = [
    EmployeeModel(name: 'أحمد علي', role: 'Supervisor', efficiency: 95),
    EmployeeModel(name: 'سارة محمد', role: 'Worker', efficiency: 88),
    EmployeeModel(name: 'يوسف خالد', role: 'Worker', efficiency: 91),
  ];

  static const alerts = [
    AlertModel(
      title: 'انخفاض سرعة الخط B',
      description: 'تم رصد تراجع 14% خلال آخر 20 دقيقة ويوصى بالمراجعة السريعة.',
      colorHex: 0xFFDC2626,
    ),
    AlertModel(
      title: 'جدولة صيانة وقائية',
      description: 'الآلة CNC-12 ستصل إلى حد الاهتزاز المتوقع خلال 36 ساعة.',
      colorHex: 0xFFF59E0B,
    ),
    AlertModel(
      title: 'فريق التغليف فوق المستهدف',
      description: 'الفريق المسائي حقق 108% من المستهدف ويمكن رفع الحصة التالية.',
      colorHex: 0xFF16A34A,
    ),
  ];
}
