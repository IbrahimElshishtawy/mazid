// ignore_for_file: file_names

import 'package:m_shop/core/models/actions/BidModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BidService {
  final supabase = Supabase.instance.client;

  Future<List<Bid>> getBidsForProduct(String productId) async {
    final response = await supabase
        .from('bids')
        .select()
        .eq('product_id', productId)
        .order('amount', ascending: false);
    return (response as List).map((json) => Bid.fromJson(json)).toList();
  }

  Future<void> placeBid(Bid bid) async {
    await supabase.from('bids').insert(bid.toJson());
  }
}
