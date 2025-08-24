import 'package:flutter/material.dart';
import 'package:mazid/pages/spa/page/intro_page.dart';

final pagesData = [
  (Colors.black, Colors.white, "intro"), // الصفحة الأولى خاصة
  (Colors.white, Colors.black, "شارك في المزادات واربح أفضل الصفقات 🔥"),
  (Colors.black, Colors.white, "بدّل أو تبنّى المنتجات بسهولة ✨"),
  (Colors.white, Colors.black, "يلا نبدأ رحلتك 🚀"),
];

List<Widget> buildPages(List<(Color, Color, String)> data) {
  return data.asMap().entries.map((entry) {
    final index = entry.key;
    final page = entry.value;

    final bgColor = page.$1;
    final textColor = (bgColor == Colors.black) ? Colors.white : Colors.black;

    // ✅ الصفحة الأولى تستدعي IntroPage
    if (index == 0) {
      return IntroPageAnimated(textColor: textColor);
    }

    // ✅ باقي الصفحات عادية
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
