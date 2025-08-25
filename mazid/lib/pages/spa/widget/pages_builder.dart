import 'package:flutter/material.dart';
import 'package:mazid/pages/home/home_page.dart';
import 'package:mazid/pages/spa/page/inrto_page3.dart';
import 'package:mazid/pages/spa/page/intro_page1.dart';
import 'package:mazid/pages/spa/page/intro_page2.dart';

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

    if (index == 0) {
      return IntroPage1(textColor: textColor);
    } else if (index == 1) {
      return IntroPage2(textColor: textColor);
    } else if (index == 2) {
      return InrtoPage3(textColor: textColor);
    } else {
      return HomePage();
    }
  }).toList();
}
