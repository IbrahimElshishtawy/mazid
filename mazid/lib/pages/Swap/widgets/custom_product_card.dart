import 'package:flutter/material.dart';

class ProductCardswap extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double rating;
  final VoidCallback onSwapRequest;

  const ProductCardswap({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.onSwapRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900], // خلفية غامقة عشان تناسب الدارك
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المنتج
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            // التفاصيل
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الاسم و أيقونة المقايدة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.swap_horiz,
                        color: Colors.orange,
                        size: 26,
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // التقييم
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 18,
                      );
                    }),
                  ),

                  const SizedBox(height: 10),

                  // زرار تقديم طلب المقايدة
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onSwapRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "تقديم طلب المقايدة",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
