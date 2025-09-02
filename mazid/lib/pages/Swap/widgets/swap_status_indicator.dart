import 'package:flutter/material.dart';
import 'package:mazid/core/models/swap_request_model.dart';

class SwapStatusIndicator extends StatelessWidget {
  final SwapStatus status;

  const SwapStatusIndicator({super.key, required this.status});

  Color get statusColor {
    switch (status) {
      case SwapStatus.accepted:
        return Colors.green;
      case SwapStatus.rejected:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String get statusText {
    switch (status) {
      case SwapStatus.accepted:
        return "Accepted";
      case SwapStatus.rejected:
        return "Rejected";
      default:
        return "Pending";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
