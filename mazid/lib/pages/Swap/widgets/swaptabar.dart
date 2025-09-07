// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class SwapTabBar extends StatelessWidget {
  const SwapTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade900.withOpacity(0.9), Colors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepOrange.withOpacity(0.15),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      padding: const EdgeInsets.all(6),
      child: TabBar(
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(
            width: 3,
            color: Colors.deepOrange, // لون الخط تحت التاب النشط
          ),
          insets: EdgeInsets.symmetric(horizontal: 20), // يتحكم في طول الخط
        ),
        labelColor: Colors.deepOrange, // الأيقونة النشطة
        unselectedLabelColor: Colors.grey, // الأيقونة الغير نشطة
        indicatorPadding: const EdgeInsets.only(top: 35),
        tabs: const [
          Tab(icon: Icon(Icons.swap_horiz, size: 26)), // كل المنتجات
          Tab(icon: Icon(Icons.inventory, size: 26)), // منتجاتي
          Tab(icon: Icon(Icons.check_circle, size: 26)), // تم القبول
          Tab(icon: Icon(Icons.hourglass_bottom, size: 26)), // قيد الانتظار
          Tab(icon: Icon(Icons.history, size: 26)), // مكتملة
          Tab(icon: Icon(Icons.verified_user, size: 26)), // تم الموافقة
        ],
      ),
    );
  }
}
