import 'package:flutter/material.dart';

final pagesData = [
  (Colors.black, Colors.white, "مرحبا بك في برنامج المزاد 👋"),
  (Colors.white, Colors.black, "شارك في المزادات واربح أفضل الصفقات 🔥"),
  (Colors.black, Colors.white, "بدّل أو تبنّى المنتجات بسهولة ✨"),
  (Colors.white, Colors.black, "يلا نبدأ رحلتك 🚀"),
];

List<Widget> buildPages(List<(Color, Color, String)> data) {
  return data.map((page) {
    final bgColor = page.$1;
    final textColor = (bgColor == Colors.black) ? Colors.white : Colors.black;

    return Container(
      color: bgColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            page.$3,
            style: TextStyle(
              fontSize: 26,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }).toList();
}
