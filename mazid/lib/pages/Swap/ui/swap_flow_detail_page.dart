import 'package:flutter/material.dart';
import 'package:mazid/core/models/swap_request_model.dart';
import 'package:mazid/core/service/swap_service.dart';
import 'package:mazid/pages/Swap/widgets/custom_btn.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text("Swap Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Sender Product",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            CustomProductCard(product: swapRequest.senderProduct),
            const SizedBox(height: 16),
            const Text(
              "Receiver Product",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            CustomProductCard(product: swapRequest.receiverProduct),
            const SizedBox(height: 16),
            SwapStatusIndicator(status: swapRequest.status),
            const SizedBox(height: 16),
            if (swapRequest.status == SwapStatus.pending)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      swapService.acceptRequest(swapRequest.id);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text("Accept"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      swapService.rejectRequest(swapRequest.id);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text("Reject"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
