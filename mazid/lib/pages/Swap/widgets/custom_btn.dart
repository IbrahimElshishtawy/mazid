import 'package:flutter/material.dart';
import 'package:mazid/core/models/product_models.dart';

/// Widget لعرض كارت منتج.
/// - بياخد [ProductModel] يحتوي على بيانات المنتج.
/// - ممكن يمرر [onRequestSwap] كـ Callback عند الضغط على زر "Request Swap".
class CustomProductCard extends StatelessWidget {
  final ProductModel product; // موديل المنتج (عنوان، صورة، وصف...)
  final VoidCallback? onRequestSwap; // زر لطلب التبديل

  const CustomProductCard({
    super.key,
    required this.product,
    this.onRequestSwap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // ظل للكارت
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ✅ صورة المنتج
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              product.firstImage,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 120,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ✅ عنوان المنتج
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              product.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // ✅ وصف المنتج
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              product.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black54),
            ),
          ),

          // ✅ سعر المنتج
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              "\$${product.price.toStringAsFixed(2)}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
          ),

          const Spacer(),

          // ✅ زر "Request Swap"
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: onRequestSwap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Request Swap"),
            ),
          ),
        ],
      ),
    );
  }
}
