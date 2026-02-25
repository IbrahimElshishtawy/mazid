import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_shop/core/cubit/order/order_cubit.dart';
import 'package:m_shop/core/cubit/order/order_state.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("My Orders", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderLoaded) {
            if (state.orders.isEmpty) {
              return const Center(child: Text("You haven't placed any orders yet.", style: TextStyle(color: Colors.white70)));
            }
            return ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return Card(
                  color: Colors.grey[900],
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(order.productName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      "Date: ${order.orderDate.toString().split(' ')[0]} | Status: ${order.status}",
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    trailing: Text("\$${order.price}", style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
                  ),
                );
              },
            );
          }
          return const Center(child: Text("Error loading orders"));
        },
      ),
    );
  }
}
