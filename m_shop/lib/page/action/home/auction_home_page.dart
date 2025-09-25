// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:mazid/core/data/dummyProducts.dart';
import 'package:mazid/core/models/swap/swap_request_model.dart';
import 'package:mazid/core/models/swap/swap_status.dart';
import 'package:mazid/pages/Auction/ui/product_detail_page.dart';
import 'package:mazid/pages/Auction/widget/Swap_Grid.dart';
import 'package:mazid/pages/Auction/widget/status_filter_bar.dart';

/// قسم/صفحة المزاد لعرضه داخل الـ Home body (بدون Scaffold)
class AuctionHomePage extends StatefulWidget {
  const AuctionHomePage({super.key});

  @override
  State<AuctionHomePage> createState() => _AuctionHomePageState();
}

enum StatusFilter { all, available, pending, sold }

class _AuctionHomePageState extends State<AuctionHomePage> {
  StatusFilter _filter = StatusFilter.all;
  final String _query = '';

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
    final title = (p.title).toString().toLowerCase();
    return title.contains(q);
  }

  @override
  Widget build(BuildContext context) {
    final List<SwapProductModel> source = dummySwapProducts;
    final filtered = source
        .where((p) => _applyFilter(p) && _applySearch(p))
        .toList();

    // محتوى “صفحة عادية” للعرض داخل body الهوم
    return SafeArea(
      top: false, // سيب الهوم يتحكم في الـ AppBar لو موجود
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            // فلترة الحالات
            StatusFilterBar(
              current: _filter,
              onChanged: (f) => setState(() => _filter = f),
            ),
            const SizedBox(height: 8),

            // الشبكة
            Expanded(
              child: SwapGrid(
                products: filtered,
                childAspectRatio: 1,
                statusOf: _mapStatus,
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
      ),
    );
  }
}
