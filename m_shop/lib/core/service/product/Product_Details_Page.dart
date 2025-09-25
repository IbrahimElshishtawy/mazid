// Product_Details_Page.dart
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:m_shop/core/models/prouduct/product_models.dart' as pm;
import 'package:m_shop/page/Details/widget/Carouse_lImages_Widget.dart';
import 'package:m_shop/page/Details/widget/ProductInfo_Widget.dart';
import 'package:m_shop/page/Details/widget/Product_Description_Widget.dart';

class ProductDetailsPage extends StatefulWidget {
  final pm.BaseProduct product; // يقبل ProductModel أو SwapProductModel

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int activeIndex = 0;
  bool isFavorite = false;

  // محوّل بسيط من BaseProduct إلى ProductModel لو الويدجتس لسه بتطلب ProductModel
  pm.ProductModel _asProductModel(pm.BaseProduct p) {
    if (p is pm.ProductModel) return p;
    // بناء ProductModel "حدّ أدنى" بالحقول المشتركة + قيم افتراضية للباقي
    return pm.ProductModel(
      id: p.id,
      status: '',
      category: '',
      name: p.name,
      title: p.title,
      price: 0.0,
      description: '',
      image: p.image,
      images: p.images,
      company: '',
      countInStock: 0,
      v: 0,
      sales: 0,
      // rating/ratingCount لهم قيم افتراضية داخل الـ constructor
    );
  }

  @override
  Widget build(BuildContext context) {
    final base = widget.product;
    final pm.ProductModel productForChildren = _asProductModel(base);

    final List<String> images = base.images.isNotEmpty
        ? base.images
        : [base.image];

    final String titleOrName = base.title.isNotEmpty ? base.title : base.name;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Text(titleOrName, overflow: TextOverflow.ellipsis),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => setState(() => isFavorite = !isFavorite),
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.orangeAccent,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselImagesWidget(
              images: images,
              activeIndex: activeIndex,
              onPageChanged: (index) => setState(() => activeIndex = index),
              productId: base.id, // من الـ BaseProduct مباشرة
            ),
            const SizedBox(height: 16),
            // نمرّر ProductModel للويدجتس القديمة
            ProductInfoWidget(product: productForChildren),
            const SizedBox(height: 16),
            ProductDescriptionWidget(product: productForChildren),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AddToCartButton(product: productForChildren),
            ),
          ],
        ),
      ),
    );
  }
}
