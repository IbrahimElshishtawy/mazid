// lib/pages/Auction/ui/auction_seller_page.dart

// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:mazid/core/models/BidModel.dart';
import 'package:mazid/core/models/auction_model.dart';

import 'package:mazid/core/service/auction_service.dart';
import 'package:mazid/pages/Auction/widget/auction_seller_bid_card.dart';
import 'package:mazid/pages/Auction/widget/shared_widgets.dart';

class AuctionSellerPage extends StatefulWidget {
  final AuctionModel auction;

  const AuctionSellerPage({super.key, required this.auction});

  @override
  State<AuctionSellerPage> createState() => _AuctionSellerPageState();
}

class _AuctionSellerPageState extends State<AuctionSellerPage> {
  final AuctionService _auctionService = AuctionService();
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

  Future<void> _finishAuction() async {
    await _auctionService.markAuctionAsFinished(widget.auction.id);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Auction Finished!')));
    setState(() {
      widget.auction.isActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final highestBid = _bids.isNotEmpty ? _bids.first : null;

    return Scaffold(
      appBar: AppBar(
        title: Text("Auction: ${widget.auction.productId}"),
        backgroundColor: Colors.black,
        actions: [
          if (widget.auction.isActive)
            IconButton(
              icon: const Icon(Icons.stop_circle, color: Colors.redAccent),
              onPressed: _finishAuction,
              tooltip: "Finish Auction",
            ),
        ],
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
                            return AuctionSellerBidCard(
                              bid: bid,
                              isHighest: bid == highestBid,
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
