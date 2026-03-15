import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class InventorySection extends StatelessWidget {
  const InventorySection({super.key, required this.inventory});

  final List<InventoryItem> inventory;

  @override
  Widget build(BuildContext context) {
    final lowStockItems = inventory.where((item) => item.quantity <= item.minimum).toList();
    final safeItems = inventory.length - lowStockItems.length;
    final totalQuantity = inventory.fold<int>(0, (sum, item) => sum + item.quantity);

    return SectionCard(
      title: 'Inventory',
      subtitle: 'Stock availability, risk items, and warehouse movement overview.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              InventoryStatCard(
                title: 'Items',
                value: inventory.length.toString(),
                note: 'Tracked stock records',
                color: const Color(0xFF0F766E),
                icon: Icons.inventory_2_rounded,
              ),
              InventoryStatCard(
                title: 'Safe Stock',
                value: safeItems.toString(),
                note: 'Items above minimum',
                color: const Color(0xFF16A34A),
                icon: Icons.verified_rounded,
              ),
              InventoryStatCard(
                title: 'Low Stock',
                value: lowStockItems.length.toString(),
                note: 'Need restock soon',
                color: const Color(0xFFDC2626),
                icon: Icons.warning_amber_rounded,
              ),
              InventoryStatCard(
                title: 'Total Units',
                value: totalQuantity.toString(),
                note: 'Combined quantity in storage',
                color: const Color(0xFF2563EB),
                icon: Icons.warehouse_rounded,
              ),
            ],
          ),
          const SizedBox(height: 18),
          const SectionCard(
            title: 'Inventory Notes',
            subtitle: 'Main warehouse observations and supply handling reminders.',
            child: Column(
              children: [
                InventoryNoteLine(
                  title: 'Restock low items early',
                  description: 'Items below minimum should be replenished before demand peaks.',
                ),
                InventoryNoteLine(
                  title: 'Review movement frequency',
                  description: 'Fast-moving products need tighter monitoring and reorder timing.',
                ),
                InventoryNoteLine(
                  title: 'Keep buffer stock',
                  description: 'Critical items should maintain a healthy safety margin in storage.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionCard(
            title: 'Inventory Items',
            subtitle: 'Detailed stock cards for all tracked inventory entries.',
            child: Column(
              children: inventory.map((item) => InventoryTile(item: item)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class InventoryStatCard extends StatelessWidget {
  const InventoryStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.note,
    required this.color,
    required this.icon,
  });

  final String title;
  final String value;
  final String note;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const Spacer(),
              Container(
                width: 34,
                height: 4,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(note, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
        ],
      ),
    );
  }
}

class InventoryTile extends StatelessWidget {
  const InventoryTile({super.key, required this.item});

  final InventoryItem item;

  @override
  Widget build(BuildContext context) {
    final lowStock = item.quantity <= item.minimum;
    final accent = lowStock ? const Color(0xFFDC2626) : const Color(0xFF0F766E);
    final status = lowStock ? 'Low Stock' : 'Healthy';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2ECE8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: accent, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _InventoryMetric(
                  label: 'Quantity',
                  value: item.quantity.toString(),
                  color: const Color(0xFF2563EB),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InventoryMetric(
                  label: 'Minimum',
                  value: item.minimum.toString(),
                  color: const Color(0xFFF59E0B),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InventoryMetric(
                  label: 'Unit',
                  value: item.unit,
                  color: accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InventoryMetric extends StatelessWidget {
  const _InventoryMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class InventoryNoteLine extends StatelessWidget {
  const InventoryNoteLine({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAF9),
          borderRadius: BorderRadius.circular(18),
        ),
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
