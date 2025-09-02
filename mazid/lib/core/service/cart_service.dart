// lib/core/service/cart_service.dart
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
      // تحقق من وجود المنتج في السلة
      final existing = await supabase
          .from('cart')
          .select()
          .eq('user_id', userId)
          .eq('product_id', productId)
          .maybeSingle();

      if (existing != null) {
        // تحديث الكمية لو موجود
        await supabase
            .from('cart')
            .update({'quantity': (existing['quantity'] as int) + 1})
            .eq('id', existing['id']);
      } else {
        // إضافة المنتج للسلة
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
      throw Exception('Failed to add product to cart: $e');
    }
  }

  /// جلب جميع عناصر السلة لمستخدم معين
  Future<List<Map<String, dynamic>>> getCart(String userId) async {
    try {
      final response = await supabase
          .from('cart')
          .select()
          .eq('user_id', userId);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ [CartService] getCart error: $e');
      return [];
    }
  }

  /// تحديث كمية عنصر في السلة
  Future<void> updateQuantity(int cartId, int newQuantity) async {
    try {
      if (newQuantity > 0) {
        await supabase
            .from('cart')
            .update({'quantity': newQuantity})
            .eq('id', cartId);
      } else {
        await deleteItem(cartId);
      }
    } catch (e) {
      print('❌ [CartService] updateQuantity error: $e');
      throw Exception('Failed to update cart quantity: $e');
    }
  }

  /// حذف عنصر من السلة
  Future<void> deleteItem(int cartId) async {
    try {
      await supabase.from('cart').delete().eq('id', cartId);
    } catch (e) {
      print('❌ [CartService] deleteItem error: $e');
      throw Exception('Failed to delete cart item: $e');
    }
  }

  /// جلب عدد المنتجات في السلة
  Future<int> getCartCount(String userId) async {
    try {
      final response = await supabase
          .from('cart')
          .select()
          .eq('user_id', userId);

      // response يكون List<dynamic>، نرجع الطول مباشرة
      return (response as List).length;
    } catch (e) {
      print('❌ [CartService] getCartCount error: $e');
      return 0;
    }
  }
}
