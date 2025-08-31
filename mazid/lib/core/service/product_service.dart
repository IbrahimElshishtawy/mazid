// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:mazid/core/API/api_product.dart';

class ProductService {
  late final ProductApi api;

  ApiService() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // إضافه logger إذا حبيت تضيف تتبع
    // dio.interceptors.add(LogInterceptor(responseBody: true));

    api = ProductApi(dio);
  }
}
