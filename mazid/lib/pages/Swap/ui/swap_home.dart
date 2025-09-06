import 'package:flutter/material.dart';
import 'package:mazid/pages/Swap/widgets/productlistsection.dart';
import 'package:mazid/pages/Swap/widgets/swaptabar.dart';

class SwapHome extends StatelessWidget {
  const SwapHome({super.key});

  // بيانات تجريبية (ممكن تيجي من Firebase بعدين)
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

  final List<Map<String, dynamic>> approvedByMe = const [
    {
      "imageUrl": "https://res.cloudinary.com/.../hp.png",
      "name": "لابتوب Lenovo i5",
    },
    {
      "imageUrl": "https://res.cloudinary.com/.../watch.png",
      "name": "ساعة ذكية",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            const SafeArea(child: SwapTabBar()), // 🔹 الTabs
            Expanded(
              child: TabBarView(
                children: [
                  ProductListSection(products: myProducts, type: "منتجاتي"),
                  ProductListSection(
                    products: acceptedRequests,
                    type: "مقبولة",
                  ),
                  ProductListSection(
                    products: pendingRequests,
                    type: "قيد الانتظار",
                  ),
                  ProductListSection(
                    products: completedRequests,
                    type: "كل الطلبات",
                  ),
                  ProductListSection(
                    products: approvedByMe,
                    type: "موافق عليهم",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
