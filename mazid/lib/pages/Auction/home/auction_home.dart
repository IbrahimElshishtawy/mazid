import 'package:flutter/material.dart';
import 'package:mazid/core/data/dummyProducts.dart';
import 'package:mazid/core/models/swap/swap_request_model.dart';
import 'package:mazid/core/models/swap/swap_status.dart';
import 'package:mazid/core/widget/product_swap_card.dart';
import 'package:mazid/pages/Auction/ui/product_detail_page.dart';

class AuctionHomePage extends StatelessWidget {
  const AuctionHomePage({super.key});
  SwapStatus _mapStatus(dynamic status) {
    if (status is SwapStatus) return status;
    switch (status.toString().toLowerCase()) {
      case "pending":
        return SwapStatus.pending;
      case "sold":
        return SwapStatus.sold;
      case "available":
      default:
        return SwapStatus.available;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummySwapProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) {
          final SwapProductModel product = dummySwapProducts[index];
          return SwapProductCard(
            product: product,
            status: _mapStatus(product.status), // ✅ تحويل String → Enum
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailPagemazid(product: product),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
