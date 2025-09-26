// lib/core/services/product_service.dart
// ignore_for_file: unnecessary_cast

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
      final mapped = list
          .whereType<Map<String, dynamic>>()
          .map<ProductModel?>(
            _mapElWekalaToProduct,
          ) // <-- نوع صريح لتفادي مشاكل الـ tear-off
          .whereType<ProductModel>()
          .toList();

      if (kDebugMode) debugPrint('ElWekala loaded: ${mapped.length}');
      return mapped;
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
      final mapped = data
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList();

      if (kDebugMode) debugPrint('FakeStore loaded: ${mapped.length}');
      return mapped;
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
      final mapped = list
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList();

      if (kDebugMode) debugPrint('DummyJSON loaded: ${mapped.length}');
      return mapped;
    } catch (e) {
      if (kDebugMode) debugPrint("❌ DummyJSON error: $e");
      return [];
    }
  }

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
          if (p.id.isEmpty) continue;
          if (seen.add(p.id)) merged.add(p);
        }
      }

      if (kDebugMode) {
        debugPrint('ALL loaded (merged unique): ${merged.length}');
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
      final mapped = list
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList();

      if (kDebugMode) {
        debugPrint('DummyJSON search("$query"): ${mapped.length}');
      }
      return mapped;
    } catch (e) {
      if (kDebugMode) debugPrint("❌ Search DummyJSON error: $e");
      return [];
    }
  }

  // ← خلي البراميتر dynamic لتفادي مشاكل الـ tear-off
  ProductModel? _mapElWekalaToProduct(dynamic raw) {
    if (raw is! Map) return null;
    final map = raw as Map;

    final images = (map['images'] is List) ? (map['images'] as List) : const [];
    final imgFallback = images.isNotEmpty ? images.first : null;

    final mapped = <String, dynamic>{
      'id': map['_id'] ?? map['id'] ?? map['sku']?.toString(),
      'status': map['status'] ?? '',
      'category': map['category'] ?? 'Laptops',
      'name': map['name'] ?? map['title'] ?? 'Laptop',
      'title': map['title'] ?? map['name'] ?? 'Laptop',
      'price': map['price'] ?? map['salePrice'] ?? map['finalPrice'] ?? 0,
      'description': map['description'] ?? map['desc'] ?? '',
      'image': map['image'] ?? map['thumbnail'] ?? imgFallback,
      'images': images,
      'company': map['company'] ?? map['brand'] ?? map['manufacturer'] ?? '',
      'countInStock': map['countInStock'] ?? map['stock'] ?? 0,
      '__v': map['__v'] ?? 0,
      'sales': map['sales'] ?? 0,
      'rating':
          map['rating'] ??
          {
            'rate': map['rate'],
            'count': map['ratingCount'] ?? map['reviewsCount'],
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

    try {
      req.extra['retry_attempt'] = attempt + 1;
      final response = await _dio.request(
        req.path,
        data: req.data,
        queryParameters: req.queryParameters,
        options: Options(
          method: req.method,
          headers: req.headers,
          responseType: req.responseType,
          contentType: req.contentType,
          followRedirects: req.followRedirects,
          receiveDataWhenStatusError: req.receiveDataWhenStatusError,
          validateStatus: req.validateStatus,
          sendTimeout: req.sendTimeout,
          receiveTimeout: req.receiveTimeout,
        ),
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
