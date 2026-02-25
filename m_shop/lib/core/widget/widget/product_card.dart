// ignore_for_file: unused_import, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:m_shop/core/models/prouduct/product_models.dart';
import 'package:m_shop/core/service/cart/cart_service.dart';
import 'package:m_shop/core/widget/widget/ProductCardRating.dart';
import 'package:m_shop/core/cubit/product/product_cubit.dart';
import 'package:m_shop/core/cubit/product/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// 🛒 كارت المنتجات العادية
class ProductCard extends StatelessWidget {
  final ProductModel product;
  final double imageHeight;
  final double cardWidth;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.imageHeight = 160,
    this.cardWidth = 120,
    required this.onTap,
  });

  String _shortenText(String? text, {int maxLength = 18}) {
    if (text == null || text.isEmpty) return "No Name";
    return text.length > maxLength ? '${text.substring(0, maxLength)}…' : text;
  }

  @override
  Widget build(BuildContext context) {
    final String displayName = product.title.isNotEmpty
        ? _shortenText(product.title, maxLength: 12)
        : _shortenText(product.name, maxLength: 12);

    final String imageUrl = (product.images.isNotEmpty)
        ? product.images.first
        : (product.image.isNotEmpty
              ? product.image
              : 'https://via.placeholder.com/150');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.grey.shade900, Colors.grey.shade800],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الصورة
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1, // مربع
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(color: Colors.orange),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[700],
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.white70,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Favorite Icon
                Positioned(
                  top: 8,
                  right: 8,
                  child: BlocBuilder<ProductCubit, ProductState>(
                    builder: (context, state) {
                      bool isFavorite = false;
                      if (state is ProductLoaded) {
                        isFavorite = state.favorites.contains(product.id);
                      }
                      return GestureDetector(
                        onTap: () => context.read<ProductCubit>().toggleFavorite(product.id),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.white,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Discount Badge
                if (product.discountPercentage > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "-${product.discountPercentage.toInt()}%",
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 3),

            // الاسم
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 4),

            // ⭐ التقييم
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ProductCardRating(rating: product.rating),
            ),

            const Spacer(),

            // السعر + زر الإضافة
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "\$${product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Material(
                      color: Colors.orange.withOpacity(0.3),
                      child: InkWell(
                        onTap: () async {
                          final user =
                              Supabase.instance.client.auth.currentUser;
                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("⚠️ لازم تسجّل الدخول أولاً"),
                              ),
                            );
                            return;
                          }

                          final int? productId = int.tryParse(product.id);
                          if (productId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("❌ معرف المنتج غير صحيح"),
                              ),
                            );
                            return;
                          }

                          try {
                            await CartService().addToCart(
                              userId: user.id,
                              productId: productId,
                              name: product.name,
                              price: product.price,
                              imageUrl: product.image.isNotEmpty
                                  ? product.image
                                  : '',
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("✅ تمت إضافة المنتج إلى السلة"),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("❌ حصل خطأ: $e")),
                            );
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.add_shopping_cart,
                            color: Colors.white,
                            size: 18,
                          ),
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
