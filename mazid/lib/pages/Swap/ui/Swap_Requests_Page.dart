import 'package:flutter/material.dart';

/// صفحة عرض طلبات التبديل
class SwapRequestsPage extends StatelessWidget {
  const SwapRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // بيانات تجريبية لعدة منتجات
    final requests = [
      {"user": "أحمد", "product": "موبايل سامسونج", "status": "pending"},
      {"user": "منى", "product": "لاب توب HP", "status": "accepted"},
      {"user": "خالد", "product": "سماعات بلوتوث", "status": "rejected"},
      {"user": "ليلى", "product": "كاميرا كانون", "status": "pending"},
      {"user": "سعيد", "product": "ساعة ذكية", "status": "accepted"},
      {"user": "هالة", "product": "تابلت سامسونج", "status": "pending"},
      {"user": "رامي", "product": "سماعات JBL", "status": "rejected"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("طلبات التبديل"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final req = requests[index];
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
                  req["user"]!.substring(0, 1),
                  style: const TextStyle(color: Colors.deepPurple),
                ),
              ),
              title: Text(
                req["product"]!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text("من ${req["user"]}"),
              trailing: _buildActions(req["status"]!),
            ),
          );
        },
      ),
    );
  }

  /// الأزرار أو النص حسب حالة الطلب
  Widget _buildActions(String status) {
    if (status == "pending") {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: () {
              // هنا منطق القبول
              print("تم قبول الطلب");
            },
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () {
              // هنا منطق الرفض
              print("تم رفض الطلب");
            },
          ),
        ],
      );
    } else if (status == "accepted") {
      return const Text(
        "✔ تم القبول",
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      );
    } else if (status == "rejected") {
      return const Text(
        "❌ مرفوض",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
