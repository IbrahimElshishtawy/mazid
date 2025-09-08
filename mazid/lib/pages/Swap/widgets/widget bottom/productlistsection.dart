// import 'package:flutter/material.dart';
// import 'package:mazid/pages/Swap/ui/ProductDetailPageswap.dart';
// import 'package:mazid/pages/Swap/widgets/widget%20bottom/custom_product_card.dart';

// /// Widget مسؤول عن عرض قائمة من المنتجات (ListView).
// /// - بياخد List من المنتجات (products).
// /// - وكمان بياخد pageType (نوع الصفحة) عشان يحدد شكل الأزرار أو الحالة.
// class ProductListSection extends StatelessWidget {
//   final List<Map<String, dynamic>>
//   products; // قائمة المنتجات (imageUrl, name, rating..)
//   final String pageType; // نوع الصفحة (مثلاً: myProducts, accepted, pending...)

//   const ProductListSection({
//     super.key,
//     required this.products,
//     required this.pageType,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // ✅ لو القائمة فاضية يظهر رسالة "لا توجد منتجات"
//     if (products.isEmpty) {
//       return const Center(
//         child: Text(
//           "لا توجد منتجات",
//           style: TextStyle(color: Colors.white70, fontSize: 16),
//         ),
//       );
//     }

//     // ✅ عرض المنتجات في ListView
//     return ListView.builder(
//       padding: const EdgeInsets.all(12),
//       itemCount: products.length,
//       itemBuilder: (context, index) {
//         final product = products[index];

//         return Card(
//           color: Colors.grey[900],
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           margin: const EdgeInsets.symmetric(vertical: 8),
//           elevation: 4,

//           // ✅ الكارت المخصص لكل منتج (ProductCardswap)
//           child: ProductCardswap(

//             onSwapRequest: () {
//               // 🔹 عند الضغط → الانتقال لصفحة تفاصيل المنتج
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) =>
//                       ProductDetailPage(product: product, type: pageType),

//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
