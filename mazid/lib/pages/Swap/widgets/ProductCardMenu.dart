// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:mazid/core/models/swap_request_model.dart';
import 'package:mazid/core/service/swap_service.dart';

/// Widget عبارة عن قائمة منبثقة (Popup Menu) خاصة بكارت المنتج.
/// - بتظهر على شكل أيقونة (⋮) في الكارت.
/// - المستخدم يقدر يختار منها عمليات زي:
///   1. عرض تفاصيل المنتج.
///   2. إضافة المنتج إلى السلة.
///   3. إزالة المنتج.
///
/// بتستخدم `SwapRequestModel` و `SwapService` عشان تتعامل مع تفاصيل الطلب لو متوفرة.
class ProductCardMenu extends StatelessWidget {
  final SwapRequestModel? swapRequest; // بيانات الطلب (لو متوفرة)
  final SwapService? swapService; // خدمة إدارة الطلبات (لو متوفرة)

  const ProductCardMenu({super.key, this.swapRequest, this.swapService});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.grey[850], // لون خلفية القائمة
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      icon: const Icon(Icons.more_vert, color: Colors.white), // أيقونة القائمة
      // التعامل مع الاختيارات
      onSelected: (value) {
        switch (value) {
          case "details": // عرض التفاصيل
            if (swapRequest != null && swapService != null) {
              // 🔹 هنا ممكن تروح لصفحة تفاصيل المنتج
            } else {
              // لو مفيش بيانات متاحة
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("لا توجد تفاصيل متاحة لهذا المنتج"),
                ),
              );
            }
            break;

          case "cart": // إضافة المنتج للسلة
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("تمت إضافة المنتج إلى السلّة")),
            );
            break;

          case "remove": // إزالة المنتج
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("تمت إزالة المنتج")));
            break;
        }
      },

      // العناصر اللي بتظهر في القائمة
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: "details",
          child: Row(
            children: [
              Icon(Icons.info, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text("عرض التفاصيل"),
            ],
          ),
        ),
        PopupMenuItem(
          value: "cart",
          child: Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text("إضافة إلى السلّة"),
            ],
          ),
        ),
        PopupMenuItem(
          value: "remove",
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red, size: 20),
              SizedBox(width: 8),
              Text("إزالة"),
            ],
          ),
        ),
      ],
    );
  }
}
