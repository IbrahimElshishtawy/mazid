// lib/core/models/bid_model.dart
// ignore_for_file: file_names

class BidModel {
  final String id;
  final String auctionId;
  final String userId;
  final double amount;
  final DateTime time;

  BidModel({
    required this.id,
    required this.auctionId,
    required this.userId,
    required this.amount,
    required this.time,
  });

  factory BidModel.fromJson(Map<String, dynamic> json) => BidModel(
    id: json['id'],
    auctionId: json['auction_id'],
    userId: json['user_id'],
    amount: (json['amount'] as num).toDouble(),
    time: DateTime.parse(json['time']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'auction_id': auctionId,
    'user_id': userId,
    'amount': amount,
    'time': time.toIso8601String(),
  };
}
