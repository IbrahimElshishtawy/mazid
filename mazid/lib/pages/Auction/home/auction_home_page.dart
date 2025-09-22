import 'package:flutter/material.dart';
import 'package:mazid/core/data/dummyProducts.dart';
import 'package:mazid/core/models/swap/swap_request_model.dart';
import 'package:mazid/core/models/swap/swap_status.dart';
import 'package:mazid/pages/Auction/ui/product_detail_page.dart';
import 'package:mazid/pages/Auction/widget/swap_search_field.dart';

/// الصفحة الرئيسية للمزاد (مقسّمة لمكوّنات)
class AuctionHomePage extends StatefulWidget {
  const AuctionHomePage({super.key});

  @override
  State<AuctionHomePage> createState() => _AuctionHomePageState();
}

enum StatusFilter { all, available, pending, sold }

class _AuctionHomePageState extends State<AuctionHomePage> {
  StatusFilter _filter = StatusFilter.all;
  String _query = '';

  SwapStatus _mapStatus(dynamic status) {
    if (status is SwapStatus) return status;
    final s = status.toString().toLowerCase().trim();
    if (s == 'pending') return SwapStatus.pending;
    if (s == 'sold') return SwapStatus.sold;
    return SwapStatus.available;
  }

  bool _applyFilter(SwapProductModel p) {
    final s = _mapStatus(p.status);
    switch (_filter) {
      case StatusFilter.available:
        return s == SwapStatus.available;
      case StatusFilter.pending:
        return s == SwapStatus.pending;
      case StatusFilter.sold:
        return s == SwapStatus.sold;
      case StatusFilter.all:
        return true;
    }
  }

  bool _applySearch(SwapProductModel p) {
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    // حاول نلاقي اسم/عنوان المنتج. عدّل الحقول حسب موديلك لو مختلفة.
    final title = (p.title ?? p.toString()).toString().toLowerCase();
    return title.contains(q);
  }

  @override
  Widget build(BuildContext context) {
    final List<SwapProductModel> source = dummySwapProducts;
    final filtered = source
        .where((p) => _applyFilter(p) && _applySearch(p))
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Mazid Auctions'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: SwapSearchField(
              hintText: 'ابحث عن منتج…',
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          // شريط الفلترة بالحالة
          StatusFilterBar(
            current: _filter,
            onChanged: (f) => setState(() => _filter = f),
          ),

          // الشبكة
          Expanded(
            child: SwapGrid(
              products: filtered,
              childAspectRatio: 0.65,
              onTap: (product) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailPagemazid(product: product),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
