import 'package:flutter/material.dart';
import 'package:mazid/core/models/swap_request_model.dart';
import 'package:mazid/core/service/swap_service.dart';
import 'package:mazid/pages/Swap/widgets/ProductCardMenu.dart';
import 'package:mazid/pages/Swap/widgets/ProductCardRating.dart';
import 'package:mazid/pages/Swap/widgets/widget%20bottom/Product_Card_Button_swap.dart';

/// Widget لعرض بطاقة منتج في نظام التبديل (Swap)
/// تحتوي على:
/// - صورة المنتج
/// - اسم المنتج
/// - تقييم المنتج
/// - زر/إجراء لطلب التبديل
/// - قائمة منسدلة (menu) لإدارة الطلب
class ProductCardswap extends StatefulWidget {
  final String imageUrl;
  final String name;
  final double rating;
  final VoidCallback onSwapRequest;
  final SwapRequestModel? swapRequest;
  final SwapService? swapService;
  final String pageType;
  final Widget? actionButton;

  const ProductCardswap({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.onSwapRequest,
    this.swapRequest,
    this.swapService,
    this.pageType = "default",
    this.actionButton,
  });

  @override
  State<ProductCardswap> createState() => _ProductCardswapState();
}

class _ProductCardswapState extends State<ProductCardswap> {
  bool isPending = false;

  @override
  Widget build(BuildContext context) {
    final displayName = widget.name.length > 14
        ? '${widget.name.substring(0, 14)}...'
        : widget.name;

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
                widget.imageUrl,
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
            // تفاصيل الاسم + القائمة + التقييم + الزر
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          displayName,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ProductCardMenu(
                        swapRequest: widget.swapRequest,
                        swapService: widget.swapService,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ProductCardRating(rating: widget.rating),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child:
                        widget.actionButton ??
                        ProductCardButton(
                          pageType: widget.pageType,
                          isPending: isPending,
                          onPressed: () {
                            setState(() => isPending = true);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("تم إرسال طلب التبديل"),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          },
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
