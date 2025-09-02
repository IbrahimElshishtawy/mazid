// lib/pages/home/home_contents.dart
import 'package:flutter/material.dart';
import 'package:mazid/core/models/product_models.dart';
import 'package:mazid/core/service/product_service.dart';
import 'package:mazid/pages/home/section/banner_section.dart';
import 'package:mazid/pages/home/section/categories_section.dart';
import 'package:mazid/pages/home/section/products_grid.dart';
import 'package:mazid/pages/home/widget/AppBar_widget.dart';
import 'package:mazid/pages/home/widget/bottom_NavigationBar.dart';
import 'package:mazid/pages/home/widget/drawer_menu.dart';

class HomeContents extends StatefulWidget {
  const HomeContents({super.key});

  @override
  State<HomeContents> createState() => _HomeContentsState();
}

class _HomeContentsState extends State<HomeContents> {
  final ProductService _productService = ProductService();
  int _currentIndex = 2;

  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    try {
      final products = await _productService.fetchAllProducts();
      if (!mounted) return;
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    if (!mounted) return;
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts
            .where(
              (p) =>
                  p.name.toLowerCase().contains(query.toLowerCase()) ||
                  p.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
      _selectedCategory = "All";
    });
  }

  void _filterByCategory(String category) {
    if (!mounted) return;

    final Map<String, String> apiCategories = {
      "All": "all",
      "Cosmetic": "beauty",
      "Clothes": "clothing",
      "Laptops": "laptops",
      "Electronics": "electronics",
      "Accessories": "accessories",
    };

    setState(() {
      _selectedCategory = category;

      if (category == "All") {
        _filteredProducts = _allProducts;
      } else {
        final apiCategory =
            apiCategories[category]?.toLowerCase() ?? category.toLowerCase();

        _filteredProducts = _allProducts.where((p) {
          final productCategory = (p.category).toLowerCase();
          return productCategory.contains(apiCategory);
        }).toList();
      }
    });
  }

  Widget _buildHomePage() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          "Error: $_errorMessage",
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
            selectedCategory: _selectedCategory,
            onCategorySelected: _filterByCategory, // ✅ هنا بيعمل فلترة مظبوطة
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: _filteredProducts.isEmpty
              ? const Center(
                  child: Text(
                    "No products found",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ProductsGrid(products: _filteredProducts),
        ),
      ],
    );
  }

  /// الصفحات الخاصة بالـ BottomNavigationBar
  List<Widget> get _pages => [
    const Text("CartPage"), // index 0
    const Text("OrdersPage"), // index 1
    _buildHomePage(), // ✅ هنا الـ HomePage اللي فيها الفلترة
    const Text("text"), // index 3
    const Text("profile"), // index 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(onSearchChanged: _onSearchChanged),
      backgroundColor: Colors.black,
      drawer: DrawerMenu(),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationbarWidget(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (!mounted) return;
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
