// ignore_for_file: file_names

import 'package:flutter/material.dart';

/// زر مخصص (Button) بيظهر تحت كارت المنتج
/// - بيغيّر شكله ونصه حسب نوع الصفحة (pageType)
/// - لو "منتجاتي" → يظهر زر ثابت يقول "هذا منتجك"
/// - لو "accepted" → يظهر زر أخضر مكتوب "تم القبول"
/// - لو "pending" → يظهر زر برتقالي مكتوب "قيد الانتظار"
/// - غير كده → يظهر زر افتراضي للتبديل (Swap) أو "قيد الانتظار" لو الضغط تم
class ProductCardButton extends StatelessWidget {
  final String pageType; // نوع الصفحة اللي بيحدد شكل الزر
  final bool isPending; // هل الطلب في حالة انتظار ولا لأ
  final VoidCallback onPressed; // الحدث اللي يحصل لما المستخدم يضغط الزر

  const ProductCardButton({
    super.key,
    required this.pageType,
    required this.isPending,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    switch (pageType) {
      // لو المنتج من منتجات المستخدم
      case "myProducts":
        return ElevatedButton.icon(
          onPressed: () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("منتجاتي"))),
          icon: const Icon(Icons.inventory, color: Colors.white),
          label: const Text("هذا منتجك", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

      // لو الطلب تم قبوله
      case "accepted":
        return ElevatedButton.icon(
          onPressed: () {}, // مش بيعمل حاجة (زر ثابت)
          icon: const Icon(Icons.check, color: Colors.white),
          label: const Text("تم القبول", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

      // لو الطلب لسه قيد الانتظار
      case "pending":
        return ElevatedButton.icon(
          onPressed: () {}, // برضه زر ثابت
          icon: const Icon(Icons.hourglass_bottom, color: Colors.white),
          label: const Text(
            "قيد الانتظار",
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

      // الحالة الافتراضية → زر تقديم طلب تبديل
      default:
        return ElevatedButton.icon(
          // لو الطلب في انتظار → الزر يتعطل (null)
          onPressed: isPending ? null : onPressed,
          icon: const Icon(Icons.swap_horiz, color: Colors.white),
          label: Text(
            isPending ? "قيد الانتظار" : "تقديم طلب تبديل",
            style: const TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: isPending ? Colors.orange : Colors.deepOrange,
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
    }
  }
}
