import 'package:flutter/material.dart';
import 'package:mazid/pages/Swap/ui/SwapRequestPage.dart';
import 'package:mazid/pages/home/controller/home_controller.dart';
import 'package:mazid/pages/home/section/banner_section.dart';
import 'package:mazid/pages/home/section/categories_section.dart';
import 'package:mazid/pages/home/section/products_grid.dart';
import 'package:mazid/pages/profile/ui/Profile_Page.dart';
import 'package:mazid/pages/Auction/ui/auction_list_page.dart';

class HomeUI extends StatelessWidget {
  final HomeController controller;
  const HomeUI({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const Center(child: Text("CartPage")),
      const AuctionListPage(),
      _buildHomePage(),
      if (controller.currentUser != null)
        SwapRequestPage(
          swapService: controller.swapService,
          currentUserId: controller.currentUser!.id,
        )
      else
        const Center(
          child: CircularProgressIndicator(color: Colors.orangeAccent),
        ),

      if (controller.currentUser != null)
        ProfilePage(userId: controller.currentUser!.id)
      else
        const Center(
          child: CircularProgressIndicator(color: Colors.orangeAccent),
        ),
    ];

    return pages[controller.currentIndex];
  }

  Widget _buildHomePage() {
    if (controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      );
    }
    if (controller.errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          "Error: ${controller.errorMessage}",
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: BannerSection()),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: CategoriesSection(
            selectedCategory: controller.selectedCategory,
            onCategorySelected: controller.filterByCategory,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: controller.filteredProducts.isEmpty
              ? const Center(
                  child: Text(
                    "No products found",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ProductsGrid(products: controller.filteredProducts),
        ),
      ],
    );
  }
}
