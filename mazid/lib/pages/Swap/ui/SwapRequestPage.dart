import 'package:flutter/material.dart';
import 'package:mazid/core/models/swap_request_model.dart';
import 'package:mazid/core/service/swap_service.dart';
import 'package:mazid/pages/Swap/ui/swap_flow_detail_page.dart';
import 'package:mazid/pages/Swap/widgets/custom_product_card.dart';
import 'package:mazid/pages/Swap/widgets/swap_status_indicator.dart'
    show SwapStatusIndicator;

class SwapRequestPage extends StatefulWidget {
  final SwapService swapService;
  final String currentUserId;

  const SwapRequestPage({
    super.key,
    required this.swapService,
    required this.currentUserId,
  });

  @override
  State<SwapRequestPage> createState() => _SwapRequestPageState();
}

class _SwapRequestPageState extends State<SwapRequestPage> {
  SwapStatus? filterStatus;

  @override
  Widget build(BuildContext context) {
    List<SwapRequestModel> requests = widget.swapService.getAllRequests();
    if (filterStatus != null) {
      requests = requests.where((r) => r.status == filterStatus).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Swap Requests"),
        actions: [
          PopupMenuButton<SwapStatus?>(
            icon: const Icon(Icons.filter_alt),
            onSelected: (status) {
              setState(() {
                filterStatus = status;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: null, child: Text("All")),
              const PopupMenuItem(
                value: SwapStatus.pending,
                child: Text("Pending"),
              ),
              const PopupMenuItem(
                value: SwapStatus.accepted,
                child: Text("Accepted"),
              ),
              const PopupMenuItem(
                value: SwapStatus.rejected,
                child: Text("Rejected"),
              ),
            ],
          ),
        ],
      ),
      body: requests.isEmpty
          ? const Center(child: Text("No swap requests"))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final req = requests[index];
                final isSender = req.senderId == widget.currentUserId;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    title: Text(
                      "${req.senderProduct.title} ⇄ ${req.receiverProduct.title}",
                    ),
                    subtitle: SwapStatusIndicator(status: req.status),
                    trailing: isSender
                        ? null
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomBtn(
                                text: "Accept",
                                color: Colors.green,
                                onPressed: () {
                                  widget.swapService.acceptRequest(req.id);
                                  setState(() {});
                                },
                              ),
                              const SizedBox(width: 8),
                              CustomBtn(
                                text: "Reject",
                                color: Colors.red,
                                onPressed: () {
                                  widget.swapService.rejectRequest(req.id);
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SwapFlowDetailPage(
                            swapRequest: req,
                            swapService: widget.swapService,
                          ),
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
