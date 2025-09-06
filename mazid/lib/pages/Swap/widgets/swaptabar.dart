import 'package:flutter/material.dart';

class SwapTabBar extends StatelessWidget {
  const SwapTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      indicatorColor: Colors.deepOrange,
      labelColor: Colors.deepOrange,
      unselectedLabelColor: Colors.grey,
      isScrollable: true,
      tabs: [
        Tab(icon: Icon(Icons.inventory)), // منتجاتي
        Tab(icon: Icon(Icons.check_circle)), // مقبولة
        Tab(icon: Icon(Icons.hourglass_bottom)), // قيد الانتظار
        Tab(icon: Icon(Icons.history)), // كل الطلبات
        Tab(icon: Icon(Icons.verified_user)), // موافق عليهم
      ],
    );
  }
}
