import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:m_shop/core/theme/app_theme.dart';
import 'package:m_shop/features/auth/presentation/login_screen.dart';
import 'package:m_shop/features/dashboard/application/dashboard_store.dart';
import 'package:redux/redux.dart';

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key, required this.store});

  final Store<DashboardState> store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<DashboardState>(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Factory Dashboard',
        theme: AppTheme.light(),
        home: const LoginScreen(),
      ),
    );
  }
}
