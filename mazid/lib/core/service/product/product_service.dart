// lib/core/services/product_service.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mazid/core/models/product_models.dart';

class ProductService {
  final Dio _dio = Dio();

  // روابط الـ APIs
  final String elWekalaUrl = "https://elwekala.onrender.com/product/Laptops";
  final String fakeStoreUrl = "https://fakestoreapi.com/products";
  final String dummyJsonUrl = "https://dummyjson.com/products?limit=10";

  /// جلب منتجات ElWekala
  Future<List<ProductModel>> fetchElWekalaLaptops() async {
    try {
      final response = await _dio.get(elWekalaUrl);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data["product"] is List) {
          return (data["product"] as List)
              .map((item) => ProductModel.fromJson(item))
              .toList();
        } else {
          throw Exception("⚠️ API response 'product' is not a List or is null");
        }
      } else {
        throw Exception("⚠️ Failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) print("❌ Fetch ElWekala laptops error: $e");
      return [];
    }
  }

  /// جلب منتجات FakeStore
  Future<List<ProductModel>> fetchFakeStoreProducts() async {
    try {
      final response = await _dio.get(fakeStoreUrl);

      if (response.statusCode == 200 && response.data is List) {
        final List data = response.data;
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception("⚠️ API response is not a List or is null");
      }
    } catch (e) {
      if (kDebugMode) print("❌ Fetch FakeStore products error: $e");
      return [];
    }
  }

  /// جلب منتجات DummyJSON
  Future<List<ProductModel>> fetchDummyJsonProducts() async {
    try {
      final response = await _dio.get(dummyJsonUrl);

      if (response.statusCode == 200 && response.data["products"] is List) {
        final List data = response.data["products"];
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception("⚠️ DummyJSON API response is not a List or is null");
      }
    } catch (e) {
      if (kDebugMode) print("❌ Fetch DummyJSON products error: $e");
      return [];
    }
  }

  /// دمج كل المنتجات معًا
  Future<List<ProductModel>> fetchAllProducts() async {
    final elWekala = await fetchElWekalaLaptops();
    final fakeStore = await fetchFakeStoreProducts();
    final dummyJson = await fetchDummyJsonProducts();
    return [...elWekala, ...fakeStore, ...dummyJson];
  }

  /// البحث في DummyJSON
  Future<List<ProductModel>> searchDummyJsonProducts(String query) async {
    try {
      final response = await _dio.get(
        'https://dummyjson.com/products/search',
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200 && response.data["products"] is List) {
        final List data = response.data["products"];
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception("⚠️ DummyJSON search response invalid");
      }
    } catch (e) {
      if (kDebugMode) print("❌ Search DummyJSON products error: $e");
      return [];
    }
  }
}
