import 'package:flutter/material.dart';
import 'package:mazid/core/models/auction_model.dart';
import 'package:mazid/core/service/auction_service.dart';
import 'package:mazid/pages/Auction/ui/auction_detail_page.dart';
import 'package:mazid/pages/Auction/widget/shared_widgets.dart';

class AuctionListPage extends StatefulWidget {
  const AuctionListPage({super.key});

  @override
  State<AuctionListPage> createState() => _AuctionListPageState();
}

class _AuctionListPageState extends State<AuctionListPage> {
  final AuctionService _auctionService = AuctionService();
  List<AuctionModel> _auctions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAuctions();
  }

  Future<void> _loadAuctions() async {
    setState(() => _isLoading = true);
    try {
      final auctions = await _auctionService.fetchAllAuctions();
      if (!mounted) return;
      setState(() {
        _auctions = auctions;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Auctions"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: _isLoading
          ? const LoadingIndicator()
          : _auctions.isEmpty
          ? const Center(
              child: Text(
                "No auctions available",
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              itemCount: _auctions.length,
              itemBuilder: (context, index) {
                final auction = _auctions[index];
                return Card(
                  color: Colors.grey[850],
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      "Product ID: ${auction.productId}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "Starting Price: \$${auction.startingPrice.toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: auction.isActive
                        ? const Icon(Icons.gavel, color: Colors.orange)
                        : const Icon(
                            Icons.stop_circle,
                            color: Colors.redAccent,
                          ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AuctionDetailPage(auction: auction),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
