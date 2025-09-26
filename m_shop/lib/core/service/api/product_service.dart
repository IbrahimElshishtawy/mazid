// lib/core/services/product_service.dart
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:m_shop/core/models/prouduct/product_models.dart';

class ProductService {
  final Dio _dio;

  static const String _elWekalaUrl =
      "https://elwekala.onrender.com/product/Laptops";
  static const String _fakeStoreUrl = "https://fakestoreapi.com/products";
  static const String _dummyListUrl = "https://dummyjson.com/products?limit=10";
  static const String _dummySearchUrl = "https://dummyjson.com/products/search";

  ProductService({Dio? dio}) : _dio = dio ?? _buildDefaultDio();

  static Dio _buildDefaultDio() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 25),
        sendTimeout: const Duration(seconds: 20),
        responseType: ResponseType.json,
        validateStatus: (code) => code != null && code >= 200 && code < 400,
      ),
    );

    dio.interceptors.addAll([
      if (kDebugMode)
        LogInterceptor(
          requestBody: false,
          responseBody: false,
          requestHeader: false,
          responseHeader: false,
        ),
      _RetryInterceptor(
        dio,
        retries: 1,
        retryDelay: const Duration(seconds: 2),
      ),
    ]);

    return dio;
  }

  /// ElWekala بميزانية زمنية قصيرة عشان ما يعلّقش التحميل كله
  Future<List<ProductModel>> fetchElWekalaLaptops({
    Duration budget = const Duration(seconds: 8),
  }) async {
    final cancelToken = CancelToken();
    final timer = Timer(budget, () {
      if (!cancelToken.isCancelled) cancelToken.cancel('budget timeout');
    });

    try {
      final res = await _dio.get(_elWekalaUrl, cancelToken: cancelToken);
      final data = res.data;

      final list = (data is Map && data['product'] is List)
          ? data['product'] as List
          : const <dynamic>[];

      return list
          .whereType<Map<String, dynamic>>()
          .map(_mapElWekalaToProduct)
          .whereType<ProductModel>()
          .toList();
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        if (kDebugMode) debugPrint("⏱️ ElWekala skipped: ${e.message}");
      } else {
        if (kDebugMode) debugPrint("❌ ElWekala error: $e");
      }
      return [];
    } catch (e) {
      if (kDebugMode) debugPrint("❌ ElWekala unexpected: $e");
      return [];
    } finally {
      timer.cancel();
    }
  }

  Future<List<ProductModel>> fetchFakeStoreProducts() async {
    try {
      final res = await _dio.get(_fakeStoreUrl);
      final data = res.data;

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

  /// دمج النتائج بالتوازي + إزالة التكرار (id) — ElWekala مش هيعطّل بسبب الميزانية
  Future<List<ProductModel>> fetchAllProducts() async {
    try {
      final results = await Future.wait<List<ProductModel>>([
        fetchElWekalaLaptops(), // عنده budget 8s
        fetchFakeStoreProducts(), // سريع
        fetchDummyJsonProducts(), // سريع
      ]);

      final merged = <ProductModel>[];
      final seen = <String>{};

      for (final list in results) {
        for (final p in list) {
          if (p.id.isEmpty) continue;
          if (seen.add(p.id)) merged.add(p);
        }
      }
      return merged;
    } catch (e) {
      if (kDebugMode) debugPrint("❌ fetchAllProducts error: $e");
      return [];
    }
  }

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

  ProductModel? _mapElWekalaToProduct(Map<String, dynamic> raw) {
    final images = (raw['images'] is List) ? (raw['images'] as List) : const [];
    final imgFallback = images.isNotEmpty ? images.first : null;

    final mapped = <String, dynamic>{
      'id': raw['_id'] ?? raw['id'] ?? raw['sku']?.toString(),
      'status': raw['status'] ?? '',
      'category': raw['category'] ?? 'Laptops',
      'name': raw['name'] ?? raw['title'] ?? 'Laptop',
      'title': raw['title'] ?? raw['name'] ?? 'Laptop',
      'price': raw['price'] ?? raw['salePrice'] ?? raw['finalPrice'] ?? 0,
      'description': raw['description'] ?? raw['desc'] ?? '',
      'image': raw['image'] ?? raw['thumbnail'] ?? imgFallback,
      'images': images,
      'company': raw['company'] ?? raw['brand'] ?? raw['manufacturer'] ?? '',
      'countInStock': raw['countInStock'] ?? raw['stock'] ?? 0,
      '__v': raw['__v'] ?? 0,
      'sales': raw['sales'] ?? 0,
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

class _RetryInterceptor extends Interceptor {
  _RetryInterceptor(
    this._dio, {
    this.retries = 1,
    this.retryDelay = const Duration(seconds: 2),
  });
  final Dio _dio;
  final int retries;
  final Duration retryDelay;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final shouldRetry =
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.badResponse ||
        err.type == DioExceptionType.unknown;

    if (!shouldRetry) return handler.next(err);

    final req = err.requestOptions;
    final attempt = (req.extra['retry_attempt'] as int?) ?? 0;
    if (attempt >= retries) return handler.next(err);

    await Future.delayed(retryDelay * (attempt + 1));

    final newOptions = Options(
      method: req.method,
      headers: req.headers,
      responseType: req.responseType,
      contentType: req.contentType,
      followRedirects: req.followRedirects,
      receiveDataWhenStatusError: req.receiveDataWhenStatusError,
      validateStatus: req.validateStatus,
      sendTimeout: req.sendTimeout,
      receiveTimeout: req.receiveTimeout,
    );

    try {
      req.extra['retry_attempt'] = attempt + 1;
      final response = await _dio.request(
        req.path,
        data: req.data,
        queryParameters: req.queryParameters,
        options: newOptions,
        cancelToken: req.cancelToken,
        onReceiveProgress: req.onReceiveProgress,
        onSendProgress: req.onSendProgress,
      );
      return handler.resolve(response);
    } catch (e) {
      return handler.next(e as DioException);
    }
  }
}
