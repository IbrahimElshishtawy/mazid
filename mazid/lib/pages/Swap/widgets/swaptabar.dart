import 'package:flutter/material.dart';

class SwapTabBar extends StatelessWidget {
  final TabController controller;
  const SwapTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Material(
        child: TabBar(
          controller: controller,
          indicatorColor: Colors.orange,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.shopping_bag), text: "منتجات"),
            Tab(icon: Icon(Icons.check_circle), text: "مقبولة"),
            Tab(icon: Icon(Icons.hourglass_bottom), text: "معلقة"),
            Tab(icon: Icon(Icons.trolley), text: "موافقه"),
            Tab(icon: Icon(Icons.done_all), text: "مكتملة"),
          ],
        ),
      ),
    );
  }
}
