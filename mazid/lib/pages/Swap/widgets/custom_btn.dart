import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mazid/core/models/swap_request_model.dart';
import 'package:mazid/core/models/swap_status.dart';
import 'package:mazid/pages/Swap/ui/ProductDetailPageswap.dart';

/// زر الكارت بيتغير حسب الحالة
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
        return ElevatedButton(onPressed: () {}, child: const Text("تم الطلب"));

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
