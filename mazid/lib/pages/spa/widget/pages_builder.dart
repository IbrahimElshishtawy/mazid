import 'package:flutter/material.dart';
import 'package:mazid/pages/auth/login.dart';

import 'package:mazid/pages/spa/page/intro_page1.dart';
import 'package:mazid/pages/spa/page/intro_page2.dart';
import 'package:mazid/pages/spa/page/inrto_page3.dart';

final pagesData = [
  (Colors.black, Colors.white, "intro"),
  (Colors.white, Colors.black, "intro"),
  (Colors.black, Colors.white, "intro"),
  (Colors.white, Colors.black, "login"),
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
        return const LoginPage();
    }
  });
}
