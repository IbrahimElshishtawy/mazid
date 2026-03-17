import 'package:flutter/material.dart';

class OverviewMetricCard extends StatelessWidget {
  const OverviewMetricCard({
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.cardColor, accent.withValues(alpha: theme.brightness == Brightness.dark ? 0.12 : 0.05)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withValues(alpha: 0.14)),
        boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.08), blurRadius: 18, offset: const Offset(0, 10))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 46, height: 46, decoration: BoxDecoration(color: accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: accent, size: 22)),
          const Spacer(),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: accent.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(999)), child: Text('مركزي', style: TextStyle(color: accent, fontWeight: FontWeight.w800, fontSize: 12))),
        ]),
        const SizedBox(height: 16),
        Text(title, style: TextStyle(color: accent, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text(value, style: theme.textTheme.titleLarge?.copyWith(fontSize: 28, fontWeight: FontWeight.w900, height: 1)),
        const SizedBox(height: 8),
        Text(note, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.5)),
      ]),
    );
  }
}
