import 'package:flutter/material.dart';
import 'package:mazid/core/models/swap_request_model.dart';

class ProductDetailPagemazid extends StatelessWidget {
  final SwapProductModel product;

  const ProductDetailPagemazid({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          product.name,
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Image.network(
            product.imageUrl,
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ListView(
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "\$${product.price}",
                    style: const TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    product.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
