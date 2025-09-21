import 'package:flutter/material.dart';
import 'package:mazid/pages/Auction/ui/intro_Auction_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mazid/pages/Auction/home/auction_home.dart';
import 'package:mazid/pages/Notifications/NotificationsPage.dart';
import 'package:mazid/pages/Swap/ui/swap_home.dart';
import 'package:mazid/pages/home/controller/home_controller.dart';
import 'package:mazid/pages/home/section/banner_section.dart';
import 'package:mazid/pages/home/section/categories_section.dart';
import 'package:mazid/pages/home/section/products_grid.dart';
import 'package:mazid/pages/home/widget/error_view.dart';
import 'package:mazid/pages/profile/ui/Profile_Page.dart';

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
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      );
    }

    if (_showTermsPage) {
      return AuctionTermsPage();
    }

    return Consumer<HomeController>(
      builder: (context, controller, child) {
        List<Widget> pages = [
          NotificationsPage(),
          const AuctionHomePage(),
          _buildHomePage(controller, context),
          _buildSwapPage(controller),
          _buildProfilePage(controller),
        ];

        return Scaffold(
          backgroundColor: Colors.black,
          body: pages[controller.currentIndex],
        );
      },
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

    final userId = controller.currentUser?.id ?? "guest";
    return ProfilePage(userId: userId);
  }
}
