import 'package:flutter/material.dart';
import 'package:mazid/pages/home/widget/Appbar_widget.dart';
import 'package:mazid/pages/home/widget/banner.dart';
import 'package:mazid/pages/home/widget/category.dart';
import 'package:mazid/pages/home/widget/drawer_menu.dart';
import 'package:mazid/pages/home/widget/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const Center(
      child: Text("Search Page", style: TextStyle(color: Colors.white)),
    ),
    const Center(
      child: Text("Cart Page", style: TextStyle(color: Colors.white)),
    ),
    const Center(
      child: Text("Profile Page", style: TextStyle(color: Colors.white)),
    ),
  ];

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const AppbarWidget(),
      drawer: const DrawerMenu(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// 🌟 المحتوى الأصلي للصفحة الرئيسية
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

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
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              return ProductCard(
                title: "Product ${index + 1}",
                image: "assets/product.png",
                price: 150 + index * 20,
              );
            }, childCount: 6),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}
