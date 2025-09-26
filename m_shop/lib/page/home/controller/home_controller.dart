// lib/page/home/controller/home_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:m_shop/core/cubit/auth/auth_service.dart';

import 'package:m_shop/core/data/admin_data.dart';
import 'package:m_shop/core/models/user/user_model.dart';
import 'package:m_shop/core/models/prouduct/product_models.dart';
import 'package:m_shop/core/service/api/product_service.dart';

class HomeController extends ChangeNotifier {
  HomeController({AuthService? authService, ProductService? productService})
    : _authService = authService ?? AuthService(),
      _productService = productService ?? ProductService();

  final AuthService _authService;
  final ProductService _productService;

  List<ProductModel> products = [];
  List<ProductModel> filteredProducts = [];

  bool isLoading = true;
  bool isUserLoading = true;
  String errorMessage = "";

  UserModel? currentUser;
  int currentIndex = 2;

  String? selectedCategory;
  String _searchQuery = '';

  bool _disposed = false;
  bool _initialized = false;
  Timer? _debounce;

  @override
  void dispose() {
    _disposed = true;
    _debounce?.cancel();
    super.dispose();
  }

  void _safeNotifyListeners() {
    if (!_disposed) notifyListeners();
  }

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
      debugPrint("Init error: $e");
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

  Future<void> _loadProducts() async {
    try {
      final list = await _productService.fetchAllProducts();
      products = list;
      _recomputeFiltered();
    } catch (e) {
      errorMessage = "خطأ أثناء تحميل المنتجات: $e";
      debugPrint(errorMessage);
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<void> _loadUserData() async {
    try {
      await _authService.init();

      if (_authService.isAdminLogin()) {
        currentUser = UserModel(
          id: AdminData.id,
          email: AdminData.email,
          name: AdminData.name,
          role: AdminData.role,
          avatar: AdminData.avatar,
          phone: AdminData.phone,
          password: '',
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
      debugPrint("Load user error: $e");
    } finally {
      isUserLoading = false;
      _safeNotifyListeners();
    }
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), _recomputeFiltered);
  }

  void filterByCategory(String? category) {
    final normalized = (category ?? '').trim();
    if (normalized.isEmpty || normalized.toLowerCase() == 'all') {
      selectedCategory = null;
    } else {
      selectedCategory = normalized;
    }
    _recomputeFiltered();
  }

  void _recomputeFiltered() {
    List<ProductModel> base = products;

    final Map<String, Set<String>> aliases = {
      'electronics': {'electronics'},
      'clothes': {"men's clothing", "women's clothing", 'clothes', 'apparel'},
      'perfume': {'fragrances', 'perfume'},
      'cosmetic': {'beauty', 'cosmetics', 'skincare', 'makeup'},
      'laptops': {'laptops', 'laptop', 'notebook'},
    };

    if (selectedCategory != null) {
      final uiKey = selectedCategory!.toLowerCase();
      final accept = aliases[uiKey];
      base = base.where((p) {
        final c = p.category.toLowerCase();
        if (accept != null && accept.isNotEmpty) {
          return accept.contains(c);
        }
        return c == uiKey;
      }).toList();
    }

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

  void clearFilters() {
    selectedCategory = null;
    _searchQuery = '';
    filteredProducts = products;
    _safeNotifyListeners();
  }

  void changeTab(int index) {
    if (index == currentIndex || index < 0) return;
    currentIndex = index;
    _safeNotifyListeners();
  }

  bool get hasError => errorMessage.isNotEmpty;
  bool get isBusy => isLoading || isUserLoading;
  bool get isEmpty => !isBusy && filteredProducts.isEmpty;
}
