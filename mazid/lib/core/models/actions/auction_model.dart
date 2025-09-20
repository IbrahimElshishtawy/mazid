// models/transaction.dart
class AuctionTransaction {
  final String id;
  final String productId;
  final String winnerId;
  final double amount;
  final String status; // pending, paid, failed, refunded
  final String? stripePaymentIntentId;
  final DateTime createdAt;

  AuctionTransaction({
    required this.id,
    required this.productId,
    required this.winnerId,
    required this.amount,
    required this.status,
    this.stripePaymentIntentId,
    required this.createdAt,
  });

  factory AuctionTransaction.fromJson(Map<String, dynamic> json) {
    return AuctionTransaction(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      winnerId: json['winner_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      stripePaymentIntentId: json['stripe_payment_intent_id'] as String?,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'winner_id': winnerId,
      'amount': amount,
      'status': status,
      'stripe_payment_intent_id': stripePaymentIntentId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
