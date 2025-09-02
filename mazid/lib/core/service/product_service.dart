// lib/core/services/product_service.dart
import 'package:dio/dio.dart';
import 'package:mazid/core/models/product_models.dart';

class ProductService {
  final Dio _dio = Dio();

  // روابط الـ APIs
  final String elWekalaUrl = "https://elwekala.onrender.com/product/Laptops";
  final String fakeStoreUrl = "https://fakestoreapi.com/products";

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
      print("❌ Fetch ElWekala laptops error: $e");
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
      print("❌ Fetch FakeStore products error: $e");
      return [];
    }
  }

  /// دمج كل المنتجات معًا
  Future<List<ProductModel>> fetchAllProducts() async {
    final elWekala = await fetchElWekalaLaptops();
    final fakeStore = await fetchFakeStoreProducts();
    return [...elWekala, ...fakeStore];
  }
}
