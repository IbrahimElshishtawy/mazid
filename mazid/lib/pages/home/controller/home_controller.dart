// lib/core/controllers/home_controller.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:mazid/core/cubit/auth/auth_Excption.dart';
import 'package:mazid/core/models/product_models.dart';
import 'package:mazid/core/models/user_model.dart';
import 'package:mazid/core/service/product_service.dart';
import 'package:mazid/core/service/swap_service.dart';

class HomeController extends ChangeNotifier {
  final ProductService _productService = ProductService();
  final AuthService _authService = AuthService();
  final SwapService swapService = SwapService();

  int currentIndex = 2;
  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];
  bool isLoading = true;
  bool isUserLoading = true;
  String errorMessage = '';
  String selectedCategory = "All";

  UserModel? currentUser;

  bool _isDisposed = false;

  /// بدء تحميل البيانات
  void init(BuildContext context) {
    _loadProducts();
    _loadUserData();
  }

  /// تحميل المنتجات
  void _loadProducts() async {
    try {
      final products = await _productService.fetchAllProducts();

      debugPrint("📦 All products fetched: ${products.length}");

      allProducts = products;
      filteredProducts = products;
      isLoading = false;

      if (allProducts.isEmpty) {
        errorMessage = "⚠️ لا توجد منتجات متاحة حالياً";
      }

      _safeNotifyListeners();
    } catch (e) {
      errorMessage = "❌ خطأ أثناء تحميل المنتجات: $e";
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  /// تحميل بيانات المستخدم
  void _loadUserData() async {
    try {
      final user = await _authService.currentUser();
      if (user != null) {
        final userData = await _authService.getUserData(user.id);
        if (userData != null) {
          currentUser = userData;
        }
      }
    } catch (e) {
      debugPrint("❌ خطأ أثناء تحميل بيانات المستخدم: $e");
    }

    isUserLoading = false;
    _safeNotifyListeners();
  }

  /// البحث في المنتجات
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
    _safeNotifyListeners();
  }

  /// الفلترة حسب التصنيف
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

    debugPrint("🔍 Category: $category | Products: ${filteredProducts.length}");
    _safeNotifyListeners();
  }

  /// تغيير التاب
  void changeTab(int index) {
    currentIndex = index;
    _safeNotifyListeners();
  }

  /// دالة آمنة للتأكد أن الكنترولر ما اتعملوش dispose
  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true; // نخلي الفلاغ true
    super.dispose();
  }
}
