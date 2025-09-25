// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:m_shop/core/widget/home/widget/error_view.dart';
import 'package:m_shop/page/Notifications/NotificationsPage.dart';
import 'package:m_shop/page/home/controller/home_controller.dart';
import 'package:m_shop/page/home/section/banner_section.dart';
import 'package:m_shop/page/home/section/categories_section.dart';
import 'package:m_shop/page/home/section/products_grid.dart';
import 'package:m_shop/page/profile/ui/Profile_Page.dart';
import 'package:m_shop/page/swap/ui/swap_home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  bool _showTermsPage = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkAuctionTerms();
  }

  Future<void> _checkAuctionTerms() async {
    final prefs = await SharedPreferences.getInstance();
    final accepted = prefs.getBool('auction_terms_accepted') ?? false;

    setState(() {
      _showTermsPage = !accepted;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Scaffold واحد ثابت، وكل المحتوى جواه
    return Scaffold(
      backgroundColor: Colors.black,
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : _showTermsPage
          ? null //const AuctionHomePage()
          : Consumer<HomeController>(
              builder: (context, controller, child) {
                final pages = <Widget>[
                  NotificationsPage(),
                  // const AuctionHomePage(),
                  _buildHomePage(controller, context),
                  _buildSwapPage(controller),
                  _buildProfilePage(controller),
                ];

                return IndexedStack(
                  index: controller.currentIndex,
                  children: pages,
                );
              },
            ),
    );
  }

  Widget _buildHomePage(HomeController controller, BuildContext context) {
    if (controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      );
    }

    if ((controller.errorMessage).isNotEmpty) {
      return ErrorView(
        message: controller.errorMessage,
        onRetry: () => controller.init(context),
      );
    }

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: BannerSection()),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: CategoriesSection(
            selectedCategory: controller.selectedCategory ?? "",
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

  /// قسم الـ Swap (بدون Scaffold)
  Widget _buildSwapPage(HomeController controller) {
    if (controller.isUserLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orangeAccent),
      );
    }
    return const SwapHome();
  }

  /// قسم البروفايل (بدون Scaffold)
  Widget _buildProfilePage(HomeController controller) {
    if (controller.isUserLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orangeAccent),
      );
    }

    final userId = controller.currentUser?.id ?? "guest";
    return ProfilePage(userId: userId);
  }
}
