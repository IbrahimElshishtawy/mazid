import 'package:flutter/material.dart';

class ProductivityMetricCard extends StatelessWidget {
  const ProductivityMetricCard({
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
    return Container(
      width: width,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Theme.of(context).cardColor, const Color(0xFF0F766E).withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.10 : 0.04)],
        ),
        border: Border.all(color: accent.withValues(alpha: 0.14)),
        boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.08), blurRadius: 18, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)),
                child: Icon(icon, color: accent),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: accent.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(999)),
                child: Text('مباشر', style: TextStyle(color: accent, fontWeight: FontWeight.w800, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(title, style: TextStyle(color: accent, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, height: 1)),
          const SizedBox(height: 8),
          Text(note, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
        ],
      ),
    );
  }
}



