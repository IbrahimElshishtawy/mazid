import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mazid/core/models/swap/swap_request_model.dart';
import 'package:mazid/core/models/swap/swap_status.dart';
import 'package:mazid/core/widget/ProductCardRating.dart';

class SwapProductCard extends StatelessWidget {
  final SwapProductModel product;
  final VoidCallback? onTap;
  final Widget? extraActions;

  const SwapProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.extraActions,
    required SwapStatus status,
  });

  @override
  Widget build(BuildContext context) {
    final String imageUrl = product.imageUrl.isNotEmpty
        ? product.imageUrl
        : 'https://via.placeholder.com/150';

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ✅ قللت ارتفاع الصورة من 140 → 120
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(2),
              ),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 120,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 120,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 50),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(6.0), // ✅ قللت البادينج شوية
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14, // ✅ قللت الفونت شوية
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),

                  ProductCardRating(rating: product.rating),

                  const SizedBox(height: 2),

                  Text(
                    " ${product.price} ج.م",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 13, // ✅ خط السعر أصغر
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
