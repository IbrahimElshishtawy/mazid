// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:m_shop/core/models/prouduct/product_models.dart';

class OrderModel {
  final ProductModel product;
  final int quantity;
  final DateTime orderDate;

  OrderModel({
    required this.product,
    required this.quantity,
    required this.orderDate,
  });
}

class OrdersPage extends StatelessWidget {
  final List<OrderModel> orders;

  const OrdersPage({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: orders.isEmpty
          ? const Center(
              child: Text(
                "You have no orders yet.",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _buildOrderCard(order);
              },
            ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            order.product.firstImage,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          order.product.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              "\$${order.product.price.toStringAsFixed(2)} x ${order.quantity}",
              style: const TextStyle(color: Colors.orange),
            ),
            const SizedBox(height: 2),
            Text(
              "Ordered on: ${_formatDate(order.orderDate)}",
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }
}
