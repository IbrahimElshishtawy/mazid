import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class UsersSection extends StatelessWidget {
  const UsersSection({super.key, required this.users});

  final List<UserModel> users;

  @override
  Widget build(BuildContext context) {
    final activeCount = users
        .where((user) => user.status == '???' || user.status == '?? ???????')
        .length;
    final supervisors = users.where((user) => user.role == 'Supervisor').length;
    final workers = users.where((user) => user.role == 'Worker').length;
    final selectedUser = users.isNotEmpty ? users.first : null;

    return Column(
      children: [
        SectionCard(
          title: '????? ??????????',
          subtitle:
              '????? ??????????? ????????? ?????? ?? ?????????? ?????? ?????? ??? ?? ??? ?????.',
          child: Column(
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _StatCard(
                    title: '?? ??????????',
                    value: '${users.length}',
                    color: const Color(0xFF0F766E),
                  ),
                  _StatCard(
                    title: '?????',
                    value: '$activeCount',
                    color: const Color(0xFF2563EB),
                  ),
                  _StatCard(
                    title: '??????',
                    value: '$supervisors',
                    color: const Color(0xFFF59E0B),
                  ),
                  _StatCard(
                    title: '????',
                    value: '$workers',
                    color: const Color(0xFF7C3AED),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const _AdminInput(
                label: '????? ??????',
                value: '???? ????? ??????? ?????? ?????? ??????',
              ),
              const SizedBox(height: 12),
              const _AdminInput(
                label: '????? ????',
                value: '????? ?????? ?????? ?????? ???????',
              ),
              if (selectedUser != null) ...[
                const SizedBox(height: 16),
                _UserAdminPanel(user: selectedUser),
              ],
              const SizedBox(height: 16),
              ...users.map((user) => _UserTile(user: user)),
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
          const Text(
            '???? ?????? ???????? ??????',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
          const SizedBox(height: 12),
          _SimpleTile(
            title: user.name,
            subtitle: '${user.role} • ${user.email}',
            trailing: user.status,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _QuickAction(label: '??? ??????', icon: Icons.add_moderator_outlined),
              _QuickAction(label: '????? ????????', icon: Icons.remove_moderator_outlined),
              _QuickAction(label: '????? ????', icon: Icons.send_rounded),
              _QuickAction(label: '?????? ??????', icon: Icons.monitor_heart_outlined),
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
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.title, required this.value, required this.color});

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 182,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
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

class _UserTile extends StatelessWidget {
  const _UserTile({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return _SimpleTile(
      title: user.name,
      subtitle: '${user.role} • ${user.email}',
      trailing: user.status,
    );
  }
}

class _SimpleTile extends StatelessWidget {
  const _SimpleTile({
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.accent = const Color(0xFF0F766E),
  });

  final String title;
  final String subtitle;
  final String trailing;
  final Color accent;

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
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Color(0xFF667B75), height: 1.4),
                ),
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
