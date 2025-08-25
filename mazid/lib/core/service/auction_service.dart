import 'package:mazid/core/models/auction_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuctionService {
  final supase = Supabase.instance.client;
  Future<List<AuctionModel>> getAuctions() async {
    final data = await supase
        .from('auctions')
        .select()
        .order('created_at', ascending: false);
    return (data as List).map((e) => AuctionModel.fromJson(e)).toList();
  }
}
