import 'package:dio/dio.dart';
import 'package:mazid/core/Response/productresponse.dart';
import 'package:mazid/core/models/product_models.dart';
import 'package:retrofit/retrofit.dart';

part 'apilapproduct.g.dart';

@RestApi(baseUrl: "https://elwekala.onrender.com/")
abstract class ApiLapProduct {
  factory ApiLapProduct(Dio dio, {String baseUrl}) = _ApiLapProduct;

  /// جلب كل المنتجات
  @GET("/products")
  Future<Productresponse> getProducts(); // ⚠️ استخدام Productresponse

  /// جلب منتج واحد حسب الـ ID
  @GET("/product/{id}")
  Future<ProductModel> getProductById(@Path("id") String id);
}
