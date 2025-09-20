// lib/core/services/product_service.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:mazid/core/models/prouduct/product_models.dart';

class Apiproductstore {
  final Dio _dio = Dio();

  final String baseUrl = "https://fakestoreapi.com";

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await _dio.get('$baseUrl/products');

      if (response.statusCode == 200 && response.data is List) {
        final List data = response.data;
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception("API response is not a List or is null");
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Fetch products error: $e");
      }
      rethrow;
    }
  }
}
