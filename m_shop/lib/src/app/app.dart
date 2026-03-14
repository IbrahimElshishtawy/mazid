import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:m_shop/src/dashboard/core/dashboard_store.dart';
import 'package:m_shop/src/dashboard/presentation/dashboard_screen.dart';

class FactoryControlApp extends StatelessWidget {
  const FactoryControlApp({super.key});

  static final store = createDashboardStore();

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F766E),
      brightness: Brightness.light,
    );

    return StoreProvider<DashboardState>(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Factory Dashboard',
        theme: ThemeData(
          colorScheme: scheme,
          scaffoldBackgroundColor: const Color(0xFFF3F7F6),
          useMaterial3: true,
          fontFamily: 'sans-serif',
          cardTheme: CardThemeData(
            elevation: 0,
            margin: EdgeInsets.zero,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(color: Color(0xFFE5ECE9)),
            ),
          ),
        ),
        home: const DashboardScreen(),
      ),
    );
  }
}
