import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/users/presentation/widgets/components/user_worker_tile.dart';
import 'package:m_shop/features/users/presentation/widgets/components/users_actions.dart';
import 'package:m_shop/features/users/presentation/widgets/components/users_charts.dart';
import 'package:m_shop/features/users/presentation/widgets/components/users_hero.dart';
import 'package:m_shop/features/users/presentation/widgets/components/users_insights.dart';
import 'package:m_shop/features/users/presentation/widgets/components/users_metrics.dart';
import 'package:m_shop/features/users/presentation/widgets/components/users_models.dart';
import 'package:m_shop/features/users/presentation/widgets/components/users_sheet.dart';

class UsersSection extends StatefulWidget {
  const UsersSection({super.key, required this.users});

  final List<UserModel> users;

  @override
  State<UsersSection> createState() => _UsersSectionState();
}

class _UsersSectionState extends State<UsersSection> {
  late List<WorkerProfile> _profiles;
  WorkerProfile? _selectedProfile;

  @override
  void initState() {
    super.initState();
    _profiles = buildWorkerProfiles(widget.users);
    if (_profiles.isNotEmpty) {
      _selectedProfile = _profiles.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_profiles.isEmpty) {
      return const SectionCard(
        title: 'إدارة العمال والمستخدمين',
        subtitle: 'لا توجد بيانات مستخدمين متاحة حالياً.',
        child: SizedBox(height: 120, child: Center(child: Text('أضف مستخدمين أولاً حتى تظهر لوحة التحكم والإدارة.', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF667B75))))),
      );
    }

    final selectedProfile = _selectedProfile ?? _profiles.first;
    final summary = UsersSummary.fromProfiles(_profiles);
    final layout = UsersLayout.fromWidth(MediaQuery.sizeOf(context).width);

    return SectionCard(
      title: 'إدارة العمال والمستخدمين',
      subtitle: 'لوحة احترافية للتحكم في العمال والمستخدمين، أماكن العمل، الأجور، الصلاحيات، الإضافة والحذف داخل المصنع.',
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        UsersHero(summary: summary, selectedProfile: selectedProfile, onOpenControl: () => _showControlPanel(selectedProfile), onOpenPermissions: () => _showPermissions(selectedProfile)),
        const SizedBox(height: 20),
        Wrap(spacing: 12, runSpacing: 12, children: [
          UsersMetricCard(width: layout.metricWidth, title: 'إجمالي المستخدمين', value: '${summary.totalUsers}', note: 'كل العمال والمشرفين والإدارة المسجلين داخل السيستم.', accent: const Color(0xFF0F766E), icon: Icons.groups_rounded),
          UsersMetricCard(width: layout.metricWidth, title: 'الحضور النشط', value: '${summary.activeUsers}', note: 'المستخدمون الموجودون الآن في وضع تشغيل أو وردية.', accent: const Color(0xFF2563EB), icon: Icons.badge_rounded),
          UsersMetricCard(width: layout.metricWidth, title: 'متوسط الأجور', value: formatMoney(summary.averageSalary), note: 'متوسط الأجر الحالي للمستخدمين داخل المنظومة.', accent: const Color(0xFF16A34A), icon: Icons.payments_rounded),
          UsersMetricCard(width: layout.metricWidth, title: 'معتمدون', value: '${summary.approvers}', note: 'عدد من لديهم قدرة على المراجعة أو الاعتماد داخل النظام.', accent: const Color(0xFF7C3AED), icon: Icons.verified_user_rounded),
        ]),
        const SizedBox(height: 20),
        UsersActionPanel(onAddUser: _addUser, onPromoteSalary: () => _promoteSalary(selectedProfile), onChangePermissions: () => _changePermissions(selectedProfile), onChangeArea: () => _changeWorkArea(selectedProfile), onExport: _exportUsers),
        const SizedBox(height: 20),
        UsersChartsGrid(profiles: _profiles, summary: summary),
        const SizedBox(height: 20),
        Wrap(spacing: 16, runSpacing: 16, children: [
          SizedBox(
            width: layout.primaryWidth,
            child: SectionCard(
              title: 'قائمة العمال والمستخدمين',
              subtitle: 'اختيار مستخدم، تحسين أجره، حذف حسابه، أو متابعة مكان العمل والصلاحيات من نفس الصفحة.',
              child: Column(children: _profiles.map((profile) => Padding(padding: const EdgeInsets.only(bottom: 12), child: UserWorkerTile(profile: profile, selected: profile.user.email == selectedProfile.user.email, onSelect: () => _selectProfile(profile), onView: () => _showUserDetails(profile), onPromote: () => _promoteSalary(profile), onDelete: () => _deleteUser(profile)))).toList()),
            ),
          ),
          SizedBox(width: layout.secondaryWidth, child: UsersInsightsPanel(selectedProfile: selectedProfile)),
        ]),
      ]),
    );
  }

  void _selectProfile(WorkerProfile profile) {
    setState(() {
      _selectedProfile = profile;
    });
  }

  void _addUser() {
    final newUser = UserModel(name: 'عامل جديد ${_profiles.length + 1}', email: 'worker${_profiles.length + 1}@factory.com', role: 'Worker', status: 'في الوردية');
    final newProfile = WorkerProfile(user: newUser, workArea: 'خط جديد', salary: 3900, permissionLevel: 'صلاحيات تشغيل', shift: 'صباحية', performance: 0.72, tasksHandled: 4, canApprove: false);
    setState(() {
      _profiles = [..._profiles, newProfile];
      _selectedProfile = newProfile;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت إضافة عامل جديد إلى النظام بنجاح.')));
  }

  void _deleteUser(WorkerProfile profile) {
    setState(() {
      _profiles = _profiles.where((item) => item.user.email != profile.user.email).toList();
      if (_profiles.isNotEmpty) {
        _selectedProfile = _profiles.first;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم حذف المستخدم ${profile.user.name} من القائمة الحالية.')));
  }

  void _promoteSalary(WorkerProfile profile) {
    final updated = profile.copyWith(salary: profile.salary + 350, performance: (profile.performance + 0.04).clamp(0.0, 0.99).toDouble());
    _replaceProfile(updated);
    showUsersInfoSheet(
      context: context,
      title: 'تحسين الأجر',
      subtitle: 'تم تعديل أجر المستخدم المحدد داخل الشاشة الحالية.',
      children: [
        UsersSheetLine(label: 'المستخدم', value: updated.user.name),
        UsersSheetLine(label: 'الأجر الجديد', value: formatMoney(updated.salary)),
        UsersSheetLine(label: 'الأداء المتوقع', value: formatPercent(updated.performance)),
        const UsersSheetMessage(message: 'فكرة مفيدة للمصنع: اربط الزيادة بخطة أداء واضحة ومؤشرات جودة والتزام، وليس فقط بالمدة الزمنية.'),
      ],
    );
  }

  void _changePermissions(WorkerProfile profile) {
    final levels = ['صلاحيات تشغيل', 'صلاحيات متابعة', 'صلاحيات اعتماد', 'صلاحيات كاملة'];
    final currentIndex = levels.indexOf(profile.permissionLevel);
    final next = levels[(currentIndex + 1) % levels.length];
    final updated = profile.copyWith(permissionLevel: next, canApprove: next.contains('اعتماد') || next.contains('كاملة'));
    _replaceProfile(updated);
    showUsersInfoSheet(
      context: context,
      title: 'تحديث الصلاحيات',
      subtitle: 'تدوير صلاحية المستخدم بشكل تجريبي داخل الصفحة.',
      children: [
        UsersSheetLine(label: 'المستخدم', value: updated.user.name),
        UsersSheetLine(label: 'الصلاحية الجديدة', value: updated.permissionLevel),
        UsersSheetLine(label: 'إمكانية الاعتماد', value: updated.canApprove ? 'نعم' : 'لا'),
        const UsersSheetMessage(message: 'مهم جداً في المصنع إن الصلاحيات تتوزع حسب الدور الفعلي ومكان العمل، عشان القرارات ما تبقاش مفتوحة لكل المستخدمين.'),
      ],
    );
  }

  void _changeWorkArea(WorkerProfile profile) {
    const areas = ['خط القص', 'خط التجميع', 'الفحص والجودة', 'المخزن', 'التغليف', 'غرفة التحكم'];
    final currentIndex = areas.indexOf(profile.workArea);
    final nextArea = areas[(currentIndex + 1) % areas.length];
    final updated = profile.copyWith(workArea: nextArea);
    _replaceProfile(updated);
    showUsersInfoSheet(
      context: context,
      title: 'نقل مكان العمل',
      subtitle: 'تحديث منطقة التشغيل للمستخدم المحدد.',
      children: [
        UsersSheetLine(label: 'المستخدم', value: updated.user.name),
        UsersSheetLine(label: 'المكان الجديد', value: updated.workArea),
        UsersSheetLine(label: 'الوردية', value: updated.shift),
        const UsersSheetMessage(message: 'فكرة نظام حقيقية: احتفظ بسجل انتقالات لكل عامل بين المناطق عشان تقدر تعرف الإنتاجية الأفضل حسب المكان.'),
      ],
    );
  }

  Future<void> _showControlPanel(WorkerProfile profile) {
    return showUsersInfoSheet(
      context: context,
      title: 'لوحة التحكم بالمستخدم',
      subtitle: 'عرض سريع لكل ما يخص المستخدم المختار.',
      children: [
        UsersSheetLine(label: 'الاسم', value: profile.user.name),
        UsersSheetLine(label: 'الدور', value: profile.user.role),
        UsersSheetLine(label: 'مكان العمل', value: profile.workArea),
        UsersSheetLine(label: 'الأجر', value: formatMoney(profile.salary)),
        UsersSheetLine(label: 'الأداء', value: formatPercent(profile.performance)),
        const UsersSheetMessage(message: 'الشكل ده مناسب جداً لتحويل قسم المستخدمين في المصنع إلى سيستم إداري حقيقي يربط الحسابات بالتشغيل الفعلي.'),
      ],
    );
  }

  Future<void> _showPermissions(WorkerProfile profile) {
    return showUsersInfoSheet(
      context: context,
      title: 'تفاصيل الصلاحيات',
      subtitle: 'توضيح مستوى الصلاحية الحالي وما يتيحه للمستخدم.',
      children: [
        UsersSheetLine(label: 'المستخدم', value: profile.user.name),
        UsersSheetLine(label: 'مستوى الصلاحية', value: profile.permissionLevel),
        UsersSheetLine(label: 'الاعتماد', value: profile.canApprove ? 'مفعل' : 'غير مفعل'),
        UsersSheetLine(label: 'مكان التأثير', value: profile.workArea),
        const UsersSheetMessage(message: 'تقسيم الصلاحيات حسب المنطقة والدور يمنع الأخطاء ويخلي كل مستخدم شايف فقط اللي يخص شغله داخل المصنع.'),
      ],
    );
  }

  Future<void> _showUserDetails(WorkerProfile profile) {
    return showUsersInfoSheet(
      context: context,
      title: 'تفاصيل المستخدم',
      subtitle: 'ملف تنفيذي للمستخدم داخل المصنع.',
      children: [
        UsersSheetLine(label: 'الاسم', value: profile.user.name),
        UsersSheetLine(label: 'الإيميل', value: profile.user.email),
        UsersSheetLine(label: 'الدور', value: profile.user.role),
        UsersSheetLine(label: 'الحالة', value: profile.user.status),
        UsersSheetLine(label: 'المنطقة', value: profile.workArea),
        UsersSheetLine(label: 'المهام المنجزة', value: '${profile.tasksHandled}'),
        UsersSheetMessage(message: profile.canApprove ? 'المستخدم ده مناسب للمتابعة والاعتماد في الجزء المسؤول عنه.' : 'المستخدم ده مناسب للتشغيل والتنفيذ ويحتاج صلاحية أعلى فقط عند الضرورة.'),
      ],
    );
  }

  void _exportUsers() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تجهيز كشف المستخدمين والعمال للتصدير.')));
  }

  void _replaceProfile(WorkerProfile updated) {
    setState(() {
      _profiles = _profiles.map((item) => item.user.email == updated.user.email ? updated : item).toList();
      _selectedProfile = updated;
    });
  }
}
