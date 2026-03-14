import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/dashboard/presentation/widgets/charts/production_chart_card.dart';
import 'package:m_shop/features/profile/presentation/profile_screen.dart';
import 'package:m_shop/features/users/presentation/users_management_screen.dart';

class OverviewSection extends StatelessWidget {
  const OverviewSection({super.key, required this.alerts});

  final List<AlertModel> alerts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _HomeSpotlight(),
        const SizedBox(height: 16),
        SectionCard(
          title: 'تنبيهات النظام',
          subtitle: 'أهم التنبيهات التشغيلية التي تحتاج متابعة الآن.',
          child: Column(children: alerts.map((alert) => AlertTile(alert: alert)).toList()),
        ),
        const SizedBox(height: 16),
        const SectionCard(
          title: 'نظرة تنفيذية',
          subtitle: 'ملخص سريع للوحدات الرئيسية في النظام.',
          child: Column(
            children: [
              OverviewLine(title: 'إدارة المستخدمين', description: 'الوصول لصلاحيات المدير والمشرف والعامل من شاشة واحدة.'),
              OverviewLine(title: 'نتائج الشغل', description: 'مؤشرات إنجاز ومقارنة بين المستهدف والفعلي.'),
              OverviewLine(title: 'الأرباح', description: 'صافي الربح والإيرادات والمصروفات في بطاقات واضحة.'),
              OverviewLine(title: 'الجرد', description: 'العناصر الحرجة في المخزون والتنبيه قبل النفاد.'),
              OverviewLine(title: 'الإعدادات', description: 'إعدادات التشغيل والصلاحيات والتنبيهات بشكل منظم.'),
            ],
          ),
        ),
      ],
    );
  }
}

class _HomeSpotlight extends StatelessWidget {
  const _HomeSpotlight();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF111827), Color(0xFF0F766E)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('واجهة تشغيل لافتة للنظر', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('بطاقات ديناميكية، أشرطة إنجاز، ولمسات بصرية تجعل البيانات أسهل قراءة وأكثر تأثيرًا.', style: TextStyle(color: Color(0xD7FFFFFF), height: 1.6)),
          const SizedBox(height: 18),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: const [
              _PulseCard(title: 'جاهزية الخطوط', value: '92%', accent: Color(0xFF34D399)),
              _PulseCard(title: 'جودة الإنتاج', value: '97%', accent: Color(0xFF60A5FA)),
              _PulseCard(title: 'استقرار الأرباح', value: '+18%', accent: Color(0xFFFBBF24)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PulseCard extends StatelessWidget {
  const _PulseCard({required this.title, required this.value, required this.accent});

  final String title;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.7, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        width: 210,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 12, height: 12, decoration: BoxDecoration(color: accent, shape: BoxShape.circle)),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: Color(0xD7FFFFFF), fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 0.86),
                duration: const Duration(milliseconds: 1100),
                builder: (context, progress, _) => LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  color: accent,
                  backgroundColor: Colors.white.withValues(alpha: 0.12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionCard(
          title: 'الملف الشخصي',
          subtitle: 'بطاقة شخصية سريعة مع أكثر من شكل لعرض المعلومات.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileHeader(user: user),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _ProfileBadge(title: 'الدور', value: user.role, color: const Color(0xFF0F766E)),
                  _ProfileBadge(title: 'الحالة', value: user.status, color: const Color(0xFF2563EB)),
                  const _ProfileBadge(title: 'المستوى', value: 'متقدم', color: Color(0xFFF59E0B)),
                ],
              ),
              const SizedBox(height: 16),
              SimpleTile(title: 'البريد الإلكتروني', subtitle: user.email, trailing: 'موثق'),
              const SimpleTile(title: 'رقم الهاتف', subtitle: '+20 109 555 8201', trailing: 'متاح'),
              const SimpleTile(title: 'القسم', subtitle: 'الإدارة والتشغيل', trailing: 'رئيسي'),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ProfileScreen(user: user, users: [user])),
                    );
                  },
                  icon: const Icon(Icons.account_box_rounded),
                  label: const Text('فتح صفحة البروفايل الكاملة'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileBadge extends StatelessWidget {
  const _ProfileBadge({required this.title, required this.value, required this.color});

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class UsersSection extends StatelessWidget {
  const UsersSection({super.key, required this.users});

  final List<UserModel> users;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'إدارة المستخدمين',
      subtitle: 'قائمة المستخدمين مع انتقال مباشر إلى صفحة الإدارة الكاملة.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => UsersManagementScreen(users: users)),
                );
              },
              icon: const Icon(Icons.open_in_new_rounded),
              label: const Text('فتح إدارة المستخدمين'),
            ),
          ),
          const SizedBox(height: 16),
          ...users.map((user) => UserTile(user: user)),
        ],
      ),
    );
  }
}

