// ignore_for_file: avoid_print
import 'package:supabase_flutter/supabase_flutter.dart';

class CartService {
  final supabase = Supabase.instance.client;

  /// إضافة منتج للسلة أو تحديث الكمية لو موجود
  Future<void> addToCart({
    required String userId,
    required int productId,
    required String name,
    required double price,
    required String imageUrl,
  }) async {
    try {
      final existing = await supabase
          .from('cart')
          .select()
          .eq('user_id', userId)
          .eq('product_id', productId)
          .maybeSingle();

      if (existing != null) {
        await supabase
            .from('cart')
            .update({'quantity': existing['quantity'] + 1})
            .eq('id', existing['id']);
      } else {
        await supabase.from('cart').insert({
          'user_id': userId,
          'product_id': productId,
          'name': name,
          'price': price,
          'image_url': imageUrl,
          'quantity': 1,
        });
      }
    } catch (e) {
      print('❌ [CartService] addToCart error: $e');
    }
  }

  /// جلب السلة
  Future<List<Map<String, dynamic>>> getCart(String userId) async {
    final response = await supabase.from('cart').select().eq('user_id', userId);
    return response;
  }

  /// تحديث الكمية
  Future<void> updateQuantity(int cartId, int newQuantity) async {
    if (newQuantity > 0) {
      await supabase
          .from('cart')
          .update({'quantity': newQuantity})
          .eq('id', cartId);
    } else {
      await deleteItem(cartId);
    }
  }

  /// حذف عنصر
  Future<void> deleteItem(int cartId) async {
    await supabase.from('cart').delete().eq('id', cartId);
  }
}
