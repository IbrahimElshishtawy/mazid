import 'package:flutter/material.dart';
import 'package:mazid/core/data/dummyProducts.dart'; // ✅ استدعاء الداتا
import 'package:mazid/pages/Swap/ui/ProductDetailPageswap.dart';
import 'package:mazid/pages/Swap/ui/swap_home.dart';
import 'package:mazid/pages/home/controller/home_controller.dart';
import 'package:mazid/pages/home/section/banner_section.dart';
import 'package:mazid/pages/home/section/categories_section.dart';
import 'package:mazid/pages/home/section/products_grid.dart';
import 'package:mazid/pages/profile/ui/Profile_Page.dart';
import 'package:provider/provider.dart';

class HomeUI extends StatelessWidget {
  const HomeUI({super.key, required HomeController controller});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeController>(context);

    List<Widget> pages = [
      const Center(
        child: Text("CartPage", style: TextStyle(color: Colors.white)),
      ),

      _buildHomePage(controller),
      _buildSwapPage(controller),
      _buildProfilePage(controller),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: pages[controller.currentIndex],
    );
  }

  Widget _buildHomePage(HomeController controller) {
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

        /// ✅ ممكن كمان تستخدم dummyProducts هنا لو عايز تعرضها في ProductsGrid
        SliverToBoxAdapter(
          child: CategoriesSection(
            selectedCategory: controller.selectedCategory,
            onCategorySelected: controller.filterByCategory,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: dummyProducts.isEmpty
              ? const Center(
                  child: Text(
                    "No products found",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ProductsGrid(products: dummyProducts), // ✅ عرض منتجات dummy
        ),
      ],
    );
  }

  Widget _buildSwapPage(HomeController controller) {
    if (controller.isUserLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orangeAccent),
      );
    }
    return const SwapHome();
  }

  Widget _buildProfilePage(HomeController controller) {
    if (controller.isUserLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orangeAccent),
      );
    }
    return ProfilePage(userId: controller.currentUser?.id ?? "guest");
  }
}
