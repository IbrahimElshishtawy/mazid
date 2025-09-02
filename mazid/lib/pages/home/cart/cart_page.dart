// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final supabase = Supabase.instance.client;
  late Future<List<dynamic>> cartItemsFuture;

  @override
  void initState() {
    super.initState();
    cartItemsFuture = getCartItems();
  }

  /// جلب المنتجات من جدول cart للمستخدم الحالي فقط
  Future<List<dynamic>> getCartItems() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    final response = await supabase
        .from('cart')
        .select()
        .eq('user_id', user.id);

    return response;
  }

  /// حذف منتج من السلة
  Future<void> removeFromCart(int id) async {
    await supabase.from('cart').delete().eq('id', id);
    if (!mounted) return;
    setState(() {
      cartItemsFuture = getCartItems();
    });
  }

  /// إضافة منتج للسلة (مثال)
  Future<void> addToCart(String name, double price) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase.from('cart').insert({
      'user_id': user.id,
      'name': name,
      'price': price,
      'quantity': 1,
    });

    if (!mounted) return;
    setState(() {
      cartItemsFuture = getCartItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🛒 Cart"),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: cartItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("❌ Error: ${snapshot.error}"));
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(child: Text("السلة فاضية 🛒"));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: const Icon(Icons.shopping_bag),
                  title: Text(item['name'] ?? 'No name'),
                  subtitle: Text(
                    "Price: ${item['price']} | Qty: ${item['quantity']}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => removeFromCart(item['id']),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await addToCart("New Product", 99.9);
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}
