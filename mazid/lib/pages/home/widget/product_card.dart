// product_card.dart
import 'package:flutter/material.dart';
import 'package:mazid/core/models/product_models.dart';
import 'package:mazid/pages/home/Details/Product_Details_Page.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final double imageHeight;
  final double cardWidth;

  const ProductCard({
    super.key,
    required this.product,
    this.imageHeight = 160,
    this.cardWidth = 90,
  });

  @override
  Widget build(BuildContext context) {
    String displayName = (product.title.isNotEmpty)
        ? (product.title.length > 14
              ? product.title.substring(0, 14) + '…'
              : product.title)
        : product.name;

    return GestureDetector(
      onTap: () {
        // التنقل إلى صفحة تفاصيل المنتج مع تمرير المنتج
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsPage(product: product),
          ),
        );
      },
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.grey.shade900, Colors.grey.shade800],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الصورة
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                product.image,
                height: imageHeight,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return SizedBox(
                    height: imageHeight,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: imageHeight,
                    color: Colors.grey[700],
                    child: const Icon(Icons.error, color: Colors.red),
                  );
                },
              ),
            ),

            const SizedBox(height: 1),

            // الاسم
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 1),

            // التقييم (نجوم)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: List.generate(5, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: Icon(
                      index < 4 ? Icons.star : Icons.star_border,
                      color: Colors.orangeAccent,
                      size: 14,
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 1),

            // السعر + زر الإضافة
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "\$${product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.orange,
                    radius: 18,
                    child: IconButton(
                      icon: const Icon(
                        Icons.add_shopping_cart,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}
