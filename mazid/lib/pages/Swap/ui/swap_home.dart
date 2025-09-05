import 'package:flutter/material.dart';
import 'package:mazid/pages/Swap/widgets/custom_product_card.dart';

class SwapHome extends StatelessWidget {
  const SwapHome({super.key});

  // بيانات المنتجات (ممكن بعدين تجيبها من Firebase أو API)
  final List<Map<String, dynamic>> myProducts = const [
    {
      "imageUrl": "asset/image/intro2.jpg",
      "name": "لابتوب HP i7",
      "rating": 4.5,
    },
    {
      "imageUrl": "asset/image/intro2.jpg",
      "name": "موبايل Samsung S22",
      "rating": 5.0,
    },
    {
      "imageUrl": "asset/image/intro2.jpg",
      "name": "سماعات AirPods",
      "rating": 3.5,
    },
    {"imageUrl": "asset/image/intro2.jpg", "name": "ساعة ذكية", "rating": 4.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: myProducts.length,
        itemBuilder: (context, index) {
          final product = myProducts[index];
          return ProductCardswap(
            imageUrl: product["imageUrl"],
            name: product["name"],
            rating: product["rating"],
            onSwapRequest: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("تم إرسال طلب مقايضة لـ ${product["name"]}"),
                  backgroundColor: Colors.deepOrange,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
