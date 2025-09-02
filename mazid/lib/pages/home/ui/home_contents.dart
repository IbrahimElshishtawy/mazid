import 'package:flutter/material.dart';
import 'package:mazid/core/models/product_models.dart';
import 'package:mazid/core/service/product_service.dart';
import 'package:mazid/pages/home/widget/AppBar_widget.dart';
import 'package:mazid/pages/home/widget/bottom_NavigationBar.dart';
import 'package:mazid/pages/home/widget/drawer_menu.dart';
import 'package:mazid/pages/home/widget/product_card.dart';
import 'package:mazid/pages/home/widget/banner.dart';
import 'package:mazid/pages/home/widget/category.dart';

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

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    try {
      final products = await _productService.fetchAllProducts();
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
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

    if (_filteredProducts.isEmpty) {
      return const Center(
        child: Text("No products found", style: TextStyle(color: Colors.white)),
      );
    }

    return CustomScrollView(
      slivers: [
        // Banner
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

        // Categories
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

        // Products Grid
        SliverToBoxAdapter(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _filteredProducts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
              return ProductCard(product: product);
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }

  List<Widget> get _pages => [
    const Text("CartPage"), // index 0
    const Text("OrdersPage"), // index 1
    _buildHomePage(), // index 2
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
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
