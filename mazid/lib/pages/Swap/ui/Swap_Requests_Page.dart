import 'package:flutter/material.dart';

/// صفحة عرض طلبات التبديل
class SwapRequestsPage extends StatelessWidget {
  const SwapRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // بيانات تجريبية
    final requests = [
      {"user": "أحمد", "product": "موبايل سامسونج", "status": "pending"},
      {"user": "منى", "product": "لاب توب HP", "status": "accepted"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("طلبات التبديل")),
      body: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final req = requests[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(req["product"]!),
              subtitle: Text("من ${req["user"]} - الحالة: ${req["status"]}"),
              trailing: _buildActions(req["status"]!),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActions(String status) {
    if (status == "pending") {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () {},
          ),
        ],
      );
    } else if (status == "accepted") {
      return const Text("✔ تم القبول", style: TextStyle(color: Colors.green));
    } else {
      return const SizedBox.shrink();
    }
  }
}
