import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

abstract final class DashboardSeed {
  static const users = [
    UserModel(name: 'إبراهيم حسن', email: 'manager@factory.com', role: 'Manager', status: 'نشط'),
    UserModel(name: 'أحمد علي', email: 'supervisor@factory.com', role: 'Supervisor', status: 'نشط'),
    UserModel(name: 'سارة محمد', email: 'worker1@factory.com', role: 'Worker', status: 'في الوردية'),
    UserModel(name: 'يوسف خالد', email: 'worker2@factory.com', role: 'Worker', status: 'استراحة'),
  ];

  static const attendance = [
    AttendanceRecord(name: 'سارة محمد', checkIn: '08:00', checkOut: '16:00', workedHours: 8, present: true),
    AttendanceRecord(name: 'يوسف خالد', checkIn: '08:15', checkOut: '16:05', workedHours: 7.8, present: true),
    AttendanceRecord(name: 'ليلى أحمد', checkIn: '-', checkOut: '-', workedHours: 0, present: false),
  ];

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
      assignedTo: 'أحمد علي',
      status: 'قيد التنفيذ',
      dueDate: 'اليوم 04:00 م',
    ),
    TaskModel(
      title: 'صيانة وقائية للآلة CNC-12',
      description: 'استبدال القطع المعرضة للاهتزاز وتأكيد الضبط النهائي.',
      progress: 0.24,
      assignedTo: 'فريق الصيانة',
      status: 'مجدولة',
      dueDate: 'غدًا 09:00 ص',
    ),
    TaskModel(
      title: 'مراجعة جودة التغليف',
      description: 'مطابقة التغليف مع آخر متطلبات قسم الجودة.',
      progress: 0.84,
      assignedTo: 'سارة محمد',
      status: 'شارفت على الاكتمال',
      dueDate: 'اليوم 02:00 م',
    ),
  ];

  static const inventory = [
    InventoryItem(name: 'قماش قطني', quantity: 420, minimum: 250, unit: 'متر'),
    InventoryItem(name: 'حشو فايبر', quantity: 180, minimum: 200, unit: 'كجم'),
    InventoryItem(name: 'علب تغليف', quantity: 90, minimum: 120, unit: 'كرتونة'),
  ];

  static const financialReports = [
    FinancialReport(period: 'يومي', income: 24500, expenses: 16200, profit: 8300),
    FinancialReport(period: 'أسبوعي', income: 152000, expenses: 104500, profit: 47500),
    FinancialReport(period: 'شهري', income: 615000, expenses: 446000, profit: 169000),
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
      title: 'مخزون التغليف يقترب من الحد الأدنى',
      description: 'كمية علب التغليف أقل من المستوى الآمن ويجب طلب دفعة جديدة.',
      colorHex: 0xFF2563EB,
    ),
  ];
}
