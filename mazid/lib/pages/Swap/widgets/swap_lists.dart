// swap_lists.dart
// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:mazid/core/models/swap/swap_request_model.dart';
import 'package:mazid/core/models/swap/swap_status.dart';
import 'package:mazid/core/widget/product_card.dart';
import 'package:mazid/core/widget/product_swap_card.dart';

/// 🛍 عرض المنتجات حسب الحالة
class ProductListView extends StatelessWidget {
  final List<SwapProductModel> products;
  final SwapStatus status;

  const ProductListView({
    super.key,
    required this.products,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = products.where((p) {
      switch (status) {
        case SwapStatus.myProducts:
          return true;
        case SwapStatus.accepted:
          return p.status == "accepted";
        case SwapStatus.pending:
          return p.status == "pending";
        default:
          return false;
      }
    }).toList();

    if (filtered.isEmpty) {
      return const Center(
        child: Text("لا يوجد منتجات هنا", style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return SwapProductCard(product: filtered[index], status: status);
      },
    );
  }
}

/// 🔄 تبويب طلبات التبديل (قبول/رفض)
class RequestListView extends StatefulWidget {
  final List<SwapProductModel> products;
  const RequestListView({super.key, required this.products});

  @override
  State<RequestListView> createState() => _RequestListViewState();
}

class _RequestListViewState extends State<RequestListView> {
  @override
  Widget build(BuildContext context) {
    final requests = widget.products
        .where((p) => p.status == "request")
        .toList();

    if (requests.isEmpty) {
      return const Center(
        child: Text(
          "لا يوجد طلبات تبديل",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final req = requests[index];
        return SwapProductCard(
          product: req,
          status: SwapStatus.request,
          extraActions: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() => req.status = "accepted");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("✔ تم قبول ${req.name}"),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("قبول"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() => req.status = "rejected");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("❌ تم رفض ${req.name}"),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("رفض"),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 📝 تبويب السجل (طلبات مقبولة/مرفوضة/مكتملة)
class HistoryListView extends StatelessWidget {
  final List<SwapProductModel> products;
  const HistoryListView({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final history = products
        .where((p) => ["accepted", "rejected", "completed"].contains(p.status))
        .toList();

    if (history.isEmpty) {
      return const Center(
        child: Text(
          "لا توجد سجلات طلبات",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        Color statusColor;
        String statusText;

        switch (item.status) {
          case "accepted":
            statusColor = Colors.green;
            statusText = "✔ تم القبول";
            break;
          case "rejected":
            statusColor = Colors.red;
            statusText = "❌ مرفوض";
            break;
          case "completed":
            statusColor = Colors.blue;
            statusText = "✅ مكتمل";
            break;
          default:
            statusColor = Colors.grey;
            statusText = "غير معروف";
        }

        return SwapProductCard(
          product: item,
          status: SwapStatus.completed,
          extraActions: Text(
            statusText,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
