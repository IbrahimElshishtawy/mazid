import 'package:flutter/material.dart';
import 'package:mazid/core/models/swap_request_model.dart';
import 'package:mazid/core/service/swap_service.dart';

class ProductCardMenu extends StatelessWidget {
  final SwapRequestModel? swapRequest;
  final SwapService? swapService;

  const ProductCardMenu({super.key, this.swapRequest, this.swapService});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      icon: const Icon(Icons.more_vert, color: Colors.white),
      onSelected: (value) {
        switch (value) {
          case "details":
            if (swapRequest != null && swapService != null) {
              // التنقل لصفحة التفاصيل
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("لا توجد تفاصيل متاحة لهذا المنتج"),
                ),
              );
            }
            break;
          case "cart":
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("تمت إضافة المنتج إلى السلّة")),
            );
            break;
          case "remove":
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("تمت إزالة المنتج")));
            break;
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: "details",
          child: Row(
            children: [
              Icon(Icons.info, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text("عرض التفاصيل"),
            ],
          ),
        ),
        PopupMenuItem(
          value: "cart",
          child: Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text("إضافة إلى السلّة"),
            ],
          ),
        ),
        PopupMenuItem(
          value: "remove",
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red, size: 20),
              SizedBox(width: 8),
              Text("إزالة"),
            ],
          ),
        ),
      ],
    );
  }
}
