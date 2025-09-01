import 'package:dio/dio.dart';
import 'package:mazid/core/models/product_models.dart';
import 'package:retrofit/retrofit.dart';

part 'apilapproduct.g.dart'; // 👈 لازم تضيف السطر ده

@RestApi(baseUrl: "https://example.com/api/")
abstract class ApiLapProduct {
  factory ApiLapProduct(Dio dio, {String baseUrl}) = _ApiLapProduct;

  @GET("/products")
  Future<List<ProductModel>> getProducts();

  @GET("/products/{id}")
  Future<ProductModel> getProductById(@Path("id") String id);
}
