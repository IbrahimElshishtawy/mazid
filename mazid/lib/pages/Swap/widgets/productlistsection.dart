import 'package:flutter/material.dart';
import 'package:mazid/pages/Swap/ui/ProductDetailPage%D8%B2.dart';
import 'package:mazid/pages/Swap/widgets/custom_product_card.dart';

class ProductListSection extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final String type;

  const ProductListSection({
    super.key,
    required this.products,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Text(
          "لا توجد منتجات",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          color: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 4,
          child: ProductCardswap(
            imageUrl: product["imageUrl"],
            name: product["name"],
            rating: product["rating"] ?? 0,
            onSwapRequest: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ProductDetailPage(product: product, type: type),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
