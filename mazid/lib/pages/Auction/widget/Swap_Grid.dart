// ----- SwapGrid (inline) -----
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:mazid/core/models/swap/swap_request_model.dart';
import 'package:mazid/core/models/swap/swap_status.dart';
import 'package:mazid/core/widget/product_swap_card.dart';

class SwapGrid extends StatelessWidget {
  final List<SwapProductModel> products;
  final double childAspectRatio;
  final void Function(SwapProductModel product)? onTap;
  final SwapStatus Function(dynamic) statusOf;

  const SwapGrid({
    super.key,
    required this.products,
    this.childAspectRatio = 0.65,
    required this.statusOf,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const _EmptyState();
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () => onTap?.call(product),
          child: SwapProductCard(
            product: product,

            status: statusOf(product.status),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.white54),
            SizedBox(height: 12),
            Text(
              'لا توجد منتجات مطابقة',
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
