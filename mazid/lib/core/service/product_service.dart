// lib/core/services/product_service.dart
// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:mazid/core/API/apilapproduct.dart';
import 'package:mazid/core/models/product_models.dart';

class ProductService {
  late final ApiLapProduct api;

  ProductService() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // لو حابب تتبع الطلبات في debug
    // dio.interceptors.add(LogInterceptor(responseBody: true));

    api = ApiLapProduct(dio);
  }

  /// دالة عامة تجيب كل اللابتوبات
  Future<List<ProductModel>> fetchLaptops() async {
    return await api.getLaptops();
  }
}
