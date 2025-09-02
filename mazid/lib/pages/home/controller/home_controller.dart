import 'package:flutter/material.dart';
import 'package:mazid/core/cubit/auth/auth_Excption.dart';
import 'package:mazid/core/models/product_models.dart';
import 'package:mazid/core/models/user_model.dart';
import 'package:mazid/core/service/product_service.dart';
import 'package:mazid/core/service/swap_service.dart';

class HomeController {
  final ProductService _productService = ProductService();
  final AuthService _authService = AuthService();
  final SwapService swapService = SwapService();

  int currentIndex = 2;
  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];
  bool isLoading = true;
  String errorMessage = '';
  String selectedCategory = "All";

  UserModel? currentUser;

  void init(BuildContext context) {
    _loadProducts();
    _loadUserData();
  }

  void _loadProducts() async {
    try {
      final products = await _productService.fetchAllProducts();
      allProducts = products;
      filteredProducts = products;
      isLoading = false;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
    }
  }

  void _loadUserData() async {
    final user = await _authService.currentUser();
    if (user != null) {
      final userData = await _authService.getUserData(user.id);
      if (userData != null) {
        currentUser = userData;
      }
    }
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      filteredProducts = allProducts;
    } else {
      filteredProducts = allProducts
          .where(
            (p) =>
                p.name.toLowerCase().contains(query.toLowerCase()) ||
                p.title.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    selectedCategory = "All";
  }

  void filterByCategory(String category) {
    final Map<String, String> apiCategories = {
      "All": "all",
      "Cosmetic": "beauty",
      "Clothes": "clothing",
      "Laptops": "laptops",
      "Electronics": "electronics",
      "Accessories": "accessories",
    };

    selectedCategory = category;
    if (category == "All") {
      filteredProducts = allProducts;
    } else {
      final apiCategory =
          apiCategories[category]?.toLowerCase() ?? category.toLowerCase();
      filteredProducts = allProducts
          .where((p) => p.category.toLowerCase().contains(apiCategory))
          .toList();
    }
  }
}
