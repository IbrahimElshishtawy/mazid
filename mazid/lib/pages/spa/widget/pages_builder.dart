import 'package:flutter/material.dart';
import 'package:mazid/pages/home/home_page.dart';
import 'package:mazid/pages/spa/page/inrto_page3.dart';
import 'package:mazid/pages/spa/page/intro_page1.dart';
import 'package:mazid/pages/spa/page/intro_page2.dart';

final pagesData = [
  (Colors.black, Colors.white, "intro"), // الصفحة الأولى خاصة
  (Colors.white, Colors.black, "intro"), // الصفحة الثانية خاصة
  (Colors.black, Colors.white, "intro"),
  (Colors.white, Colors.black, "home"), // الصفحة الثالثة خاصة
];

List<Widget> buildPages(List<(Color, Color, String)> data) {
  return List.generate(data.length, (index) {
    final page = data[index];
    final bgColor = page.$1;
    final textColor = (bgColor == Colors.black) ? Colors.white : Colors.black;

    switch (index) {
      case 0:
        return IntroPage1(textColor: textColor);
      case 1:
        return IntroPage2(textColor: textColor);
      case 2:
        return IntroPage3(textColor: textColor);
      default:
        return HomePage();
    }
  });
}
