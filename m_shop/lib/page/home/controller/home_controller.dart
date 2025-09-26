// ignore_for_file: dead_code

import 'package:flutter/material.dart';

import 'package:m_shop/core/cubit/auth/auth_service.dart';
import 'package:m_shop/core/data/admin_data.dart';
import 'package:m_shop/core/models/prouduct/product_models.dart';
import 'package:m_shop/core/models/user/user_model.dart';
import 'package:m_shop/core/service/product/product_service.dart';

class HomeController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final ProductService _productService = ProductService();

  List<ProductModel> products = [];
  List<ProductModel> filteredProducts = [];

  bool isLoading = true; // تحميل المنتجات
  bool isUserLoading = true; // تحميل المستخدم

  UserModel? currentUser;
  int currentIndex = 2;

  String? selectedCategory;
  String errorMessage = "";

  bool _disposed = false; // حارس الـ dispose

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  /// بداية التحميل (منتجات + بيانات المستخدم) بالتوازي
  Future<void> init(BuildContext context) async {
    isLoading = true;
    isUserLoading = true;
    errorMessage = "";
    _safeNotifyListeners();

    try {
      await Future.wait([_loadProducts(), _loadUserData()]);
    } catch (e) {
      // لو في خطأ غير متوقع
      debugPrint("❌ خطأ عام أثناء التهيئة: $e");
    } finally {
      _safeNotifyListeners();
    }
  }

  Future<void> _loadProducts() async {
    try {
      products = await _productService.fetchAllProducts();
      filteredProducts = products; // افتراضيًا كل المنتجات
    } catch (e) {
      errorMessage = "❌ خطأ أثناء تحميل المنتجات: $e";
      debugPrint(errorMessage);
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<void> _loadUserData() async {
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
          if (userData != null) currentUser = userData;
        }
      }
    } catch (e) {
      debugPrint("❌ خطأ أثناء تحميل بيانات المستخدم: $e");
    } finally {
      isUserLoading = false;
      _safeNotifyListeners();
    }
  }

  /// البحث
  void onSearchChanged(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      filteredProducts = _applyCategoryFilter(products, selectedCategory);
    } else {
      final base = _applyCategoryFilter(products, selectedCategory);
      filteredProducts = base.where((p) {
        final name = (p.name ?? '').toLowerCase();
        final desc = (p.description ?? '').toLowerCase();
        return name.contains(q) || desc.contains(q);
      }).toList();
    }
    _safeNotifyListeners();
  }

  /// فلترة بالفئة
  void filterByCategory(String? category) {
    selectedCategory = (category?.trim().isEmpty ?? true) ? null : category;
    filteredProducts = _applyCategoryFilter(products, selectedCategory);

    // لو فيه نص بحث مفعّل، نعيد تطبيقه
    // (اختياري: خزن آخر query لو محتاج)
    _safeNotifyListeners();
  }

  List<ProductModel> _applyCategoryFilter(
    List<ProductModel> source,
    String? category,
  ) {
    if (category == null) return List<ProductModel>.from(source);
    return source.where((p) => (p.category ?? '') == category).toList();
  }

  /// تغيير التاب
  void changeTab(int index) {
    if (index < 0) return;
    currentIndex = index;
    _safeNotifyListeners();
  }

  /// إعادة تحميل يدوي (مثلاً Pull-to-Refresh)
  Future<void> refresh() async {
    isLoading = true;
    errorMessage = "";
    _safeNotifyListeners();
    await _loadProducts();
  }
}
