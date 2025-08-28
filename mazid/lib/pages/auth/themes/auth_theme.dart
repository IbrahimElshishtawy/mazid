import 'package:flutter/material.dart';

ThemeData buildLightTheme() {
  const seed = Color(0xFF006B77);
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    fontFamily: 'Inter',
  );
}

ThemeData buildDarkTheme() {
  const seed = Color(0xFF75E6DA);
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    fontFamily: 'Inter',
  );
}
