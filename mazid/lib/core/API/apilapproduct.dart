// lib/core/API/apilapproduct.dart
import 'package:dio/dio.dart';
import 'package:mazid/core/models/product_models.dart';

class ApiLapProduct {
  final Dio _dio;

  ApiLapProduct(this._dio);

  /// جلب قائمة اللابتوبات
  Future<List<ProductModel>> getLaptops() async {
    try {
      final response = await _dio.get(
        "https://elwekala.onrender.com/product/Laptops",
      );

      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception("فشل تحميل البيانات: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("خطأ في الاتصال: $e");
    }
  }
}
