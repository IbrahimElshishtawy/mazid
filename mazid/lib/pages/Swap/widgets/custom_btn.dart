import 'package:flutter/material.dart';
import 'package:mazid/core/models/product_models.dart';

class CustomProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onRequestSwap;

  const CustomProductCard({
    super.key,
    required this.product,
    this.onRequestSwap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(product.firstImage, height: 120, fit: BoxFit.cover),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              product.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              product.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text("\$${product.price.toStringAsFixed(2)}"),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: onRequestSwap,
              child: const Text("Request Swap"),
            ),
          ),
        ],
      ),
    );
  }
}
