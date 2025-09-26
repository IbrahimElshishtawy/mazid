// lib/core/services/product_service.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:m_shop/core/models/prouduct/product_models.dart';

/// Service مسؤول عن جلب المنتجات من أكثر من مصدر خارجي
/// ElWekala / FakeStore / DummyJSON
class ProductService {
  final Dio _dio;

  // ========== Endpoints ==========
  static const String _elWekalaUrl =
      "https://elwekala.onrender.com/product/Laptops";
  static const String _fakeStoreUrl = "https://fakestoreapi.com/products";
  static const String _dummyListUrl = "https://dummyjson.com/products?limit=10";
  static const String _dummySearchUrl = "https://dummyjson.com/products/search";

  // ========== Ctor & Dio Setup ==========
  ProductService({Dio? dio}) : _dio = dio ?? _buildDefaultDio();

  static Dio _buildDefaultDio() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 12),
        sendTimeout: const Duration(seconds: 12),
        responseType: ResponseType.json,
        // اعتبر 2xx و 3xx “ناجحة”
        validateStatus: (code) => code != null && code >= 200 && code < 400,
      ),
    );

    dio.interceptors.addAll([
      if (kDebugMode)
        LogInterceptor(
          requestBody: true,
          responseBody: false, // لو عايز تشوف الـ body خليها true
          requestHeader: false,
          responseHeader: false,
        ),
    ]);

    return dio;
  }

  // ========== Public API ==========

  /// جلب منتجات ElWekala (لابتوبات)
  Future<List<ProductModel>> fetchElWekalaLaptops() async {
    try {
      final res = await _dio.get(_elWekalaUrl);
      final data = res.data;

      // متوقع: { product: [ {...}, {...} ] }
      final list = (data is Map && data['product'] is List)
          ? data['product'] as List
          : const <dynamic>[];

      return list
          .map((e) => _mapElWekalaToProduct(e))
          .whereType<ProductModel>()
          .toList();
    } catch (e) {
      if (kDebugMode) debugPrint("❌ ElWekala error: $e");
      return [];
    }
  }

  /// جلب منتجات FakeStore
  Future<List<ProductModel>> fetchFakeStoreProducts() async {
    try {
      final res = await _dio.get(_fakeStoreUrl);
      final data = res.data;

      // متوقع: [ {...}, {...} ]
      if (data is! List) return [];
      return data
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList();
    } catch (e) {
      if (kDebugMode) debugPrint("❌ FakeStore error: $e");
      return [];
    }
  }

  Future<List<ProductModel>> fetchDummyJsonProducts() async {
    try {
      final res = await _dio.get(_dummyListUrl);
      final data = res.data;

      final list = (data is Map && data['products'] is List)
          ? data['products'] as List
          : const <dynamic>[];

      return list
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList();
    } catch (e) {
      if (kDebugMode) debugPrint("❌ DummyJSON error: $e");
      return [];
    }
  }

  /// دمج النتائج بالتوازي + إزالة تكرار (حسب id)
  Future<List<ProductModel>> fetchAllProducts() async {
    try {
      final results = await Future.wait<List<ProductModel>>([
        fetchElWekalaLaptops(),
        fetchFakeStoreProducts(),
        fetchDummyJsonProducts(),
      ]);

      final merged = <ProductModel>[];
      final seen = <String>{};

      for (final list in results) {
        for (final p in list) {
          final id = p.id;
          if (id.isEmpty) continue;
          if (seen.add(id)) merged.add(p); // إزالة التكرار
        }
      }
      return merged;
    } catch (e) {
      if (kDebugMode) debugPrint("❌ fetchAllProducts error: $e");
      return [];
    }
  }

  /// بحث في DummyJSON (يمكن توسعتها لاحقًا لباقي المصادر)
  Future<List<ProductModel>> searchDummyJsonProducts(String query) async {
    try {
      final res = await _dio.get(
        _dummySearchUrl,
        queryParameters: {'q': query},
      );
      final data = res.data;

      final list = (data is Map && data['products'] is List)
          ? data['products'] as List
          : const <dynamic>[];

      return list
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList();
    } catch (e) {
      if (kDebugMode) debugPrint("❌ Search DummyJSON error: $e");
      return [];
    }
  }

  // ========== Private Mappers ==========

  /// توحيد JSON من ElWekala إلى المفاتيح التي يفهمها ProductModel.fromJson
  ProductModel? _mapElWekalaToProduct(dynamic raw) {
    if (raw is! Map) return null;

    final imgFallback =
        (raw['images'] is List && (raw['images'] as List).isNotEmpty)
        ? (raw['images'] as List).first
        : null;

    final mapped = <String, dynamic>{
      // مُعرّف
      'id': raw['_id'] ?? raw['id'] ?? raw['sku']?.toString(),
      // حقول عامة
      'status': raw['status'] ?? '',
      'category': raw['category'] ?? 'Laptops',
      'name': raw['name'] ?? raw['title'] ?? 'Laptop',
      'title': raw['title'] ?? raw['name'] ?? 'Laptop',
      'price': raw['price'] ?? raw['salePrice'] ?? raw['finalPrice'] ?? 0,
      'description': raw['description'] ?? raw['desc'] ?? '',
      // صور
      'image': raw['image'] ?? raw['thumbnail'] ?? imgFallback,
      'images': raw['images'] is List ? raw['images'] : const [],
      // شركة / براند
      'company': raw['company'] ?? raw['brand'] ?? raw['manufacturer'] ?? '',
      // مخزون/نسخة/مبيعات
      'countInStock': raw['countInStock'] ?? raw['stock'] ?? 0,
      '__v': raw['__v'] ?? 0,
      'sales': raw['sales'] ?? 0,
      // Rating قد يجي بأشكال مختلفة
      'rating':
          raw['rating'] ??
          {
            'rate': raw['rate'],
            'count': raw['ratingCount'] ?? raw['reviewsCount'],
          },
    };

    return ProductModel.fromJson(mapped);
  }
}
