import 'package:mazid/core/models/product_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService {
  final supabase = Supabase.instance.client;

  Future<List<ProductModel>> getProducts() async {
    final data = await supabase
        .from('products')
        .select()
        .order('created_at', ascending: false);
    return (data as List).map((e) => ProductModel.fromJson(e)).toList();
  }
}
