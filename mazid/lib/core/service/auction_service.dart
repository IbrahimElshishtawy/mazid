import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transaction.dart';

class TransactionService {
  final supabase = Supabase.instance.client;

  Future<void> createTransaction(AuctionTransaction tx) async {
    await supabase.from('transactions').insert(tx.toJson());
  }

  Future<List<AuctionTransaction>> getUserTransactions(String userId) async {
    final response = await supabase
        .from('transactions')
        .select()
        .eq('winner_id', userId);

    return (response as List)
        .map((json) => AuctionTransaction.fromJson(json))
        .toList();
  }

  Future<List<AuctionTransaction>> getProductTransactions(
    String productId,
  ) async {
    final response = await supabase
        .from('transactions')
        .select()
        .eq('product_id', productId);

    return (response as List)
        .map((json) => AuctionTransaction.fromJson(json))
        .toList();
  }

  Future<void> updateTransactionStatus(String txId, String newStatus) async {
    await supabase
        .from('transactions')
        .update({'status': newStatus})
        .eq('id', txId);
  }

  /// 🔹 تحديث Stripe PaymentIntent ID (لو رجع من Stripe)
  Future<void> attachStripePaymentIntent(
    String txId,
    String paymentIntentId,
  ) async {
    await supabase
        .from('transactions')
        .update({'stripe_payment_intent_id': paymentIntentId})
        .eq('id', txId);
  }
}
