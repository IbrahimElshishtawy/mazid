import 'package:flutter/material.dart';

/// التاب بار الخاص بالتبديل
class SwapTabBar extends StatelessWidget implements PreferredSizeWidget {
  const SwapTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      isScrollable: true,
      indicatorColor: Colors.orange,
      labelColor: Colors.orange,
      unselectedLabelColor: Colors.grey,
      tabs: [
        Tab(text: "منتجاتي"),
        Tab(text: "المقبولة"),
        Tab(text: "المعلقة"),
        Tab(text: "الطلبات"),
        Tab(text: "المكتملة"),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
