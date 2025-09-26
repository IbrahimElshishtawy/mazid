import 'dart:async';
import 'package:m_shop/core/cubit/auth/auth_service.dart';
import 'package:m_shop/core/data/admin_data.dart';
import 'package:m_shop/core/models/prouduct/product_models.dart';
import 'package:m_shop/core/models/user/user_model.dart';
import 'package:m_shop/core/service/product/product_service.dart';

class HomeRepository {
  HomeRepository({
    required this.authService,
    required this.productService,
    this.cacheTtl = const Duration(minutes: 10),
  });

  final AuthService authService;
  final ProductService productService;
  final Duration cacheTtl;

  // كاش بسيط في الذاكرة
  List<ProductModel>? _cachedProducts;
  DateTime? _cachedAt;

  bool get _isCacheFresh =>
      _cachedProducts != null &&
      _cachedAt != null &&
      DateTime.now().difference(_cachedAt!) < cacheTtl;

  /// Prefetch اختياري (تقدر تناديه في السپلّاش/الانترو)
  Future<void> prefetchProducts() async {
    if (_isCacheFresh) return;
    final items = await productService.fetchAllProducts();
    _cachedProducts = items;
    _cachedAt = DateTime.now();
  }

  Future<List<ProductModel>> getProducts({bool forceRefresh = false}) async {
    if (!forceRefresh && _isCacheFresh) {
      return _cachedProducts!;
    }
    final items = await productService.fetchAllProducts();
    _cachedProducts = items;
    _cachedAt = DateTime.now();
    return items;
  }

  Future<UserModel?> getCurrentUser() async {
    if (authService.isAdminLogin()) {
      return UserModel(
        id: AdminData.id,
        email: AdminData.email,
        name: AdminData.name,
        role: AdminData.role,
        avatar: AdminData.avatar,
        phone: AdminData.phone,
        password: AdminData.password,
        imageUrl: AdminData.imageUrl,
      );
    }

    final user = authService.currentUser();
    if (user == null) return null;

    final userData = await authService.getUserData(user.id);
    return userData;
  }
}
