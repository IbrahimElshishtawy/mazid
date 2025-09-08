import 'package:flutter/material.dart';
import 'package:mazid/core/models/swap_request_model.dart';
import 'package:mazid/core/models/swap_status.dart';
import 'package:mazid/pages/Swap/widgets/ProductCardMenu.dart';
import 'package:mazid/pages/Swap/widgets/custom_btn.dart';

/// الكارت الرئيسي لمنتجات التبديل
class ProductCardswap extends StatelessWidget {
  final SwapProductModel product;
  final SwapStatus status;

  const ProductCardswap({
    super.key,
    required this.product,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 3,
      child: Column(
        children: [
          Image.network(
            product.imageUrl,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          ListTile(
            title: Text(product.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text("السعر: ${product.price.toStringAsFixed(2)} جنيه"),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(product.rating.toStringAsFixed(1)),
                  ],
                ),
              ],
            ),
            trailing: ProductCardMenu(product: product),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProductCardButton(status: status, product: product),
          ),
        ],
      ),
    );
  }
}
