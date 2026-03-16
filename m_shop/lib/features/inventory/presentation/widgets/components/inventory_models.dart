import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class InventorySummary {
  const InventorySummary({
    required this.totalItems,
    required this.totalQuantity,
    required this.lowStockCount,
    required this.safeStockCount,
    required this.stockCoverage,
    required this.restockUnits,
  });

  factory InventorySummary.fromItems(List<InventoryItem> items) {
    if (items.isEmpty) {
      return const InventorySummary(
        totalItems: 0,
        totalQuantity: 0,
        lowStockCount: 0,
        safeStockCount: 0,
        stockCoverage: 0,
        restockUnits: 0,
      );
    }

    final totalQuantity = items.fold<int>(0, (sum, item) => sum + item.quantity);
    final lowStockCount = items.where((item) => item.quantity <= item.minimum).length;
    final restockUnits = items.fold<int>(0, (sum, item) {
      if (item.quantity >= item.minimum) {
        return sum;
      }
      return sum + (item.minimum - item.quantity);
    });
    final stockCoverage = items
            .map((item) => item.minimum == 0 ? 1.0 : item.quantity / item.minimum)
            .reduce(math.max)
            .toDouble();

    return InventorySummary(
      totalItems: items.length,
      totalQuantity: totalQuantity,
      lowStockCount: lowStockCount,
      safeStockCount: items.length - lowStockCount,
      stockCoverage: stockCoverage,
      restockUnits: restockUnits,
    );
  }

  final int totalItems;
  final int totalQuantity;
  final int lowStockCount;
  final int safeStockCount;
  final double stockCoverage;
  final int restockUnits;

  String get healthLabel {
    if (lowStockCount == 0) {
      return 'ممتاز';
    }
    if (lowStockCount <= 1) {
      return 'مستقر';
    }
    return 'بحاجة إلى متابعة';
  }
}

class InventorySnapshot {
  const InventorySnapshot({
    required this.item,
    required this.coverage,
    required this.shortage,
    required this.statusMessage,
    required this.isLowStock,
  });

  factory InventorySnapshot.fromItem(InventoryItem item) {
    final coverage = item.minimum == 0 ? 1.0 : item.quantity / item.minimum;
    final shortage = item.quantity >= item.minimum ? 0 : item.minimum - item.quantity;
    final isLowStock = item.quantity <= item.minimum;
    final statusMessage = isLowStock
        ? 'هذا الصنف أقل من الحد الأدنى ويحتاج إلى طلب توريد أو تحويل من المخزون الاحتياطي.'
        : 'هذا الصنف في وضع آمن حالياً ويمكن الاعتماد عليه في التشغيل اليومي.';

    return InventorySnapshot(
      item: item,
      coverage: coverage,
      shortage: shortage,
      statusMessage: statusMessage,
      isLowStock: isLowStock,
    );
  }

  final InventoryItem item;
  final double coverage;
  final int shortage;
  final String statusMessage;
  final bool isLowStock;
}

class InventoryLayout {
  const InventoryLayout({
    required this.metricCardWidth,
    required this.primaryPanelWidth,
    required this.secondaryPanelWidth,
  });

  factory InventoryLayout.fromWidth(double width) {
    if (width > 1180) {
      return const InventoryLayout(
        metricCardWidth: 248,
        primaryPanelWidth: 720,
        secondaryPanelWidth: 320,
      );
    }
    if (width > 860) {
      return const InventoryLayout(
        metricCardWidth: 220,
        primaryPanelWidth: 520,
        secondaryPanelWidth: 280,
      );
    }

    final panelWidth = math.max(280.0, width - 92).toDouble();
    return InventoryLayout(
      metricCardWidth: panelWidth,
      primaryPanelWidth: panelWidth,
      secondaryPanelWidth: panelWidth,
    );
  }

  final double metricCardWidth;
  final double primaryPanelWidth;
  final double secondaryPanelWidth;
}

class InventoryInsightData {
  const InventoryInsightData({
    required this.title,
    required this.description,
    required this.accent,
    required this.icon,
  });

  final String title;
  final String description;
  final Color accent;
  final IconData icon;
}

class InventoryAllocationData {
  const InventoryAllocationData({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final double amount;
  final Color color;
}

InventoryItem highestStockItem(List<InventoryItem> items) {
  return items.reduce((current, next) => next.quantity > current.quantity ? next : current);
}

InventoryItem highestRiskItem(List<InventoryItem> items) {
  return items.reduce((current, next) {
    final currentCoverage = current.minimum == 0 ? 1.0 : current.quantity / current.minimum;
    final nextCoverage = next.minimum == 0 ? 1.0 : next.quantity / next.minimum;
    return nextCoverage < currentCoverage ? next : current;
  });
}

String formatInventoryNumber(num value) {
  final rounded = value.round().toString();
  final buffer = StringBuffer();

  for (var i = 0; i < rounded.length; i++) {
    final position = rounded.length - i;
    buffer.write(rounded[i]);
    if (position > 1 && position % 3 == 1) {
      buffer.write(',');
    }
  }

  return buffer.toString();
}
