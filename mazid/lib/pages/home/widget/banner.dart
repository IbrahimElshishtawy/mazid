import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  final String text;
  final String imageUrl;
  final double height;
  final double width;

  const BannerWidget(
    this.text, {
    super.key,
    required this.imageUrl,
    this.height = 150,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(imageUrl), // هنا لو الصورة محلية
          // image: NetworkImage(imageUrl), // هنا لو الصورة من الإنترنت
          fit: BoxFit.cover, // عشان الصورة تملأ البانر كله
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.black.withOpacity(0.4), // طبقة شفافة غامقة فوق الصورة
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
