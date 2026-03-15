import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class UsersSection extends StatelessWidget {
  const UsersSection({super.key, required this.users});

  final List<UserModel> users;

  @override
  Widget build(BuildContext context) {
    final activeUsers = users.where((user) => user.status.toLowerCase().contains('active')).length;
    final supervisors = users.where((user) => user.role == 'Supervisor').length;
    final workers = users.where((user) => user.role == 'Worker').length;

    return SectionCard(
      title: 'Users',
      subtitle: 'Overview of team members, roles, and user management actions.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _UserStatCard(
                title: 'Total Users',
                value: users.length.toString(),
                color: const Color(0xFF0F766E),
              ),
              _UserStatCard(
                title: 'Active',
                value: activeUsers.toString(),
                color: const Color(0xFF2563EB),
              ),
              _UserStatCard(
                title: 'Supervisors',
                value: supervisors.toString(),
                color: const Color(0xFFF59E0B),
              ),
              _UserStatCard(
                title: 'Workers',
                value: workers.toString(),
                color: const Color(0xFF7C3AED),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAF9),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                _UserAction(label: 'Add User', icon: Icons.person_add_alt_1_rounded),
                _UserAction(label: 'Assign Role', icon: Icons.admin_panel_settings_outlined),
                _UserAction(label: 'Send Notice', icon: Icons.campaign_outlined),
                _UserAction(label: 'Export List', icon: Icons.file_download_outlined),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ...users.map((user) => _UserTile(user: user)),
        ],
      ),
    );
  }
}

class _UserStatCard extends StatelessWidget {
  const _UserStatCard({
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 4,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _UserAction extends StatelessWidget {
  const _UserAction({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
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
            backgroundColor: const Color(0x140F766E),
            foregroundColor: const Color(0xFF0F766E),
            child: Text(user.name.isNotEmpty ? user.name[0].toUpperCase() : '?'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(
                  '${user.role} • ${user.email}',
                  style: const TextStyle(color: Color(0xFF667B75), height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0x140F766E),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              user.status,
              style: const TextStyle(
                color: Color(0xFF0F766E),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