class AttendanceSection extends StatelessWidget {
  const AttendanceSection({super.key, required this.attendance});

  final List<AttendanceRecord> attendance;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'الحضور والانصراف',
      subtitle: 'متابعة أوقات الدخول والخروج وساعات العمل اليومية.',
      child: Column(children: attendance.map((record) => AttendanceTile(record: record)).toList()),
    );
  }
}

class ProductivitySection extends StatelessWidget {
  const ProductivitySection({super.key, required this.production});

  final List<ProductionPoint> production;

  @override
  Widget build(BuildContext context) {
    return ProductionChartCard(data: production);
  }
}

class ResultsSection extends StatelessWidget {
  const ResultsSection({super.key, required this.production, required this.tasks});

  final List<ProductionPoint> production;
  final List<TaskModel> tasks;

  @override
  Widget build(BuildContext context) {
    final totalProduction = production.fold<double>(0, (sum, item) => sum + item.actual);
    final totalTarget = production.fold<double>(0, (sum, item) => sum + item.target);
    final completion = totalTarget == 0 ? 0.0 : totalProduction / totalTarget;
    final averageTaskCompletion = tasks.isEmpty ? 0.0 : tasks.fold<double>(0, (sum, task) => sum + task.progress) / tasks.length;

    return SectionCard(
      title: 'نتائج الشغل',
      subtitle: 'قراءة مركزة لنتائج الأداء والتنفيذ.',
      child: Column(
        children: [
          SimpleTile(title: 'الإنتاج الفعلي', subtitle: '${totalProduction.round()} وحدة', trailing: 'محقق'),
          SimpleTile(title: 'المستهدف', subtitle: '${totalTarget.round()} وحدة', trailing: 'خطة'),
          SimpleTile(title: 'متوسط إنجاز المهام', subtitle: '${(averageTaskCompletion * 100).round()}%', trailing: 'مستوى جيد'),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: completion.clamp(0.0, 1.0).toDouble(),
              minHeight: 12,
              color: const Color(0xFF0F766E),
              backgroundColor: const Color(0xFFD9E6E2),
            ),
          ),
        ],
      ),
    );
  }
}

class TasksSection extends StatelessWidget {
  const TasksSection({super.key, required this.tasks});

  final List<TaskModel> tasks;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'المهام',
      subtitle: 'المهام المخصصة للعاملين مع الحالة ونسبة الإنجاز.',
      child: Column(children: tasks.map((task) => TaskTile(task: task)).toList()),
    );
  }
}

class InventorySection extends StatelessWidget {
  const InventorySection({super.key, required this.inventory});

  final List<InventoryItem> inventory;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'الجرد والمخزون',
      subtitle: 'المواد الخام الحالية والتنبيهات الخاصة بها.',
      child: Column(children: inventory.map((item) => InventoryTile(item: item)).toList()),
    );
  }
}

class FinanceSection extends StatelessWidget {
  const FinanceSection({super.key, required this.financialReports});

