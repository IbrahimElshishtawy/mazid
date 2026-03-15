part of 'dashboard_sections.dart';

class UsersSection extends StatelessWidget {
  const UsersSection({super.key, required this.users});

  final List<UserModel> users;

  @override
  Widget build(BuildContext context) {
    final activeCount = users.where((user) => user.status == 'نشط' || user.status == 'في الوردية').length;
    final supervisors = users.where((user) => user.role == 'Supervisor').length;
    final workers = users.where((user) => user.role == 'Worker').length;
    final selectedUser = users.first;

    return Column(
      children: [
        SectionCard(
          title: 'إدارة المستخدمين',
          subtitle: 'إنشاء المستخدمين، متابعتهم، التحكم في صلاحياتهم، وتجهيز المهام لهم من نفس القسم.',
          child: Column(
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _ProfileBadge(title: 'كل المستخدمين', value: '${users.length}', color: const Color(0xFF0F766E)),
                  _ProfileBadge(title: 'نشطون', value: '$activeCount', color: const Color(0xFF2563EB)),
                  _ProfileBadge(title: 'مشرفون', value: '$supervisors', color: const Color(0xFFF59E0B)),
                  _ProfileBadge(title: 'عمال', value: '$workers', color: const Color(0xFF7C3AED)),
                ],
              ),
              const SizedBox(height: 16),
              const _AdminInput(label: 'إنشاء مستخدم', value: 'أدخل الاسم والبريد والدور لإنشاء الحساب'),
              const SizedBox(height: 12),
              const _AdminInput(label: 'إرسال مهمة', value: 'عنوان المهمة والوصف وتاريخ التسليم'),
              const SizedBox(height: 16),
              _UserAdminPanel(user: selectedUser),
              const SizedBox(height: 16),
              ...users.map((user) => UserTile(user: user)),
            ],
          ),
        ),
      ],
    );
  }
}

class _AdminInput extends StatelessWidget {
  const _AdminInput({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAF9),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE2ECE8)),
          ),
          child: Text(value, style: const TextStyle(color: Color(0xFF667B75))),
        ),
      ],
    );
  }
}

class _UserAdminPanel extends StatelessWidget {
  const _UserAdminPanel({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('لوحة متابعة المستخدم المحدد', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 12),
          SimpleTile(title: user.name, subtitle: '${user.role} • ${user.email}', trailing: user.status),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _QuickAction(label: 'منح صلاحية', icon: Icons.add_moderator_outlined),
              _QuickAction(label: 'تقليل الصلاحية', icon: Icons.remove_moderator_outlined),
              _QuickAction(label: 'إرسال مهمة', icon: Icons.send_rounded),
              _QuickAction(label: 'متابعة الحساب', icon: Icons.monitor_heart_outlined),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(onPressed: () {}, icon: Icon(icon), label: Text(label));
  }
}

