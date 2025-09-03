// lib/core/service/auction_service.dart
import 'package:mazid/core/models/BidModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/auction_model.dart';

final supabase = Supabase.instance.client;

class AuctionService {
  Future<void> createAuction(AuctionModel auction) async {
    await supabase.from('auctions').insert([auction.toJson()]);
  }

  Future<List<AuctionModel>> fetchAllAuctions() async {
    final data = await supabase.from('auctions').select();
    return (data as List).map((e) => AuctionModel.fromJson(e)).toList();
  }

  Future<List<AuctionModel>> fetchAuctionBySeller(String sellerId) async {
    final data = await supabase
        .from('auctions')
        .select()
        .eq('seller_id', sellerId);
    return (data as List).map((e) => AuctionModel.fromJson(e)).toList();
  }

  Future<AuctionModel?> fetchAuctionById(String auctionId) async {
    final data = await supabase
        .from('auctions')
        .select()
        .eq('id', auctionId)
        .maybeSingle();
    if (data == null) return null;
    return AuctionModel.fromJson(data);
  }

  Future<void> placeBid(BidModel bid) async {
    await supabase.from('bids').insert([bid.toJson()]);
  }

  Future<List<BidModel>> fetchBidsForAuction(String auctionId) async {
    final data = await supabase
        .from('bids')
        .select()
        .eq('auction_id', auctionId)
        .order('amount', ascending: false);
    return (data as List).map((e) => BidModel.fromJson(e)).toList();
  }

  Future<BidModel?> getHighestBid(String auctionId) async {
    final data = await supabase
        .from('bids')
        .select()
        .eq('auction_id', auctionId)
        .order('amount', ascending: false)
        .limit(1);
    if ((data as List).isEmpty) return null;
    return BidModel.fromJson(data.first);
  }

  Future<void> markAuctionAsFinished(String auctionId) async {
    await supabase
        .from('auctions')
        .update({'is_active': false})
        .eq('id', auctionId);
  }
}
