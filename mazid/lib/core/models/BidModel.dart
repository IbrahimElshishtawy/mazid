class Bid {
  final String id;
  final String productId;
  final String bidderId;
  final double amount;
  final DateTime createdAt;

  Bid({
    required this.id,
    required this.productId,
    required this.bidderId,
    required this.amount,
    required this.createdAt,
  });

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      bidderId: json['bidder_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'bidder_id': bidderId,
      'amount': amount,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
