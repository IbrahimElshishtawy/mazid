// lib/pages/Auction/widget/auction_seller_bid_card.dart
import 'package:flutter/material.dart';
import 'package:mazid/core/models/BidModel.dart';

class AuctionSellerBidCard extends StatelessWidget {
  final BidModel bid;
  final bool isHighest;

  const AuctionSellerBidCard({
    super.key,
    required this.bid,
    this.isHighest = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isHighest ? Colors.green[800] : Colors.grey[850],
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        title: Text(
          "User: ${bid.userId}",
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          "Bid Amount: \$${bid.amount.toStringAsFixed(2)}",
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: isHighest
            ? const Icon(Icons.star, color: Colors.yellow)
            : null,
      ),
    );
  }
}
