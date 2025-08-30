import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: true, // علشان يظهر زر المنيو تلقائي
        title: const Text("Mazid Store", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: const [
          Icon(Icons.shopping_cart, color: Colors.white),
          SizedBox(width: 16),
        ],
      ),

      // 🔹 Drawer
      drawer: Drawer(
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
            ListTile(
              leading: const Icon(Icons.home, color: Colors.orange),
              title: const Text("Home", style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.search, color: Colors.orange),
              title: const Text(
                "Search",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart, color: Colors.orange),
              title: const Text("Cart", style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.orange),
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {},
            ),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),

      body: ListView(
        children: [
          // 🔹 Banner / Slider
          SizedBox(
            height: 150,
            child: PageView(
              children: [
                banner("🔥 Sale up to 50%"),
                banner("🐶 New Pets Collection"),
                banner("💻 Latest Electronics"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Categories Horizontal
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                category(Icons.pets, "Pets"),
                category(Icons.shopping_bag, "Clothes"),
                category(Icons.laptop, "Laptops"),
                category(Icons.devices_other, "Electronics"),
                category(Icons.watch, "Accessories"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Products Grid
          Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                return productCard(
                  "Product ${index + 1}",
                  "assets/product.png",
                  150 + index * 20,
                );
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white70,
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

  Widget banner(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Colors.orange, Colors.deepOrange],
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget category(IconData icon, String title) {
    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.orange, size: 30),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget productCard(String title, String image, double price) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "\$$price",
              style: const TextStyle(color: Colors.orange, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
