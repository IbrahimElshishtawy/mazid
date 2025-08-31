import 'package:dio/dio.dart';
import 'package:mazid/core/models/product_models.dart';
import 'package:retrofit/retrofit.dart';

part 'product_api.g.dart';

@RestApi(baseUrl: "https://elwekala.onrender.com")
abstract class ProductApi {
  factory ProductApi(Dio dio, {String? baseUrl}) = _ProductApi;

  @GET("/product/Laptops")
  Future<List<ProductModel>> getLaptops();
}
