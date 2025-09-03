// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:mazid/core/models/BidModel.dart';
import 'package:mazid/core/models/auction_model.dart';
import 'package:mazid/core/service/auction_service.dart';
import 'package:mazid/pages/Auction/widget/auction_bid_card.dart';
import 'package:mazid/pages/Auction/widget/shared_widgets.dart';

class AuctionDetailPage extends StatefulWidget {
  final AuctionModel auction;

  const AuctionDetailPage({super.key, required this.auction});

  @override
  State<AuctionDetailPage> createState() => _AuctionDetailPageState();
}

class _AuctionDetailPageState extends State<AuctionDetailPage> {
  final AuctionService _auctionService = AuctionService();
  final TextEditingController _bidController = TextEditingController();
  List<BidModel> _bids = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBids();
  }

  Future<void> _loadBids() async {
    setState(() => _isLoading = true);
    try {
      final bids = await _auctionService.fetchBidsForAuction(widget.auction.id);
      if (!mounted) return;
      setState(() {
        _bids = bids;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _placeBid() async {
    final amount = double.tryParse(_bidController.text);
    if (amount == null || amount <= 0) return;

    final bid = BidModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      auctionId: widget.auction.id,
      userId: "currentUserId", // استبدل بالـ User ID الحقيقي
      amount: amount,
      time: DateTime.now(),
    );

    await _auctionService.placeBid(bid);
    _bidController.clear();
    _loadBids();
  }

  @override
  Widget build(BuildContext context) {
    final highestBid = _bids.isNotEmpty ? _bids.first : null;

    return Scaffold(
      appBar: AppBar(
        title: Text("Auction: ${widget.auction.productId}"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: _isLoading
          ? const LoadingIndicator()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    color: Colors.grey[850],
                    child: ListTile(
                      title: Text(
                        "Starting Price: \$${widget.auction.startingPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        widget.auction.isActive
                            ? "Status: Active"
                            : "Status: Finished",
                        style: TextStyle(
                          color: widget.auction.isActive
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _bidController,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Enter your bid",
                            hintStyle: TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.grey,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      CustomButton(text: "Place Bid", onPressed: _placeBid),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _bids.isEmpty
                      ? const Center(
                          child: Text(
                            "No bids yet",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _bids.length,
                          itemBuilder: (context, index) {
                            final bid = _bids[index];
                            return AuctionBidCard(bid: bid);
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
