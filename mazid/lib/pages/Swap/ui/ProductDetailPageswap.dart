import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final String type;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.type,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late String currentStatus;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.type; // الحالة الحالية (قيد الانتظار / مقبولة...)
  }

  void approveRequest() {
    setState(() {
      currentStatus = "مقبولة";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("تمت الموافقة على الطلب ✅"),
        backgroundColor: Colors.green,
      ),
    );
  }

  void rejectRequest() {
    setState(() {
      currentStatus = "مرفوضة";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("تم رفض الطلب ❌"),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.product["name"],
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(widget.product["imageUrl"], height: 200),
            const SizedBox(height: 16),
            Text(
              widget.product["name"],
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 12),

            // 🔹 لو الطلب قيد الانتظار → أزرار موافقة / رفض
            if (currentStatus == "قيد الانتظار") ...[
              ElevatedButton.icon(
                onPressed: approveRequest,
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text(
                  "موافقة",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: rejectRequest,
                icon: const Icon(Icons.close, color: Colors.white),
                label: const Text("رفض", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ]
            // 🔹 لو الطلب مقبول → زر للتواصل مع صاحب المنتج
            else if (currentStatus == "مقبولة") ...[
              ElevatedButton.icon(
                onPressed: () {
                  // هنا ممكن تفتح شات مع صاحب المنتج
                },
                icon: const Icon(Icons.chat, color: Colors.white),
                label: const Text(
                  "تواصل مع صاحب المنتج",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
            ]
            // 🔹 لو الطلب مرفوض
            else if (currentStatus == "مرفوضة") ...[
              const Text(
                "تم رفض هذا الطلب",
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
