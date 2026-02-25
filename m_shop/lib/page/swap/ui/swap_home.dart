// swap_home.dart
import 'package:flutter/material.dart';
import 'package:m_shop/core/models/swap/swap_request_model.dart';
import 'package:m_shop/core/models/swap/swap_status.dart';
import 'package:m_shop/core/widget/swap/widgets/swap_lists.dart';
import 'package:m_shop/core/widget/swap/widgets/swaptabar.dart';

class SwapHome extends StatefulWidget {
  const SwapHome({super.key});

  @override
  State<SwapHome> createState() => _SwapHomeState();
}

class _SwapHomeState extends State<SwapHome> with TickerProviderStateMixin {
  late TabController _tabController;

  // بيانات المنتجات (مؤقتة للتجربة)
  final List<SwapProductModel> allProducts = [
    SwapProductModel(
      id: "1",
      name: "موبايل سامسونج",
      description: "موبايل جديد بالكرتونة",
      imageUrl: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_t.png",
      ownerId: "أحمد",
      status: "pending",
      createdAt: DateTime.now(),
      price: 4500,
      rating: 4.5,
      title: '',
      image: '',
      images: [],
      swapId: '',
      requesterId: '',
    ),
    SwapProductModel(
      id: "2",
      name: "لاب توب HP",
      description: "Core i7 / RAM 16GB",
      imageUrl: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_t.png",
      ownerId: "منى",
      status: "accepted",
      createdAt: DateTime.now(),
      price: 12000,
      rating: 4.8,
      title: '',
      image: '',
      images: [],
      swapId: '',
      requesterId: '',
    ),
    SwapProductModel(
      id: "3",
      name: "سماعات بلوتوث",
      description: "سماعات لاسلكية بجودة عالية",
      imageUrl: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_t.png",
      ownerId: "خالد",
      status: "request",
      createdAt: DateTime.now(),
      price: 800,
      rating: 4.2,
      title: '',
      image: '',
      images: [],
      swapId: '',
      requesterId: '',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  void _showExchangeRequestForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Request Exchange", style: TextStyle(color: Colors.orangeAccent, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "What do you want to exchange?",
                hintStyle: const TextStyle(color: Colors.white24),
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Description of your item",
                hintStyle: const TextStyle(color: Colors.white24),
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Exchange request submitted!")));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Submit Request", style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: SwapTabBar(controller: _tabController),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showExchangeRequestForm,
          backgroundColor: Colors.orangeAccent,
          child: const Icon(Icons.swap_horiz, color: Colors.black),
        ),
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [
              ProductListView(
                products: allProducts,
                status: SwapStatus.myProducts,
              ),
              ProductListView(
                products: allProducts,
                status: SwapStatus.accepted,
              ),
              ProductListView(
                products: allProducts,
                status: SwapStatus.pending,
              ),
              RequestListView(products: allProducts),
              HistoryListView(products: allProducts),
            ],
          ),
        ),
      ),
    );
  }
}
