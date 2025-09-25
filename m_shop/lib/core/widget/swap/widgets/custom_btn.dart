import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:m_shop/core/models/prouduct/product_models.dart'
    as pm; // <-- مهم نفس المسار
import 'package:m_shop/core/models/swap/swap_status.dart';
import 'package:m_shop/core/service/product/Product_Details_Page.dart';

/// زر الكارت بيتغير حسب الحالة، مع إضافة إمكانية الموافقة على طلب التبديل
class ProductCardButton extends StatelessWidget {
  final SwapStatus status;
  final pm.BaseProduct
  product; // <-- بدّلناها من SwapProductModel إلى BaseProduct

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
                builder: (context) => ProductDetailsPage(product: product),
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
