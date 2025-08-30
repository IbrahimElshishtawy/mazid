import 'package:flutter/material.dart';
import 'package:mazid/pages/home/widget/Appbar_widget.dart';
import 'package:mazid/pages/home/widget/banner.dart';
import 'package:mazid/pages/home/widget/bottom_NavigationBar.dart';
import 'package:mazid/pages/home/widget/category.dart';
import 'package:mazid/pages/home/widget/drawer_menu.dart';
import 'package:mazid/pages/home/widget/product_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const AppbarWidget(),
      drawer: const DrawerMenu(),
      body: ListView(
        children: [
          // 🔹 Banner / Slider
          SizedBox(
            height: 150,
            child: PageView(
              children: const [
                BannerWidget("🔥 Sale up to 50%"),
                BannerWidget("🐶 New Pets Collection"),
                BannerWidget("💻 Latest Electronics"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Categories Horizontal
          SizedBox(
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

          const SizedBox(height: 20),

          // 🔹 Products Grid
          Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                return ProductCard(
                  title: "Product ${index + 1}",
                  image: "assets/product.png",
                  price: 150 + index * 20,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigationbarWidget(),
    );
  }
}
