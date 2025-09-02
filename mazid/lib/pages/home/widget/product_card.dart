// ignore_for_file: unused_import, deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mazid/core/models/product_models.dart';
import 'package:mazid/pages/home/Details/Product_Details_Page.dart';
import 'package:mazid/pages/home/widget/StarRating.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final double imageHeight;
  final double cardWidth;

  const ProductCard({
    super.key,
    required this.product,
    this.imageHeight = 160,
    this.cardWidth = 120,
  });

  String _shortenText(String? text, {int maxLength = 18}) {
    if (text == null || text.isEmpty) return "No Name";
    return text.length > maxLength ? '${text.substring(0, maxLength)}…' : text;
  }

  @override
  Widget build(BuildContext context) {
    final String displayName = product.title.isNotEmpty
        ? _shortenText(product.title, maxLength: 14)
        : _shortenText(product.name, maxLength: 14);

    final String imageUrl = (product.images.isNotEmpty)
        ? product.images.first
        : (product.image.isNotEmpty
              ? product.image
              : 'https://via.placeholder.com/150');

    return GestureDetector(
      onTap: () {
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
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: AspectRatio(
                aspectRatio: 1, // يحافظ على الشكل مربع
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[700],
                      child: const Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.white70,
                          size: 40,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 6),

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

            // التقييم (نجوم)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: StarRating(rating: product.rating),
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
                          try {
                            final supabase = Supabase.instance.client;

                            // هنا حط بيانات المنتج اللي هتجيلك من الموديل
                            final response = await supabase.from('cart').insert(
                              {
                                'product_id': product.id, // ID المنتج
                                'name': product.name, // اسم المنتج
                                'price': product.price, // سعر المنتج
                                'quantity': 1, // الكمية الافتراضية
                                'user_id': supabase
                                    .auth
                                    .currentUser
                                    ?.id, // ID المستخدم الحالي
                              },
                            );

                            if (response.error == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("تمت إضافة المنتج إلى السلة ✅"),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "خطأ: ${response.error!.message}",
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("حصل خطأ: $e")),
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
