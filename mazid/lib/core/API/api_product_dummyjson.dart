// product_service.dart
import 'package:dio/dio.dart';
import '../models/product_models.dart';

class ProductService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  // جلب كل المنتجات
  Future<List<ProductModel>> fetchAllProducts() async {
    try {
      final response = await _dio.get('/products?limit=10');

      if (response.statusCode == 200) {
        final data = response.data['products'] as List;
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // البحث عن المنتجات
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await _dio.get(
        '/products/search',
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        final data = response.data['products'] as List;
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search products');
      }
    } catch (e) {
      throw Exception('Error searching products: $e');
    }
  }
}
