// lib/core/repository/home_repository.dart
import 'dart:async';

import 'package:m_shop/core/cubit/auth/auth_service.dart';
import 'package:m_shop/core/service/api/product_service.dart';
import 'package:m_shop/core/data/admin_data.dart';
import 'package:m_shop/core/models/user/user_model.dart';
import 'package:m_shop/core/models/prouduct/product_models.dart';

class HomeRepository {
  HomeRepository({
    required this.authService,
    required this.productService,
    this.cacheTtl = const Duration(minutes: 10),
  });

  final AuthService authService;
  final ProductService productService;
  final Duration cacheTtl;

  List<ProductModel>? _cachedProducts;
  DateTime? _cachedAt;

  bool get _isCacheFresh =>
      _cachedProducts != null &&
      _cachedAt != null &&
      DateTime.now().difference(_cachedAt!) < cacheTtl;

  Future<void> prefetchProducts() async {
    if (_isCacheFresh) return;
    try {
      final items = await productService.fetchAllProducts();
      _cachedProducts = items;
      _cachedAt = DateTime.now();
    } catch (_) {}
  }

  Future<List<ProductModel>> getProducts({bool forceRefresh = false}) async {
    if (!forceRefresh && _isCacheFresh) {
      return _cachedProducts!;
    }
    try {
      final items = await productService.fetchAllProducts();
      _cachedProducts = items;
      _cachedAt = DateTime.now();
      return items;
    } catch (_) {
      return _cachedProducts ?? <ProductModel>[];
    }
  }

  Future<UserModel?> getCurrentUser() async {
    await authService.init();

    if (authService.isAdminLogin()) {
      return UserModel(
        id: AdminData.id,
        email: AdminData.email,
        name: AdminData.name,
        role: AdminData.role,
        avatar: AdminData.avatar,
        phone: AdminData.phone,
        password: '',
        imageUrl: AdminData.imageUrl,
      );
    }

    return await authService.currentUserProfile();
  }

  void invalidateCache() {
    _cachedProducts = null;
    _cachedAt = null;
  }
}
