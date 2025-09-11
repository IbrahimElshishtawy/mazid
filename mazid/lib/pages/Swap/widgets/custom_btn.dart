import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mazid/core/models/swap_request_model.dart';
import 'package:mazid/core/models/swap_status.dart';
import 'package:mazid/pages/Swap/ui/ProductDetailPageswap.dart';

/// زر الكارت بيتغير حسب الحالة، مع إضافة إمكانية الموافقة على طلب التبديل
class ProductCardButton extends StatelessWidget {
  final SwapStatus status;
  final SwapProductModel product;

  const ProductCardButton({
    super.key,
    required this.status,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case SwapStatus.myProducts:
        return ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(product: product),
              ),
            );
          },
          child: const Text("تفاصيل"),
        );

      case SwapStatus.accepted:
        return ElevatedButton(onPressed: () {}, child: const Text("تم القبول"));

      case SwapStatus.pending:
        return ElevatedButton(onPressed: () {}, child: const Text("معلق"));

      case SwapStatus.request:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                // منطق الموافقة على الطلب
                if (kDebugMode) {
                  print("تم قبول طلب التبديل للمنتج ${product.name}");
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("قبول"),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                // منطق رفض الطلب
                if (kDebugMode) {
                  print("تم رفض طلب التبديل للمنتج ${product.name}");
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("رفض"),
            ),
          ],
        );

      case SwapStatus.completed:
        return ElevatedButton(
          onPressed: () {},
          child: const Text("تم الإتمام"),
        );

      case SwapStatus.approved:
        return ElevatedButton(
          onPressed: () {},
          child: const Text("تمت الموافقة"),
        );

      default:
        return ElevatedButton(onPressed: () {}, child: const Text("غير معروف"));
    }
  }
}
