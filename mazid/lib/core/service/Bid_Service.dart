import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/bid_model.dart';

class BidService {
  final supabase = Supabase.instance.client;

  Future<List<BidModel>> getBidsForProduct(String productId) async {
    final response = await supabase
        .from('bids')
        .select()
        .eq('product_id', productId)
        .order('amount', ascending: false);
    return (response as List).map((json) => BidModel.fromJson(json)).toList();
  }

  Future<void> placeBid(BidModel bid) async {
    await supabase.from('bids').insert(bid.toJson());
  }
}
