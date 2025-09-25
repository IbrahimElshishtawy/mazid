// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:m_shop/core/models/swap/swap_request_model.dart';

class SwapHistoryPage extends StatelessWidget {
  final List<SwapProductModel> allProducts;

  const SwapHistoryPage({super.key, required this.allProducts});

  @override
  Widget build(BuildContext context) {
    final history = allProducts
        .where(
          (p) =>
              p.status == "accepted" ||
              p.status == "rejected" ||
              p.status == "completed",
        )
        .toList();

    if (history.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            "لا توجد سجلات طلبات",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("سجل الطلبات"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: ListView.builder(
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

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple.shade100,
                child: Text(
                  item.ownerId.substring(0, 1),
                  style: const TextStyle(color: Colors.deepPurple),
                ),
              ),
              title: Text(
                item.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text("من ${item.ownerId}"),
              trailing: Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
