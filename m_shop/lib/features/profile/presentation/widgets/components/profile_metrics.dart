import 'package:flutter/material.dart';

class ProfileMetricCard extends StatelessWidget {
  const ProfileMetricCard({
    super.key,
    required this.width,
    required this.title,
    required this.value,
    required this.note,
    required this.accent,
    required this.icon,
  });

  final double width;
  final String title;
  final String value;
  final String note;
  final Color accent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.cardColor, accent.withValues(alpha: theme.brightness == Brightness.dark ? 0.12 : 0.05)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
        boxShadow: [BoxShadow(color: accent.withValues(alpha: theme.brightness == Brightness.dark ? 0.10 : 0.08), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: accent, size: 18),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: accent.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(999)),
                child: Text('ملكية', style: TextStyle(color: accent, fontWeight: FontWeight.w800, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(title, style: TextStyle(color: accent, fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          Text(value, style: theme.textTheme.titleLarge?.copyWith(fontSize: 23, fontWeight: FontWeight.w900, height: 1)),
          const SizedBox(height: 5),
          Text(note, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.45)),
        ],
      ),
    );
  }
}
