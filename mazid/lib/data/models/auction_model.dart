class AuctionModel {
  final String id;
  final String productId;
  final double startPrice;
  final double currentBid;
  final String? winnerId;
  final DateTime endsAt;

  AuctionModel({
    required this.id,
    required this.productId,
    required this.startPrice,
    required this.currentBid,
    this.winnerId,
    required this.endsAt,
  });

  factory AuctionModel.fromJson(Map<String, dynamic> json) {
    return AuctionModel(
      id: json['id'],
      productId: json['product_id'],
      startPrice: (json['start_price'] ?? 0).toDouble(),
      currentBid: (json['current_bid'] ?? 0).toDouble(),
      winnerId: json['winner_id'],
      endsAt: DateTime.parse(json['ends_at']),
    );
  }
}
