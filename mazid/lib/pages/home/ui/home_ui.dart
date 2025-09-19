import 'package:flutter/material.dart';
import 'package:mazid/pages/Auction/home/auction_home.dart';
import 'package:mazid/pages/Notifications/NotificationsPage.dart';
import 'package:mazid/pages/Swap/ui/swap_home.dart';
import 'package:mazid/pages/home/controller/home_controller.dart';
import 'package:mazid/pages/home/section/banner_section.dart';
import 'package:mazid/pages/home/section/categories_section.dart';
import 'package:mazid/pages/home/section/products_grid.dart';
import 'package:mazid/pages/profile/ui/Profile_Page.dart';
import 'package:provider/provider.dart';

class HomeUI extends StatelessWidget {
  const HomeUI({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    // إعادة ربط controller مع Provider لو احتجنا
    final ctrl = Provider.of<HomeController>(context);

    List<Widget> pages = [
      NotificationsPage(),
      const AuctionHomePage(),
      _buildHomePage(ctrl),
      _buildSwapPage(ctrl),
      _buildProfilePage(ctrl),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: pages[ctrl.currentIndex],
    );
  }

  // صفحة الرئيسية (Products + Banner + Categories)
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

  // صفحة Swap
  Widget _buildSwapPage(HomeController controller) {
    if (controller.isUserLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orangeAccent),
      );
    }
    return const SwapHome();
  }

  // صفحة Profile
  Widget _buildProfilePage(HomeController controller) {
    if (controller.isUserLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orangeAccent),
      );
    }

    // إذا المستخدم غير موجود، نعتبره ضيف
    final userId = controller.currentUser?.id ?? "guest";
    return ProfilePage(userId: userId);
  }
}
