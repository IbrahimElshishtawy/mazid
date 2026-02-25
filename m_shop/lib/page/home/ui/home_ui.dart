// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_shop/core/cubit/auth/auth_cubit.dart';
import 'package:m_shop/core/cubit/auth/auth_state.dart';
import 'package:m_shop/core/cubit/navigation/navigation_cubit.dart';
import 'package:m_shop/core/cubit/product/product_cubit.dart';
import 'package:m_shop/core/cubit/product/product_state.dart';
import 'package:m_shop/page/action/home/auction_home_page.dart';
import 'package:m_shop/page/swap/ui/swap_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:m_shop/core/widget/home/widget/error_view.dart';
import 'package:m_shop/page/Notifications/NotificationsPage.dart';
import 'package:m_shop/page/home/section/ads_section.dart';
import 'package:m_shop/page/home/section/banner_section.dart';
import 'package:m_shop/page/home/section/categories_section.dart';
import 'package:m_shop/page/home/section/products_grid.dart';
import 'package:m_shop/page/profile/ui/Profile_Page.dart';

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
    return Scaffold(
      backgroundColor: Colors.black,
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : _showTermsPage
          ? null
          : BlocBuilder<NavigationCubit, int>(
              builder: (context, currentIndex) {
                final pages = <Widget>[
                  NotificationsPage(),
                  AuctionHomePage(),
                  _buildHomePage(context),
                  SwapHome(),
                  _buildProfilePage(context),
                ];

                return IndexedStack(
                  index: currentIndex,
                  children: pages,
                );
              },
            ),
    );
  }

  Widget _buildHomePage(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator(color: Colors.orange));
        }

        if (state is ProductError) {
          return ErrorView(
            message: state.message,
            onRetry: () => context.read<ProductCubit>().fetchProducts(),
          );
        }

        if (state is ProductLoaded) {
          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: BannerSection()),
              const SliverToBoxAdapter(child: AdsSection()),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(
                child: CategoriesSection(
                  selectedCategory: "", // Needs logic to track selected category in ProductCubit if needed
                  onCategorySelected: (cat) => context.read<ProductCubit>().filterProducts("", cat),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(
                child: state.filteredProducts.isEmpty
                    ? const Center(
                        child: Text(
                          "No products found",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ProductsGrid(products: state.filteredProducts),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildProfilePage(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator(color: Colors.orangeAccent));
        }
        final userId = (state is Authenticated) ? state.user.id : "guest";
        return ProfilePage(userId: userId);
      },
    );
  }
}
