// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:m_shop/core/widget/home/cart/cart_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppbarWidget extends StatefulWidget implements PreferredSizeWidget {
  final ValueChanged<String>? onSearchChanged;

  const AppbarWidget({super.key, this.onSearchChanged});

  @override
  State<AppbarWidget> createState() => _AppbarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppbarWidgetState extends State<AppbarWidget> {
  bool _isSearching = false;
  final TextEditingController _controller = TextEditingController();

  final supabase = Supabase.instance.client;
  int _cartCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchCartCount();

    // 📡 متابعة التغيرات في جدول cart (Realtime) الحديثة
    final user = supabase.auth.currentUser;
    if (user != null) {
      supabase.from('cart').stream(primaryKey: ['id']).listen((event) {
        if (mounted) _fetchCartCount();
      });
    }
  }

  Future<void> _fetchCartCount() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        if (mounted) setState(() => _cartCount = 0);
        return;
      }

      final response = await supabase
          .from('cart')
          .select()
          .eq('user_id', user.id);
      if (mounted) {
        setState(() {
          _cartCount = response.length;
        });
      }
    } catch (e) {
      print("❌ Error fetching cart count: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      iconTheme: const IconThemeData(color: Colors.white),
      title: _isSearching
          ? TextField(
              controller: _controller,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Search products...",
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              onChanged: widget.onSearchChanged,
            )
          : const Text("Mazid Shop", style: TextStyle(color: Colors.white)),
      actions: [
        IconButton(
          icon: Icon(
            _isSearching ? Icons.close : Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              if (_isSearching) {
                _controller.clear();
                widget.onSearchChanged?.call("");
              }
              _isSearching = !_isSearching;
            });
          },
        ),

        // 🛒 زر السلة + Badge
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopify_sharp, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartPage()),
                );
              },
            ),
            if (_cartCount > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$_cartCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(width: 8),
      ],
    );
  }
}
