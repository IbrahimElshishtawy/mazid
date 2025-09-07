import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;
  final String type;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          product["name"],
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(product["imageUrl"], height: 200),
            const SizedBox(height: 16),
            Text(
              product["name"],
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 12),
            if (type == "قيد الانتظار") ...[
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("تمت الموافقة على الطلب"),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                icon: const Icon(Icons.check),
                label: const Text("موافقة"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("تم رفض الطلب"),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                icon: const Icon(Icons.close),
                label: const Text("رفض"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ] else if (type == "مقبولة") ...[
              ElevatedButton.icon(
                onPressed: () {
                  // تفتح دردشة مع صاحب المنتج
                },
                icon: const Icon(Icons.chat),
                label: const Text("تواصل مع صاحب المنتج"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
