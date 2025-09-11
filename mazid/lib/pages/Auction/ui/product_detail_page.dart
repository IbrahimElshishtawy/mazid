import 'package:flutter/material.dart';
import 'package:mazid/core/data/dummyProducts.dart';
import 'package:mazid/core/models/product_models.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // فلترة المزايدات الخاصة بالمنتج ده
    final productBids = dummyBids
        .where((bid) => bid["productId"] == product.id)
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.orange),
        title: Text(
          product.name,
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.orange,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // صورة المنتج
          Hero(
            tag: product.id,
            child: Image.network(
              product.image,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // التفاصيل + المزايدات
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ListView(
                children: [
                  // اسم المنتج + السعر
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "\$${product.price}",
                        style: const TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // الشركة والتقييم
                  Row(
                    children: [
                      Icon(
                        Icons.store,
                        color: Colors.orange.shade300,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        product.company,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const Spacer(),
                      Icon(Icons.star, color: Colors.orange.shade300, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        "${product.rating} (${product.ratingCount})",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // الوصف
                  Text(
                    product.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // المزايدات الأخيرة
                  const Text(
                    "أحدث المزايدات",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Divider(color: Colors.orange),

                  if (productBids.isEmpty)
                    const Text(
                      "لا يوجد مزايدات بعد",
                      style: TextStyle(color: Colors.white70),
                    )
                  else
                    Column(
                      children: productBids.map((bid) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.orange.shade700,
                            child: Text(
                              bid["user"][0],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            bid["user"],
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            bid["time"],
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: Text(
                            "\$${bid["amount"]}",
                            style: const TextStyle(
                              color: Colors.orangeAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),

      // زر المزايدة
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.black,
          border: Border(top: BorderSide(color: Colors.orange, width: 1)),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => _showBidDialog(context),
          child: const Text(
            "ضع مزايدة جديدة",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _showBidDialog(BuildContext context) {
    final bidController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "أدخل المزايدة",
          style: TextStyle(color: Colors.orange),
        ),
        content: TextField(
          controller: bidController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "المبلغ",
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.orange),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.orange),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء", style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              Navigator.pop(context);
              // هنا ممكن تضيف منطق إضافة المزايدة في Supabase أو Firestore
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.orange,
                  content: Text(
                    "تم تقديم المزايدة بنجاح!",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
            child: const Text("تأكيد", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
