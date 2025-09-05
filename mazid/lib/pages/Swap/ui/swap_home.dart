import 'package:flutter/material.dart';
import 'package:mazid/pages/Swap/ui/ProductDetailPage%D8%B2.dart';
import 'package:mazid/pages/Swap/widgets/custom_product_card.dart';

class SwapHome extends StatelessWidget {
  const SwapHome({super.key});

  // بيانات تجريبية (دي المفروض تيجي من Firebase بعدين)
  final List<Map<String, dynamic>> myProducts = const [
    {
      "imageUrl": "https://res.cloudinary.com/.../hp.png",
      "name": "لابتوب HP i7",
      "rating": 4.5,
    },
    {
      "imageUrl": "https://res.cloudinary.com/.../s22.png",
      "name": "موبايل Samsung S22",
      "rating": 5.0,
    },
  ];

  final List<Map<String, dynamic>> acceptedRequests = const [
    {
      "imageUrl": "https://res.cloudinary.com/.../s22.png",
      "name": "موبايل Samsung S22",
    },
  ];

  final List<Map<String, dynamic>> pendingRequests = const [
    {
      "imageUrl": "https://res.cloudinary.com/.../hp.png",
      "name": "لابتوب HP i7",
    },
  ];

  final List<Map<String, dynamic>> completedRequests = const [
    {
      "imageUrl": "https://res.cloudinary.com/.../airpods.png",
      "name": "سماعات AirPods",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            const SafeArea(
              child: TabBar(
                indicatorColor: Colors.deepOrange,
                labelColor: Colors.deepOrange,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(icon: Icon(Icons.inventory)), // منتجاتي
                  Tab(icon: Icon(Icons.check_circle)), // مقبولة
                  Tab(icon: Icon(Icons.hourglass_bottom)), // قيد الانتظار
                  Tab(icon: Icon(Icons.history)), // كل الطلبات
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildProductList(context, myProducts, "منتجاتي"),
                  _buildProductList(context, acceptedRequests, "مقبولة"),
                  _buildProductList(context, pendingRequests, "قيد الانتظار"),
                  _buildProductList(context, completedRequests, "كل الطلبات"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildProductList(
    BuildContext context,
    List<Map<String, dynamic>> products,
    String type,
  ) {
    if (products.isEmpty) {
      return const Center(
        child: Text("لا توجد منتجات", style: TextStyle(color: Colors.white)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCardswap(
          imageUrl: product["imageUrl"],
          name: product["name"],
          rating: product["rating"] ?? 0,
          onSwapRequest: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailPage(product: product, type: type),
              ),
            );
          },
        );
      },
    );
  }
}
