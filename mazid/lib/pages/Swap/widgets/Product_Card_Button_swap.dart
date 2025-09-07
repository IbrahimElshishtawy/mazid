// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ProductCardButton extends StatelessWidget {
  final String pageType;
  final bool isPending;
  final VoidCallback onPressed;

  const ProductCardButton({
    super.key,
    required this.pageType,
    required this.isPending,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    switch (pageType) {
      case "myProducts":
        return ElevatedButton.icon(
          onPressed: () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("منتجاتي"))),
          icon: const Icon(Icons.inventory, color: Colors.white),
          label: const Text("هذا منتجك", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      case "accepted":
        return ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.check, color: Colors.white),
          label: const Text("تم القبول", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      case "pending":
        return ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.hourglass_bottom, color: Colors.white),
          label: const Text(
            "قيد الانتظار",
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      default:
        return ElevatedButton.icon(
          onPressed: isPending ? null : onPressed,
          icon: const Icon(Icons.swap_horiz, color: Colors.white),
          label: Text(
            isPending ? "قيد الانتظار" : "تقديم طلب تبديل",
            style: const TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: isPending ? Colors.orange : Colors.deepOrange,
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
    }
  }
}
