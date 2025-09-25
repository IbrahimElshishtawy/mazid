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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: SwapTabBar(controller: _tabController),
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
