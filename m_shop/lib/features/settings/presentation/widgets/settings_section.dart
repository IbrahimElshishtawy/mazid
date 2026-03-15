import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Settings',
      subtitle: 'General preferences, control options, and operating reminders.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _SettingRow(title: 'Theme Mode', value: 'Light'),
          _SettingRow(title: 'Notifications', value: 'Enabled'),
          _SettingRow(title: 'Language', value: 'Arabic'),
          _SettingRow(title: 'Auto Backup', value: 'Every 6 hours'),
          _SettingRow(title: 'Default Dashboard', value: 'Overview'),
          SizedBox(height: 18),
          _SettingNote(title: 'Keep settings documented', description: 'Team-wide changes should be reviewed before they affect the daily workflow.'),
          _SettingNote(title: 'Prefer safe defaults', description: 'Stable default values reduce confusion and keep the interface predictable.'),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({required this.title, required this.value});
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFFF7FAF9), borderRadius: BorderRadius.circular(18)),
        child: Row(children: [Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700))), Text(value, style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.w800))]),
      ),
    );
  }
}

class _SettingNote extends StatelessWidget {
  const _SettingNote({required this.title, required this.description});
  final String title;
  final String description;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFFF7FAF9), borderRadius: BorderRadius.circular(18)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 6), Text(description, style: const TextStyle(color: Color(0xFF667B75), height: 1.5))]),
      ),
    );
  }
}
