// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:mazid/core/API/apilapproduct.dart';

class ProductService {
  late final ApiLapProduct api;

  void ApiService() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // إضافه logger إذا حبيت تضيف تتبع
    // dio.interceptors.add(LogInterceptor(responseBody: true));

    api = ApiLapProduct(dio);
  }
}
