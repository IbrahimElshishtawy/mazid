import 'package:flutter/material.dart';

import 'package:mazid/core/models/swap_request_model.dart';
import 'package:mazid/core/service/swap_service.dart';
import 'package:mazid/pages/Swap/ui/swap_flow_detail_page.dart';

class ProductCardswap extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double rating;
  final VoidCallback onSwapRequest;

  // بيانات الطلب والخدمة
  final SwapRequestModel? swapRequest;
  final SwapService? swapService;

  const ProductCardswap({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.onSwapRequest,
    this.swapRequest,
    this.swapService,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // لو الاسم طويل نقصره
    final displayName = name.length > 14 ? '${name.substring(0, 14)}...' : name;

    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      shadowColor: Colors.deepOrange.withOpacity(0.25),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المنتج
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                height: 90,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 90,
                  width: 80,
                  color: Colors.grey[800],
                  child: const Icon(Icons.broken_image, color: Colors.white54),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // تفاصيل المنتج
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الاسم + القائمة
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          displayName,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      PopupMenuButton<String>(
                        color: Colors.grey[850],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onSelected: (value) {
                          switch (value) {
                            case "details":
                              if (swapRequest != null && swapService != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SwapFlowDetailPage(
                                      swapRequest: swapRequest!,
                                      swapService: swapService!,
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "لا توجد تفاصيل متاحة لهذا المنتج",
                                    ),
                                  ),
                                );
                              }
                              break;
                            case "cart":
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("تمت إضافة المنتج إلى السلّة"),
                                ),
                              );
                              break;
                            case "remove":
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("تمت إزالة المنتج"),
                                ),
                              );
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: "details",
                            child: Row(
                              children: [
                                Icon(Icons.info, color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Text("عرض التفاصيل"),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: "cart",
                            child: Row(
                              children: [
                                Icon(
                                  Icons.shopping_cart,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text("إضافة إلى السلّة"),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: "remove",
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red, size: 20),
                                SizedBox(width: 8),
                                Text("إزالة"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // التقييم
                  Row(
                    children: List.generate(5, (index) {
                      if (index < rating.floor()) {
                        return const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        );
                      } else if (index < rating && rating % 1 != 0) {
                        return const Icon(
                          Icons.star_half,
                          color: Colors.amber,
                          size: 18,
                        );
                      } else {
                        return const Icon(
                          Icons.star_border,
                          color: Colors.amber,
                          size: 18,
                        );
                      }
                    }),
                  ),
                  const SizedBox(height: 10),

                  // زر طلب التبديل
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onSwapRequest,
                      icon: const Icon(Icons.swap_horiz, color: Colors.white),
                      label: const Text(
                        "تقديم طلب تبديل",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
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
