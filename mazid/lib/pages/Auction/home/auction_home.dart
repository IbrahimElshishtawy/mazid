import 'package:flutter/material.dart';
import 'package:mazid/core/data/dummyProducts.dart';
import 'package:mazid/core/models/swap_request_model.dart';
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

          // ضبط الاسم بحيث لا يزيد عن 14 حرف
          String displayName = product.name.length > 14
              ? '${product.name.substring(0, 14)}...'
              : product.name;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailPagemazid(product: product),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      product.imageUrl,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'asset/image/offer50.png',
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      displayName,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    child: Text(
                      "\$${product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "شارك الآن",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
