import 'package:dio/dio.dart';
import 'package:mazid/core/models/prouduct/product_models.dart';

class ApiLapProduct {
  final Dio dio;
  ApiLapProduct(this.dio);
  Future<List<ProductModel>> getLaptops() async {
    final response = await dio.get(
      "https://elwekala.onrender.com/product/Laptops",
    );

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
  }
}
