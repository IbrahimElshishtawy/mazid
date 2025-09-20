import 'package:flutter/material.dart';
import 'package:mazid/core/cubit/auth/auth_Excption.dart';
import 'package:mazid/core/data/admin_data.dart';
import 'package:mazid/core/models/prouduct/product_models.dart';
import 'package:mazid/core/models/user/user_model.dart';
import 'package:mazid/core/service/product/product_service.dart';

class HomeController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final ProductService _productService = ProductService();

  List<ProductModel> products = [];
  List<ProductModel> filteredProducts = [];

  bool isLoading = true;
  bool isUserLoading = true;

  UserModel? currentUser;
  int currentIndex = 0;

  String? selectedCategory;
  String errorMessage = "";

  Future<void> init(BuildContext context) async {
    await _loadProducts();
    _loadUserData();
  }

  Future<void> _loadProducts() async {
    try {
      products = await _productService.fetchAllProducts();
      filteredProducts = products;
    } catch (e) {
      errorMessage = "❌ خطأ أثناء تحميل المنتجات: $e";
      debugPrint(errorMessage);
    }
    isLoading = false;
    _safeNotifyListeners();
  }

  void _loadUserData() async {
    try {
      if (_authService.isAdminLogin()) {
        currentUser = UserModel(
          id: AdminData.id,
          email: AdminData.email,
          name: AdminData.name,
          role: AdminData.role,
          avatar: AdminData.avatar,
          phone: AdminData.phone,
          password: AdminData.password,
          imageUrl: AdminData.imageUrl,
        );
      } else {
        final user = _authService.currentUser();
        if (user != null) {
          final userData = await _authService.getUserData(user.id);
          if (userData != null) {
            currentUser = userData;
          }
        }
      }
    } catch (e) {
      debugPrint("❌ خطأ أثناء تحميل بيانات المستخدم: $e");
    }

    isUserLoading = false;
    _safeNotifyListeners();
  }

  /// البحث
  void onSearchChanged(String query) {
    if (query.isEmpty) {
      filteredProducts = products;
    } else {
      filteredProducts = products
          .where(
            (p) =>
                p.name.toLowerCase().contains(query.toLowerCase()) ||
                p.description.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    _safeNotifyListeners();
  }

  void filterByCategory(String? category) {
    selectedCategory = category;

    if (category == null || category.isEmpty) {
      filteredProducts = products;
    } else {
      filteredProducts = products.where((p) => p.category == category).toList();
    }

    _safeNotifyListeners();
  }

  void changeTab(int index) {
    currentIndex = index;
    _safeNotifyListeners();
  }

  void _safeNotifyListeners() {
    if (hasListeners) {
      notifyListeners();
    }
  }
}
