import 'package:flutter/material.dart';
import 'package:mazid/core/models/swap_request_model.dart';
import 'package:mazid/core/models/swap_status.dart';
import 'package:mazid/pages/Swap/widgets/swaptabar.dart';
import 'package:mazid/pages/Swap/widgets/widget%20bottom/custom_product_card.dart';

class SwapHome extends StatefulWidget {
  const SwapHome({super.key});

  @override
  State<SwapHome> createState() => _SwapHomeState();
}

class _SwapHomeState extends State<SwapHome> with TickerProviderStateMixin {
  late TabController _tabController;

  // بيانات تجريبية
  final List<SwapProductModel> myProducts = [
    SwapProductModel(
      id: "1",
      name: "موبايل سامسونج",
      description: "موبايل جديد بالكرتونة",
      imageUrl: "https://via.placeholder.com/150",
      ownerId: "user1",
      status: "pending",
      createdAt: DateTime.now(),
      price: 4500,
      rating: 4.5,
    ),
    SwapProductModel(
      id: "2",
      name: "لاب توب HP",
      description: "Core i7 / RAM 16GB",
      imageUrl: "https://via.placeholder.com/150",
      ownerId: "user2",
      status: "accepted",
      createdAt: DateTime.now(),
      price: 12000,
      rating: 4.8,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("التبديل"),
          bottom: const SwapTabBar(),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildProductList(SwapStatus.myProducts),
            _buildProductList(SwapStatus.accepted),
            _buildProductList(SwapStatus.pending),
            _buildProductList(SwapStatus.request),
            _buildProductList(SwapStatus.completed),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(SwapStatus status) {
    final filtered = myProducts.where((p) {
      switch (status) {
        case SwapStatus.myProducts:
          return true; // كل المنتجات
        case SwapStatus.accepted:
          return p.status == "accepted";
        case SwapStatus.pending:
          return p.status == "pending";
        case SwapStatus.request:
          return p.status == "request";
        case SwapStatus.completed:
          return p.status == "completed";
        default:
          return false;
      }
    }).toList();

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return ProductCardswap(product: filtered[index], status: status);
      },
    );
  }
}
