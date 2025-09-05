import 'package:flutter/material.dart';
import 'package:mazid/core/models/swap_request_model.dart';
import 'package:mazid/core/service/swap_service.dart';
import 'package:mazid/pages/Swap/widgets/swap_status_indicator.dart';

class SwapFlowDetailPage extends StatelessWidget {
  final SwapRequestModel swapRequest;
  final SwapService swapService;

  const SwapFlowDetailPage({
    super.key,
    required this.swapRequest,
    required this.swapService,
  });

  @override
  Widget build(BuildContext context) {
    final sender = swapRequest.senderProduct;
    final receiver = swapRequest.receiverProduct;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: CustomScrollView(
        slivers: [
          // AppBar مع صورة المنتج
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text("تفاصيل المنتج"),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(sender.images as String, fit: BoxFit.cover),
                  Container(color: Colors.black.withOpacity(0.4)),
                ],
              ),
            ),
          ),

          // باقي التفاصيل
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // المنتج المرسل
                  Text(
                    "منتج المرسل",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildProductCard(sender),

                  const SizedBox(height: 20),

                  // المنتج المستقبل
                  Text(
                    "منتج المستقبل",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildProductCard(receiver),

                  const SizedBox(height: 20),

                  // حالة الطلب
                  Center(
                    child: SwapStatusIndicator(status: swapRequest.status),
                  ),

                  const SizedBox(height: 20),

                  // أزرار التحكم
                  if (swapRequest.status == SwapStatus.pending)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            swapService.acceptRequest(swapRequest.id);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 24,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.check, color: Colors.white),
                          label: const Text(
                            "قبول",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            swapService.rejectRequest(swapRequest.id);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 24,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.close, color: Colors.white),
                          label: const Text(
                            "رفض",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(dynamic product) {
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                product.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.description ?? "لا يوجد وصف",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
