import 'package:flutter/material.dart';
import 'package:mazid/core/models/swap/swap_request_model.dart';
import 'package:mazid/core/models/swap/swap_status.dart';
import 'package:mazid/pages/Swap/widgets/swaptabar.dart';
import 'package:mazid/pages/Swap/widgets/custom_product_card.dart';

class SwapHome extends StatefulWidget {
  const SwapHome({super.key});

  @override
  State<SwapHome> createState() => _SwapHomeState();
}

class _SwapHomeState extends State<SwapHome> with TickerProviderStateMixin {
  late TabController _tabController;

  // بيانات المنتجات
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
              _buildProductList(SwapStatus.myProducts), // منتجات
              _buildProductList(SwapStatus.accepted), // مقبولة
              _buildProductList(SwapStatus.pending), // معلقة
              _buildRequestList(), // موافقة
              _buildHistoryList(), // السجل
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductList(SwapStatus status) {
    final filtered = allProducts.where((p) {
      switch (status) {
        case SwapStatus.myProducts:
          return true;
        case SwapStatus.accepted:
          return p.status == "accepted";
        case SwapStatus.pending:
          return p.status == "pending";
        case SwapStatus.request:
          return p.status == "request";
        case SwapStatus.completed:
          return false;
        case SwapStatus.approved:
        case SwapStatus.other:
          throw UnimplementedError();
      }
    }).toList();

    if (filtered.isEmpty) {
      return const Center(
        child: Text(
          "لا يوجد منتجات هنا",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return ProductCardswap(product: filtered[index], status: status);
      },
    );
  }

  /// تبويب طلبات الموافقة (نفس كارت المنتج مع أزرار)
  Widget _buildRequestList() {
    final requests = allProducts.where((p) => p.status == "request").toList();

    if (requests.isEmpty) {
      return const Center(
        child: Text(
          "لا يوجد طلبات تبديل",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final req = requests[index];
        return ProductCardswap(
          product: req,
          status: SwapStatus.request,
          extraActions: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    req.status = "accepted";
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("تم قبول طلب التبديل للمنتج ${req.name}"),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("قبول"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    req.status = "rejected";
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("تم رفض طلب التبديل للمنتج ${req.name}"),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("رفض"),
              ),
            ],
          ),
        );
      },
    );
  }

  /// تبويب السجل (نفس كارت المنتج مع حالة ملونة)
  Widget _buildHistoryList() {
    final history = allProducts
        .where(
          (p) =>
              p.status == "accepted" ||
              p.status == "rejected" ||
              p.status == "completed",
        )
        .toList();

    if (history.isEmpty) {
      return const Center(
        child: Text(
          "لا توجد سجلات طلبات",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        Color statusColor;
        String statusText;

        switch (item.status) {
          case "accepted":
            statusColor = Colors.green;
            statusText = "✔ تم القبول";
            break;
          case "rejected":
            statusColor = Colors.red;
            statusText = "❌ مرفوض";
            break;
          case "completed":
            statusColor = Colors.blue;
            statusText = "✅ مكتمل";
            break;
          default:
            statusColor = Colors.grey;
            statusText = "غير معروف";
        }

        return ProductCardswap(
          product: item,
          status: SwapStatus.completed,
          extraActions: Text(
            statusText,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
