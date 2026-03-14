import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.user,
    required this.users,
  });

  final UserModel user;
  final List<UserModel> users;

  @override
  Widget build(BuildContext context) {
    final badgeColor = _roleColor(user.role);
    final activeUsers = users.where((item) => item.status == 'نشط' || item.status == 'في الوردية').length;
    final managers = users.where((item) => item.role == 'Manager').length;
    final supervisors = users.where((item) => item.role == 'Supervisor').length;
    final workers = users.where((item) => item.role == 'Worker').length;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الملف الإداري')),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE7F4F1), Color(0xFFF7FAF9)],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ProfileHero(user: user, badgeColor: badgeColor, activeUsers: activeUsers),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      const _ProfileMetric(title: 'المهام المنجزة', value: '128', color: Color(0xFF0F766E)),
                      const _ProfileMetric(title: 'معدل الالتزام', value: '96%', color: Color(0xFF2563EB)),
                      _ProfileMetric(title: 'المستخدمون النشطون', value: '$activeUsers', color: const Color(0xFF059669)),
                      _ProfileMetric(title: 'المستخدمون الكلي', value: '${users.length}', color: const Color(0xFF7C3AED)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SectionCard(
                    title: 'الهوية الإدارية',
                    subtitle: 'بيانات تعريفية وحالة الحساب الحالية.',
                    child: Column(
                      children: [
                        _InfoRow(label: 'الاسم الكامل', value: user.name),
                        _InfoRow(label: 'البريد الإلكتروني', value: user.email),
                        _InfoRow(label: 'الدور الوظيفي', value: user.role),
                        _InfoRow(label: 'حالة الحساب', value: user.status),
                        const _InfoRow(label: 'رقم الهاتف', value: '+20 109 555 8201'),
                        const _InfoRow(label: 'الموقع', value: 'مصنع مدينة العاشر'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  SectionCard(
                    title: 'صلاحيات الإدارة والمراقبة',
                    subtitle: 'ما الذي يستطيع هذا الحساب مراقبته وإدارته داخل النظام.',
                    child: const Column(
                      children: [
                        _PermissionTile(title: 'مراقبة كل المستخدمين', subtitle: 'متابعة حالة الحسابات والإيميلات وأدوار النظام', state: 'مفعل'),
                        _PermissionTile(title: 'إدارة الصلاحيات', subtitle: 'تحديد صلاحيات المديرين والمشرفين والعمال', state: 'مستوى كامل'),
                        _PermissionTile(title: 'الوصول للتقارير والأرباح', subtitle: 'عرض نتائج الشغل، التقارير المالية، والجرد', state: 'مفعل'),
                        _PermissionTile(title: 'اعتماد التغييرات', subtitle: 'اعتماد التعديلات الحساسة في المستخدمين والإعدادات', state: 'مفعل'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  SectionCard(
                    title: 'لوحة مراقبة المستخدمين',
                    subtitle: 'عرض إداري سريع للحسابات داخل النظام مع الإيميل والحالة والدور.',
                    child: Column(
                      children: users.map((member) => _MonitoredUserTile(user: member)).toList(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SectionCard(
                    title: 'توزيع الأدوار',
                    subtitle: 'ملخص سريع لفئات المستخدمين داخل النظام.',
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _RoleSummary(title: 'مديرون', count: '$managers', color: const Color(0xFF0F766E)),
                        _RoleSummary(title: 'مشرفون', count: '$supervisors', color: const Color(0xFFF59E0B)),
                        _RoleSummary(title: 'عمال', count: '$workers', color: const Color(0xFF2563EB)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const SectionCard(
                    title: 'نبذة مهنية',
                    subtitle: 'مقدمة مختصرة عن الحساب الحالي داخل النظام.',
                    child: Text(
                      'هذا الحساب الإداري مسؤول عن متابعة أداء خطوط التشغيل، مراجعة مؤشرات الجودة، مراقبة المستخدمين، الإشراف على الجرد، واعتماد النتائج اليومية مع تنسيق مباشر بين فرق العمل والصيانة والإدارة المالية.',
                      style: TextStyle(height: 1.8, color: Color(0xFF30413D)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({
    required this.user,
    required this.badgeColor,
    required this.activeUsers,
  });

  final UserModel user;
  final Color badgeColor;
  final int activeUsers;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF0F766E), Color(0xFF1D4ED8), Color(0xFF0F172A)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 42,
                backgroundColor: Colors.white.withValues(alpha: 0.16),
                child: Text(
                  user.name.isNotEmpty ? user.name.substring(0, 1) : '?',
                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 6),
                    Text(user.email, style: const TextStyle(color: Color(0xD7FFFFFF))),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _HeroTag(label: user.role),
                        _HeroTag(label: user.status),
                        const _HeroTag(label: 'وصول إداري'),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                ),
                child: const Text('حساب قيادي', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text('المستخدمون تحت المراقبة المباشرة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                ),
                Text('$activeUsers / نشط', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroTag extends StatelessWidget {
  const _HeroTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({required this.title, required this.value, required this.color});

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2ECE8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Color(0xFF647874), fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({required this.title, required this.subtitle, required this.state});

  final String title;
  final String subtitle;
  final String state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAF9),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const Icon(Icons.verified_user_rounded, color: Color(0xFF0F766E)),
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
            Text(state, style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}

class _MonitoredUserTile extends StatelessWidget {
  const _MonitoredUserTile({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final color = _roleColor(user.role);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withValues(alpha: 0.12),
            child: Text(
              user.name.isNotEmpty ? user.name.substring(0, 1) : '?',
              style: TextStyle(color: color, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(user.email, style: const TextStyle(color: Color(0xFF667B75))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(user.role, style: TextStyle(color: color, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(user.status, style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoleSummary extends StatelessWidget {
  const _RoleSummary({required this.title, required this.count, required this.color});

  final String title;
  final String count;
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
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Text(count, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAF9),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700))),
            Text(value, style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

Color _roleColor(String role) {
  switch (role) {
    case 'Manager':
      return const Color(0xFF0F766E);
    case 'Supervisor':
      return const Color(0xFFF59E0B);
    default:
      return const Color(0xFF2563EB);
  }
}
