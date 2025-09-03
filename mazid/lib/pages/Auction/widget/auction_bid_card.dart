// lib/pages/Auction/widget/auction_bid_card.dart
import 'package:flutter/material.dart';
import 'package:mazid/core/models/BidModel.dart';

class AuctionBidCard extends StatelessWidget {
  final BidModel bid;

  const AuctionBidCard({super.key, required this.bid});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange,
          child: Text(bid.amount.toStringAsFixed(0)),
        ),
        title: Text(
          "User: ${bid.userId}",
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          "Bid: \$${bid.amount.toStringAsFixed(2)}",
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Text(
          "${bid.time.hour}:${bid.time.minute}",
          style: const TextStyle(color: Colors.white54),
        ),
      ),
    );
  }
}
