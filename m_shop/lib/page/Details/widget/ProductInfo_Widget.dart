// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:m_shop/core/models/prouduct/product_models.dart';

class ProductInfoWidget extends StatelessWidget {
  final ProductModel product;
  const ProductInfoWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الاسم
          Text(
            product.title.isNotEmpty ? product.title : product.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // السعر و Stock
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.shade800,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "\$${product.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (product.countInStock <= 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade700,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Out of Stock",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // أيقونات إضافية
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _iconInfo(Icons.category, product.category),
              _iconInfo(Icons.business, product.company),
              _iconInfo(Icons.inventory, "${product.countInStock}"),
            ],
          ),
          const SizedBox(height: 16),
          // التقييم
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < 4 ? Icons.star : Icons.star_border,
                color: Colors.orangeAccent,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _iconInfo(IconData icon, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.orangeAccent),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
