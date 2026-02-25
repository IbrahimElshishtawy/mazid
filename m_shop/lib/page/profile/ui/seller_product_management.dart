import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_shop/core/cubit/product/product_cubit.dart';
import 'package:m_shop/core/cubit/product/product_state.dart';

class SellerProductManagement extends StatelessWidget {
  const SellerProductManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Product Management", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            // In a real app, we would filter by seller ID
            final myProducts = state.products.take(5).toList();
            return ListView.builder(
              itemCount: myProducts.length,
              itemBuilder: (context, index) {
                final product = myProducts[index];
                return Card(
                  color: Colors.grey[900],
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Image.network(product.image, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image)),
                    title: Text(product.name, style: const TextStyle(color: Colors.white)),
                    subtitle: Text("Price: \$${product.price} | Stock: ${product.countInStock}", style: const TextStyle(color: Colors.white70)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit, color: Colors.blueAccent), onPressed: () {}),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: () {}),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text("No products found"));
        },
      ),
    );
  }
}
