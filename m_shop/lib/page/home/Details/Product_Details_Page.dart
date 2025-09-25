// product_details_page.dart
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:mazid/core/models/prouduct/product_models.dart';
import 'package:mazid/pages/home/Details/widget/Carouse_lImages_Widget.dart';

import 'package:mazid/pages/home/Details/widget/ProductInfo_Widget.dart';
import 'package:mazid/pages/home/Details/widget/Product_Description_Widget.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int activeIndex = 0;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final List<String> images = widget.product.images.isNotEmpty
        ? widget.product.images
        : [widget.product.image];

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Text(
          widget.product.title.isNotEmpty
              ? widget.product.title
              : widget.product.name,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.orangeAccent,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselImagesWidget(
              images: images,
              activeIndex: activeIndex,
              onPageChanged: (index) {
                setState(() {
                  activeIndex = index;
                });
              },
              productId: widget.product.id,
            ),
            const SizedBox(height: 16),
            ProductInfoWidget(product: widget.product),
            const SizedBox(height: 16),
            ProductDescriptionWidget(product: widget.product),
            const SizedBox(height: 24),
            AddToCartButton(product: widget.product),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
