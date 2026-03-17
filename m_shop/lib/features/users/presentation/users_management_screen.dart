import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class UsersManagementScreen extends StatefulWidget {
  const UsersManagementScreen({super.key, required this.users});

  final List<UserModel> users;

  @override
  State<UsersManagementScreen> createState() => _UsersManagementScreenState();
}

class _UsersManagementScreenState extends State<UsersManagementScreen> {
  String _query = '';
  String _selectedRole = 'الكل';
  int _selectedUserIndex = 0;

  List<UserModel> get _filteredUsers {
    return widget.users.where((user) {
      final matchesQuery =
          user.name.contains(_query) ||
          user.email.toLowerCase().contains(_query.toLowerCase()) ||
          user.role.toLowerCase().contains(_query.toLowerCase());
      final matchesRole = _selectedRole == 'الكل' || user.role == _selectedRole;
      return matchesQuery && matchesRole;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final roles = ['الكل', ...widget.users.map((user) => user.role).toSet()];
    final activeCount = widget.users
        .where((user) => user.status == 'نشط' || user.status == 'في الوردية')
        .length;
    final supervisors = widget.users
        .where((user) => user.role == 'Supervisor')
        .length;
    final workers = widget.users.where((user) => user.role == 'Worker').length;
    final selectedUser =
        widget.users[_selectedUserIndex.clamp(0, widget.users.length - 1)];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إدارة المستخدمين'),
          centerTitle: false,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'تم تجهيز قسم إنشاء المستخدم، ويمكن تحويله إلى نموذج حفظ فعلي لاحقًا.',
                ),
              ),
            );
          },
          backgroundColor: const Color(0xFF0F766E),
          icon: const Icon(Icons.person_add_alt_1_rounded),
          label: const Text('إنشاء مستخدم'),
        ),
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
                  _UsersHero(
                    totalUsers: widget.users.length,
                    activeCount: activeCount,
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _SummaryCard(
                        title: 'إجمالي المستخدمين',
                        value: '${widget.users.length}',
                        color: const Color(0xFF0F766E),
                      ),
                      _SummaryCard(
                        title: 'الحسابات النشطة',
                        value: '$activeCount',
                        color: const Color(0xFF2563EB),
                      ),
                      _SummaryCard(
                        title: 'المشرفون',
                        value: '$supervisors',
                        color: const Color(0xFFF59E0B),
                      ),
                      _SummaryCard(
                        title: 'العمال',
                        value: '$workers',
                        color: const Color(0xFF7C3AED),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SectionCard(
                    title: 'أدوات الإدارة',
                    subtitle: 'ابحث داخل المستخدمين أو صفهم حسب الدور الوظيفي.',
                    child: Column(
                      children: [
                        TextField(
                          onChanged: (value) => setState(() => _query = value),
                          decoration: InputDecoration(
                            hintText: 'ابحث بالاسم أو البريد أو الدور',
                            prefixIcon: const Icon(Icons.search_rounded),
                            filled: true,
                            fillColor: Theme.of(
                              context,
                            ).colorScheme.surface.withValues(alpha: 0.48),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: roles.map((role) {
                            final selected = role == _selectedRole;
                            return ChoiceChip(
                              label: Text(role),
                              selected: selected,
                              onSelected: (_) =>
                                  setState(() => _selectedRole = role),
                              selectedColor: const Color(0xFF0F766E),
                              labelStyle: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : const Color(0xFF4F6660),
                                fontWeight: FontWeight.w700,
                              ),
                              backgroundColor: Theme.of(context).cardColor,
                              side: const BorderSide(color: Color(0xFFE2ECE8)),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _AdminModules(
                    users: widget.users,
                    selectedUser: selectedUser,
                    onUserChanged: (index) =>
                        setState(() => _selectedUserIndex = index),
                  ),
                  const SizedBox(height: 18),
                  SectionCard(
                    title: 'قائمة المستخدمين',
                    subtitle:
                        'عرض منظم للحسابات مع الدور والحالة والإجراءات السريعة.',
                    child: Column(
                      children: _filteredUsers.isEmpty
                          ? const [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Text(
                                  'لا يوجد مستخدمون مطابقون للبحث الحالي.',
                                ),
                              ),
                            ]
                          : _filteredUsers
                                .map((user) => _UserManagementCard(user: user))
                                .toList(),
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

class _UsersHero extends StatelessWidget {
  const _UsersHero({required this.totalUsers, required this.activeCount});

  final int totalUsers;
  final int activeCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF0F766E), Color(0xFF1D4ED8)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0x33FFFFFF),
                child: Icon(Icons.group_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'لوحة إدارة المستخدمين',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'لديك $totalUsers مستخدمين داخل النظام، منهم $activeCount بحالة تشغيل أو نشاط الآن.',
            style: const TextStyle(color: Color(0xE6FFFFFF), height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2ECE8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF5E746E),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class _AdminModules extends StatelessWidget {
  const _AdminModules({
    required this.users,
    required this.selectedUser,
    required this.onUserChanged,
  });

  final List<UserModel> users;
  final UserModel selectedUser;
  final ValueChanged<int> onUserChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionCard(
          title: 'إنشاء مستخدم جديد',
          subtitle: 'واجهة جاهزة لإضافة حساب جديد داخل النظام.',
          child: Column(
            children: [
              const _FakeField(
                label: 'الاسم الكامل',
                value: 'أدخل اسم المستخدم الجديد',
              ),
              const SizedBox(height: 12),
              const _FakeField(
                label: 'البريد الإلكتروني',
                value: 'name@factory.com',
              ),
              const SizedBox(height: 12),
              const _FakeField(
                label: 'الدور الوظيفي',
                value: 'Manager / Supervisor / Worker',
              ),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'يمكن توصيل إنشاء المستخدم بقاعدة البيانات في الخطوة التالية.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_add_alt_1_rounded),
                  label: const Text('إنشاء الحساب'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        SectionCard(
          title: 'متابعة المستخدمين',
          subtitle: 'اختر مستخدمًا لمراجعة حالته وصلاحياته ومهامه.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(users.length, (index) {
                  final user = users[index];
                  final selected = user.email == selectedUser.email;
                  return ChoiceChip(
                    label: Text(user.name),
                    selected: selected,
                    onSelected: (_) => onUserChanged(index),
                    selectedColor: const Color(0xFF0F766E),
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : const Color(0xFF4F6660),
                      fontWeight: FontWeight.w700,
                    ),
                    backgroundColor: Theme.of(context).cardColor,
                    side: const BorderSide(color: Color(0xFFE2ECE8)),
                  );
                }),
              ),
              const SizedBox(height: 16),
              _UserControlPanel(user: selectedUser),
            ],
          ),
        ),
      ],
    );
  }
}

class _UserControlPanel extends StatelessWidget {
  const _UserControlPanel({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final permissionLevel = switch (user.role) {
      'Manager' => 'كامل',
      'Supervisor' => 'متوسط',
      _ => 'محدود',
    };

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surface.withValues(alpha: 0.48),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0x1A0F766E),
                child: Text(
                  user.name.isNotEmpty ? user.name.substring(0, 1) : '?',
                  style: const TextStyle(
                    color: Color(0xFF0F766E),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: const TextStyle(color: Color(0xFF667B75)),
                    ),
                  ],
                ),
              ),
              _InfoChip(label: user.role, color: const Color(0xFF0F766E)),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                title: 'الصلاحيات الحالية',
                subtitle: permissionLevel,
                icon: Icons.shield_rounded,
                color: const Color(0xFF0F766E),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
                title: 'حالة الحساب',
                subtitle: user.status,
                icon: Icons.monitor_heart_rounded,
                color: const Color(0xFF2563EB),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SectionCard(
          title: 'إدارة الصلاحيات',
          subtitle: 'إجراءات سريعة على صلاحيات المستخدم المحدد.',
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              OutlinedButton.icon(
                onPressed: () => _showSnack(
                  context,
                  'تم منح صلاحية إضافية إلى ${user.name}',
                ),
                icon: const Icon(Icons.add_moderator_outlined),
                label: const Text('منح صلاحية'),
              ),
              OutlinedButton.icon(
                onPressed: () =>
                    _showSnack(context, 'تم تقليل صلاحيات ${user.name}'),
                icon: const Icon(Icons.remove_moderator_outlined),
                label: const Text('تقليل الصلاحية'),
              ),
              OutlinedButton.icon(
                onPressed: () =>
                    _showSnack(context, 'تم تعليق حساب ${user.name} إداريًا'),
                icon: const Icon(Icons.person_off_outlined),
                label: const Text('تعليق الحساب'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SectionCard(
          title: 'إرسال المهام للمستخدم',
          subtitle: 'إسناد مهمة جديدة مباشرة للمستخدم المحدد.',
          child: Column(
            children: [
              const _FakeField(
                label: 'عنوان المهمة',
                value: 'مثال: مراجعة خط الإنتاج B',
              ),
              const SizedBox(height: 12),
              const _FakeField(
                label: 'وصف المهمة',
                value: 'تفاصيل سريعة عن المطلوب تنفيذه',
              ),
              const SizedBox(height: 12),
              _FakeField(label: 'المُرسل إليه', value: user.name),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: () => _showSnack(
                    context,
                    'تم تجهيز إرسال مهمة جديدة إلى ${user.name}',
                  ),
                  icon: const Icon(Icons.send_rounded),
                  label: const Text('إرسال المهمة'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2ECE8)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: color, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FakeField extends StatelessWidget {
  const _FakeField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surface.withValues(alpha: 0.48),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE2ECE8)),
          ),
          child: Text(value, style: const TextStyle(color: Color(0xFF667B75))),
        ),
      ],
    );
  }
}

class _UserManagementCard extends StatelessWidget {
  const _UserManagementCard({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final roleColor = switch (user.role) {
      'Manager' => const Color(0xFF0F766E),
      'Supervisor' => const Color(0xFFF59E0B),
      _ => const Color(0xFF2563EB),
    };

    final statusColor = user.status == 'نشط' || user.status == 'في الوردية'
        ? const Color(0xFF16A34A)
        : const Color(0xFF64748B);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: roleColor.withValues(alpha: 0.12),
                child: Text(
                  user.name.isNotEmpty ? user.name.substring(0, 1) : '?',
                  style: TextStyle(
                    color: roleColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: const TextStyle(color: Color(0xFF667B75)),
                    ),
                  ],
                ),
              ),
              _InfoChip(label: user.role, color: roleColor),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _InfoChip(label: user.status, color: statusColor),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('عرض صلاحيات ${user.name} جاهز للتطوير.'),
                    ),
                  );
                },
                icon: const Icon(Icons.shield_outlined),
                label: const Text('الصلاحيات'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'تعديل بيانات ${user.name} سيكون الخطوة التالية.',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('تعديل'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w800),
      ),
    );
  }
}
