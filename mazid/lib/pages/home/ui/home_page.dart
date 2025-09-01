import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:mazid/core/API/apilapproduct.dart';
import 'package:mazid/core/models/product_models.dart';
import 'package:mazid/pages/home/widget/product_card.dart';
import 'package:mazid/pages/home/widget/banner.dart';
import 'package:mazid/pages/home/widget/category.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<ProductModel> _fetchProducts() async {
    final dio = Dio();
    final api = ApiLapProduct(dio);
    return await api.getProductById();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            height: 150,
            child: PageView(
              children: const [
                BannerWidget("🔥 Sale up to 50%"),
                BannerWidget("🐶 New Pets Collection"),
                BannerWidget("💻 Latest Electronics"),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // ✅ الكاتيجوري
        SliverToBoxAdapter(
          child: SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                CategoryWidget(Icons.pets, "Pets"),
                CategoryWidget(Icons.shopping_bag, "Clothes"),
                CategoryWidget(Icons.laptop, "Laptops"),
                CategoryWidget(Icons.devices_other, "Electronics"),
                CategoryWidget(Icons.watch, "Accessories"),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),

        // ✅ قائمة المنتجات
        SliverToBoxAdapter(
          child: FutureBuilder<List<ProductModel>>(
            future: _fetchProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.orange),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    "No products found",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final products = snapshot.data!;
              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(product: product); // ⚡ هنا تمرر المنتج
                },
              );
            },
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}
