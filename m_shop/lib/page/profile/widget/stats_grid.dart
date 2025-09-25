// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class StatsGrid extends StatelessWidget {
  final int? totalPurchases;
  final int? totalCancelledOrders;
  final int? pendingOrders;
  final int? receivedOrders;
  final int? unreceivedOrders;
  final int? totalSales;
  final int? totalAuctions;
  final double? totalSpent;
  final double? totalEarned;

  const StatsGrid({
    super.key,
    this.totalPurchases,
    this.totalCancelledOrders,
    this.pendingOrders,
    this.receivedOrders,
    this.unreceivedOrders,
    this.totalSales,
    this.totalAuctions,
    this.totalSpent,
    this.totalEarned,
  });

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        "icon": Icons.shopping_cart,
        "label": "المشتريات",
        "value": totalPurchases,
        "color": Colors.orangeAccent,
      },
      {
        "icon": Icons.cancel,
        "label": "الطلبات الملغاة",
        "value": totalCancelledOrders,
        "color": Colors.redAccent,
      },
      {
        "icon": Icons.hourglass_bottom,
        "label": "الطلبات المعلقة",
        "value": pendingOrders,
        "color": Colors.yellowAccent,
      },
      {
        "icon": Icons.done_all,
        "label": "الطلبات المستلمة",
        "value": receivedOrders,
        "color": Colors.greenAccent,
      },
      {
        "icon": Icons.access_time,
        "label": "الطلبات غير المستلمة",
        "value": unreceivedOrders,
        "color": Colors.blueAccent,
      },
      {
        "icon": Icons.sell,
        "label": "المبيعات",
        "value": totalSales,
        "color": Colors.purpleAccent,
      },
      {
        "icon": Icons.gavel,
        "label": "المزادات",
        "value": totalAuctions,
        "color": Colors.tealAccent,
      },
      {
        "icon": Icons.attach_money,
        "label": "الإنفاق",
        "value": totalSpent,
        "color": Colors.redAccent,
      },
      {
        "icon": Icons.account_balance_wallet,
        "label": "الأرباح",
        "value": totalEarned,
        "color": Colors.lightGreenAccent,
      },
      {
        "icon": Icons.money_off,
        "label": "الخسائر",
        "value": totalSpent != null && totalEarned != null
            ? totalSpent! - totalEarned!
            : 0.0,
        "color": Colors.redAccent,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: stats.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2.2,
        ),
        itemBuilder: (context, index) {
          final stat = stats[index];
          final value = stat["value"] != null
              ? (stat["value"] is double
                    ? stat["value"] as double
                    : (stat["value"] as int).toDouble())
              : 0.0;
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (stat["color"] as Color).withOpacity(0.3),
                  Colors.grey.shade800.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: (stat["color"] as Color).withOpacity(0.6),
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.all(6),
            child: Row(
              children: [
                Icon(
                  stat["icon"] as IconData,
                  color: stat["color"] as Color,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    stat["label"] as String,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
                Text(
                  (stat["label"] == "الإنفاق" ||
                          stat["label"] == "الأرباح" ||
                          stat["label"] == "الخسائر")
                      ? "\$${value.toStringAsFixed(2)}"
                      : value.toInt().toString(),
                  style: TextStyle(
                    color: stat["color"] as Color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
