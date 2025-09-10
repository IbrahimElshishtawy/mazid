import 'package:flutter/material.dart';
import 'package:mazid/core/models/swap_request_model.dart';
import 'package:mazid/core/models/swap_status.dart';
import 'package:mazid/pages/Swap/widgets/ProductCardMenu.dart';
import 'package:mazid/pages/Swap/widgets/custom_btn.dart';
import 'package:mazid/pages/Swap/widgets/ProductCardRating.dart'; // ويدجت الريتنج

/// الكارت الرئيسي لمنتجات التبديل
class ProductCardswap extends StatelessWidget {
  final SwapProductModel product;
  final SwapStatus status;
  final Widget? extraActions; // ✅ باراميتر اختياري

  const ProductCardswap({
    super.key,
    required this.product,
    required this.status,
    this.extraActions, // ✅ ممكن تمرره أو لا
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المنتج
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              product.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // تفاصيل المنتج
          ListTile(
            title: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text("السعر: ${product.price.toStringAsFixed(2)} جنيه"),
                const SizedBox(height: 4),
                Row(
                  children: [
                    ProductCardRating(rating: product.rating), // ⭐
                    const SizedBox(width: 4),
                    Text(product.rating.toStringAsFixed(1)),
                  ],
                ),
              ],
            ),
            trailing: ProductCardMenu(product: product),
          ),

          // الأزرار أو الأكشن الإضافي
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                extraActions ??
                ProductCardButton(
                  status: status,
                  product: product,
                ), // ✅ لو extraActions موجودة هتظهر مكان الزرار
          ),
        ],
      ),
    );
  }
}
