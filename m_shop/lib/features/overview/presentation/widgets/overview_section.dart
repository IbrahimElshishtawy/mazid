import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class OverviewSection extends StatelessWidget {
  const OverviewSection({super.key, required this.alerts});

  final List<AlertModel> alerts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionCard(
          title: 'Overview',
          subtitle: 'Quick view of platform health, priorities, and operating focus.',
          child: Column(
            children: [
              _OverviewLine(title: 'Operations are stable', description: 'Daily workflow is moving normally and no major blocker is visible right now.'),
              _OverviewLine(title: 'Team responsiveness is healthy', description: 'Follow-up quality and response speed are holding a good baseline.'),
              _OverviewLine(title: 'Monitoring remains important', description: 'Keep an eye on alerts, stock movement, and delayed work items.'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Latest Alerts',
          subtitle: 'Recent system notices that may need attention.',
          child: Column(
            children: alerts.map((alert) => AlertTile(alert: alert)).toList(),
          ),
        ),
      ],
    );
  }
}

class AlertTile extends StatelessWidget {
  const AlertTile({super.key, required this.alert});

  final AlertModel alert;

  @override
  Widget build(BuildContext context) {
    final accent = Color(alert.colorHex);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.notifications_active_rounded, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alert.title, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(alert.description, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewLine extends StatelessWidget {
  const _OverviewLine({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFFF7FAF9), borderRadius: BorderRadius.circular(18)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(description, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
          ],
        ),
      ),
    );
  }
}
