// ignore_for_file: dead_code

import 'dart:async';
import 'package:flutter/material.dart';

import 'package:m_shop/core/cubit/auth/auth_service.dart';
import 'package:m_shop/core/data/admin_data.dart';
import 'package:m_shop/core/models/prouduct/product_models.dart';
import 'package:m_shop/core/models/user/user_model.dart';
import 'package:m_shop/core/service/product/product_service.dart';

class HomeController extends ChangeNotifier {
  HomeController({AuthService? authService, ProductService? productService})
    : _authService = authService ?? AuthService(),
      _productService = productService ?? ProductService();

  final AuthService _authService;
  final ProductService _productService;

  // ======= State =======
  List<ProductModel> products = [];
  List<ProductModel> filteredProducts = [];

  bool isLoading = true; // تحميل المنتجات
  bool isUserLoading = true; // تحميل المستخدم
  String errorMessage = "";

  UserModel? currentUser;
  int currentIndex = 2;

  String? selectedCategory;
  String _searchQuery = '';

  bool _disposed = false;
  bool _initialized = false;
  Timer? _debounce;

  // ======= Lifecycle =======
  @override
  void dispose() {
    _disposed = true;
    _debounce?.cancel();
    super.dispose();
  }

  void _safeNotifyListeners() {
    if (!_disposed) notifyListeners();
  }

  // ======= Init / Refresh =======
  /// استدعِها مرة واحدة بعد تركيب الـ Provider (post-frame)
  Future<void> initOnce() async {
    if (_initialized) return;
    _initialized = true;

    isLoading = true;
    isUserLoading = true;
    errorMessage = "";
    _safeNotifyListeners();

    try {
      await Future.wait([_loadProducts(), _loadUserData()]);
    } catch (e) {
      errorMessage = "حدث خطأ أثناء التهيئة. حاول لاحقاً.";
      debugPrint("❌ خطأ عام أثناء التهيئة: $e");
    } finally {
      _safeNotifyListeners();
    }
  }

  Future<void> refresh() async {
    isLoading = true;
    errorMessage = "";
    _safeNotifyListeners();
    await _loadProducts();
  }

  // ======= Data Loads =======
  Future<void> _loadProducts() async {
    try {
      final list = await _productService.fetchAllProducts();
      products = list;
      _recomputeFiltered();
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

  // ======= Filters & Search =======
  /// البحث مع Debounce لتقليل إعادة البناء أثناء الكتابة
  void onSearchChanged(String query) {
    _searchQuery = query;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), _recomputeFiltered);
  }

  /// فلترة بالفئة (category)
  void filterByCategory(String? category) {
    final normalized = category?.trim();
    selectedCategory = (normalized == null || normalized.isEmpty)
        ? null
        : normalized;
    _recomputeFiltered();
  }

  /// إعادة حساب القائمة المعروضة بناءً على (الفئة + البحث)
  void _recomputeFiltered() {
    List<ProductModel> base = products;

    // فلترة بالفئة لو محددة
    if (selectedCategory != null) {
      final cat = selectedCategory!;
      base = base.where((p) => p.category == cat).toList();
    }

    // تطبيق البحث بعد الفئة
    final q = _searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      base = base.where((p) {
        final name = p.name.toLowerCase();
        final desc = p.description.toLowerCase();
        return name.contains(q) || desc.contains(q);
      }).toList();
    }

    filteredProducts = base;
    _safeNotifyListeners();
  }

  /// مسح الفلاتر والبحث
  void clearFilters() {
    selectedCategory = null;
    _searchQuery = '';
    filteredProducts = products;
    _safeNotifyListeners();
  }

  // ======= UI State =======
  /// تغيير التاب
  void changeTab(int index) {
    if (index == currentIndex || index < 0) return;
    currentIndex = index;
    _safeNotifyListeners();
  }

  // Getters مساعدة (اختيارية للاستخدام في الـ UI)
  bool get hasError => errorMessage.isNotEmpty;
  bool get isBusy => isLoading || isUserLoading;
  bool get isEmpty => !isBusy && filteredProducts.isEmpty;
}
