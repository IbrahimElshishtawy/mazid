import 'package:flutter/material.dart';
import 'package:mazid/core/models/product_models.dart';
import 'package:mazid/core/models/user_model.dart';
import 'package:mazid/pages/home/drawer/Favorites/ui/FavoritesPage.dart';
import 'package:mazid/pages/profile/ui/Profile_Page.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({
    super.key,
    required this.favoriteProducts,
    this.currentUser,
  });

  final List<ProductModel> favoriteProducts;
  final UserModel? currentUser;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.deepOrange],
              ),
            ),
            child: Text(
              "Mazid Menu",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // الصفحة الرئيسية
          ListTile(
            leading: const Icon(Icons.home, color: Colors.orange),
            title: const Text("Home", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          // المفضلة
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.orange),
            title: const Text(
              "Favorites",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context); // يغلق الـ Drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      FavoritesPage(favoriteProducts: favoriteProducts),
                ),
              );
            },
          ),

          // البروفايل
          ListTile(
            leading: const Icon(Icons.person, color: Colors.orange),
            title: const Text("Profile", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context); // يغلق الـ Drawer
              if (currentUser != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfilePage(userId: currentUser!.id),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("User not logged in")),
                );
              }
            },
          ),

          // إضافة منتجات
          ListTile(
            leading: const Icon(Icons.add_box, color: Colors.orange),
            title: const Text(
              "Add Product",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {},
          ),

          // الطلبات الحالية
          ListTile(
            leading: const Icon(Icons.shopping_cart, color: Colors.orange),
            title: const Text("Orders", style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),

          // تاريخ الطلبات
          ListTile(
            leading: const Icon(Icons.history, color: Colors.orange),
            title: const Text(
              "Order History",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {},
          ),

          const Divider(color: Colors.white24),

          // الإعدادات
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.orange),
            title: const Text(
              "Settings",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {},
          ),

          // عن البرنامج
          ListTile(
            leading: const Icon(Icons.info, color: Colors.orange),
            title: const Text("About", style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),

          const Divider(color: Colors.white24),

          // تسجيل الخروج
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
