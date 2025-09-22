import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mazid/core/models/swap/swap_request_model.dart';
import 'package:mazid/core/models/swap/swap_status.dart';
import 'package:mazid/core/widget/ProductCardRating.dart';

class SwapProductCard extends StatelessWidget {
  final SwapProductModel product;
  final VoidCallback? onTap;
  final Widget? extraActions;
  final SwapStatus status;

  const SwapProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.extraActions,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final String imageUrl = product.imageUrl.isNotEmpty
        ? product.imageUrl
        : 'https://via.placeholder.com/150';

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // 🔹 بقى أنعم شوية
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 صورة أصغر شوية
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 110,
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 110,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 40),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 اسم المنتج
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  /// 🔹 الوصف
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 3),

                  /// 🔹 التقييم
                  ProductCardRating(rating: product.rating),

                  const SizedBox(height: 3),

                  /// 🔹 السعر
                  Text(
                    " ${product.price} ج.م",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 12,
                    ),
                  ),

                  /// 🔹 حالة الـ Swap (مربوطة بـ status)
                  Text(
                    status == SwapStatus.pending
                        ? "في الانتظار"
                        : status == SwapStatus.accepted
                        ? "تم القبول"
                        : "مرفوض",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: status == SwapStatus.accepted
                          ? Colors.green
                          : status == SwapStatus.rejected
                          ? Colors.red
                          : Colors.orange,
                    ),
                  ),
                ],
              ),
            ),

            if (extraActions != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: extraActions!,
              ),
          ],
        ),
      ),
    );
  }
}
