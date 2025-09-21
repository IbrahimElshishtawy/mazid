import 'package:flutter/material.dart';
import 'package:mazid/core/data/dummyProducts.dart';
import 'package:mazid/core/models/swap/swap_request_model.dart';
import 'package:mazid/core/models/swap/swap_status.dart';
import 'package:mazid/core/widget/product_swap_card.dart';
import 'package:mazid/pages/Auction/ui/product_detail_page.dart';

class AuctionHomePage extends StatelessWidget {
  const AuctionHomePage({super.key});

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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailPagemazid(product: product),
                ),
              );
            },
            status: SwapStatus.other,
          );
        },
      ),
    );
  }
}
