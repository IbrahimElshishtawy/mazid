import 'package:flutter/material.dart';
import 'package:mazid/core/service/cart_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();
  final userId = Supabase.instance.client.auth.currentUser?.id;

  Future<List<Map<String, dynamic>>> _fetchCart() async {
    if (userId == null) return [];
    return await _cartService.getCart(userId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🛒 سلة المشتريات"),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: _fetchCart(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final cartItems = snapshot.data!;
          if (cartItems.isEmpty) {
            return const Center(child: Text("السلة فارغة"));
          }

          double total = 0;
          for (var item in cartItems) {
            total += item['price'] * item['quantity'];
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: Image.network(
                          item['image_url'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(item['name']),
                        subtitle: Text(
                          "السعر: ${item['price']} × ${item['quantity']}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle),
                              onPressed: () async {
                                await _cartService.updateQuantity(
                                  item['id'],
                                  item['quantity'] - 1,
                                );
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle),
                              onPressed: () async {
                                await _cartService.updateQuantity(
                                  item['id'],
                                  item['quantity'] + 1,
                                );
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await _cartService.deleteItem(item['id']);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.black12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "الإجمالي: $total",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: إضافة عملية الطلب
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("تم تنفيذ الطلب ✅")),
                        );
                      },
                      child: const Text("تنفيذ الطلب"),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
