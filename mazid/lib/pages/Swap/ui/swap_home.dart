import 'package:flutter/material.dart';
import 'package:mazid/pages/Swap/widgets/widget%20bottom/productlistsection.dart';
import 'package:mazid/pages/Swap/widgets/swaptabar.dart';

class SwapHome extends StatelessWidget {
  const SwapHome({super.key});

  // بيانات تجريبية
  final List<Map<String, dynamic>> myProducts = const [
    {
      "imageUrl":
          "https://res.cloudinary.com/dzh2hde2n/image/upload/v1684435414/sullwizl2jmwlpczhkhm.png",
      "name": "لابتوب HP i7",
      "rating": 4.5,
    },
    {
      "imageUrl":
          "https://res.cloudinary.com/dzh2hde2n/image/upload/v1684435414/sullwizl2jmwlpczhkhm.png",
      "name": "موبايل Samsung S22",
      "rating": 5.0,
    },
  ];

  final List<Map<String, dynamic>> acceptedRequests = const [
    {
      "imageUrl":
          "https://res.cloudinary.com/dzh2hde2n/image/upload/v1684435414/sullwizl2jmwlpczhkhm.png",
      "name": "موبايل Samsung S22",
    },
  ];

  final List<Map<String, dynamic>> pendingRequests = const [
    {
      "imageUrl":
          "https://res.cloudinary.com/dzh2hde2n/image/upload/v1684435414/sullwizl2jmwlpczhkhm.png",
      "name": "لابتوب HP i7",
    },
  ];

  final List<Map<String, dynamic>> completedRequests = const [
    {
      "imageUrl":
          "https://res.cloudinary.com/dzh2hde2n/image/upload/v1684435414/sullwizl2jmwlpczhkhm.png",
      "name": "سماعات AirPods",
    },
  ];

  final List<Map<String, dynamic>> approvedByMe = const [
    {
      "imageUrl":
          "https://res.cloudinary.com/dzh2hde2n/image/upload/v1684435414/sullwizl2jmwlpczhkhm.png",
      "name": "لابتوب Lenovo i5",
    },
    {
      "imageUrl":
          "https://res.cloudinary.com/dzh2hde2n/image/upload/v1684435414/sullwizl2jmwlpczhkhm.png",
      "name": "ساعة ذكية",
    },
  ];

  // دمج كل المنتجات في قائمة واحدة
  List<Map<String, dynamic>> get allSwapProducts {
    return [
      ...myProducts,
      ...acceptedRequests,
      ...pendingRequests,
      ...completedRequests,
      ...approvedByMe,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6, // عدد التابز بعد إضافة صفحة جديدة
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            const SafeArea(child: SwapTabBar()), // التاب بار
            Expanded(
              child: TabBarView(
                children: [
                  ProductListSection(
                    products: allSwapProducts,
                    pageType: "allSwap",
                  ),
                  ProductListSection(
                    products: myProducts,
                    pageType: "myProducts",
                  ),
                  ProductListSection(
                    products: acceptedRequests,
                    pageType: "accepted",
                  ),
                  ProductListSection(
                    products: pendingRequests,
                    pageType: "pending",
                  ),
                  ProductListSection(
                    products: completedRequests,
                    pageType: "completed",
                  ),
                  ProductListSection(
                    products: approvedByMe,
                    pageType: "approved",
                  ),
                  // صفحة جديدة لكل المنتجات المتاحة للتبديل
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