  final List<FinancialReport> financialReports;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'الأرباح والتقارير المالية',
      subtitle: 'ملخص الإيرادات والمصروفات وصافي الربح.',
      child: Column(children: financialReports.map((report) => FinanceTile(report: report)).toList()),
    );
  }
}

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionCard(
      title: 'الإعدادات',
      subtitle: 'خيارات التشغيل والمتابعة والتنبيهات داخل النظام.',
      child: Column(
        children: [
          SettingRow(title: 'تفعيل التنبيهات الذكية', value: 'مفعلة'),
          SettingRow(title: 'نمط عرض النتائج اليومية', value: 'تفصيلي'),
          SettingRow(title: 'صلاحيات تعديل المستخدمين', value: 'مدير فقط'),
          SettingRow(title: 'مراجعة الجرد الحرج', value: 'كل 12 ساعة'),
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0x1A0F766E),
            child: Text(
              user.name.isNotEmpty ? user.name.substring(0, 1) : '?',
              style: const TextStyle(color: Color(0xFF0F766E), fontSize: 24, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(user.role, style: const TextStyle(color: Color(0xFF667B75))),
              ],
            ),
          ),
          FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.edit_outlined), label: const Text('تعديل')),
        ],
      ),
    );
  }
}

class SettingRow extends StatelessWidget {
  const SettingRow({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFFF7FAF9), borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700))),
            Text(value, style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class OverviewLine extends StatelessWidget {
  const OverviewLine({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 10, height: 10, margin: const EdgeInsets.only(top: 5), decoration: const BoxDecoration(color: Color(0xFF0F766E), shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AlertTile extends StatelessWidget {
  const AlertTile({super.key, required this.alert});

  final AlertModel alert;

  @override
  Widget build(BuildContext context) {
    final color = Color(alert.colorHex);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(alert.title, style: TextStyle(color: color, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(alert.description, style: const TextStyle(color: Color(0xFF30413D), height: 1.5)),
        ],
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return SimpleTile(title: user.name, subtitle: '${user.role} • ${user.email}', trailing: user.status);
  }
}

class AttendanceTile extends StatelessWidget {
  const AttendanceTile({super.key, required this.record});

  final AttendanceRecord record;

  @override
  Widget build(BuildContext context) {
    return SimpleTile(
      title: record.name,
      subtitle: 'دخول: ${record.checkIn} • خروج: ${record.checkOut}',
      trailing: '${record.workedHours} ساعة',
      accent: record.present ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
    );
  }
}

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFF7FAF9), borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w800))),
              Text('${(task.progress * 100).round()}%', style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 6),
          Text(task.description, style: const TextStyle(color: Color(0xFF667B75), height: 1.4)),
          const SizedBox(height: 8),
          Text('مُسندة إلى: ${task.assignedTo} • الحالة: ${task.status} • الموعد: ${task.dueDate}', style: const TextStyle(color: Color(0xFF4E645F), fontSize: 13)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: task.progress,
              minHeight: 8,
              color: const Color(0xFF0F766E),
              backgroundColor: const Color(0xFFD9E6E2),
            ),
          ),
        ],
      ),
    );
  }
}

class InventoryTile extends StatelessWidget {
  const InventoryTile({super.key, required this.item});

  final InventoryItem item;

  @override
  Widget build(BuildContext context) {
    final low = item.quantity <= item.minimum;
    return SimpleTile(
      title: item.name,
      subtitle: 'المتوفر: ${item.quantity} ${item.unit} • الحد الأدنى: ${item.minimum} ${item.unit}',
      trailing: low ? 'تنبيه' : 'آمن',
      accent: low ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
    );
  }
}

class FinanceTile extends StatelessWidget {
  const FinanceTile({super.key, required this.report});

  final FinancialReport report;

  @override
  Widget build(BuildContext context) {
    return SimpleTile(
      title: 'تقرير ${report.period}',
      subtitle: 'الإيراد: ${report.income.toStringAsFixed(0)} • المصروفات: ${report.expenses.toStringAsFixed(0)}',
      trailing: 'ربح ${report.profit.toStringAsFixed(0)}',
      accent: const Color(0xFF059669),
    );
  }
}

class SimpleTile extends StatelessWidget {
  const SimpleTile({super.key, required this.title, required this.subtitle, required this.trailing, this.accent = const Color(0xFF0F766E)});

  final String title;
  final String subtitle;
  final String trailing;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFF7FAF9), borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: accent, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Color(0xFF667B75), height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(trailing, style: TextStyle(color: accent, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

