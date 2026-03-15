import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import '../../../../core/widgets/section_components.dart';

class UsersSection extends StatelessWidget {
  const UsersSection({super.key, required this.users});

  final List<UserModel> users;

  @override
  Widget build(BuildContext context) {
    final activeCount = users.where((user) => user.status == '???' || user.status == '?? ???????').length;
    final supervisors = users.where((user) => user.role == 'Supervisor').length;
    final workers = users.where((user) => user.role == 'Worker').length;
    final selectedUser = users.first;

    return Column(
      children: [
        SectionCard(
          title: '????? ??????????',
          subtitle: '????? ??????????? ????????? ?????? ?? ?????????? ?????? ?????? ??? ?? ??? ?????.',
          child: Column(
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ProfileBadge(title: '?? ??????????', value: '${users.length}', color: const Color(0xFF0F766E)),
                  ProfileBadge(title: '?????', value: '$activeCount', color: const Color(0xFF2563EB)),
                  ProfileBadge(title: '??????', value: '$supervisors', color: const Color(0xFFF59E0B)),
                  ProfileBadge(title: '????', value: '$workers', color: const Color(0xFF7C3AED)),
                ],
              ),
              const SizedBox(height: 16),
              const _AdminInput(label: '????? ??????', value: '???? ????? ??????? ?????? ?????? ??????'),
              const SizedBox(height: 12),
              const _AdminInput(label: '????? ????', value: '????? ?????? ?????? ?????? ???????'),
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
          Text('???? ?????? ???????? ??????', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 12),
          SimpleTile(title: user.name, subtitle: '${user.role} • ${user.email}', trailing: user.status),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              QuickAction(label: '??? ??????', icon: Icons.add_moderator_outlined),
              QuickAction(label: '????? ????????', icon: Icons.remove_moderator_outlined),
              QuickAction(label: '????? ????', icon: Icons.send_rounded),
              QuickAction(label: '?????? ??????', icon: Icons.monitor_heart_outlined),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegacyQuickAction extends StatelessWidget {
  const _LegacyQuickAction({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(onPressed: () {}, icon: Icon(icon), label: Text(label));
  }
}









