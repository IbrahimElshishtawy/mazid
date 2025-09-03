// lib/core/models/auction_model.dart
class AuctionModel {
  final String id;
  final String productId;
  final String sellerId;
  final double startingPrice;
  final DateTime startTime;
  final DateTime endTime;
  late final bool isActive;

  AuctionModel({
    required this.id,
    required this.productId,
    required this.sellerId,
    required this.startingPrice,
    required this.startTime,
    required this.endTime,
    this.isActive = true,
  });

  factory AuctionModel.fromJson(Map<String, dynamic> json) => AuctionModel(
    id: json['id'],
    productId: json['product_id'],
    sellerId: json['seller_id'],
    startingPrice: (json['starting_price'] as num).toDouble(),
    startTime: DateTime.parse(json['start_time']),
    endTime: DateTime.parse(json['end_time']),
    isActive: json['is_active'] ?? true,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'product_id': productId,
    'seller_id': sellerId,
    'starting_price': startingPrice,
    'start_time': startTime.toIso8601String(),
    'end_time': endTime.toIso8601String(),
    'is_active': isActive,
  };
}
