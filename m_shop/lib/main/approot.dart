import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:m_shop/core/cubit/auth/auth_cubit.dart';
import 'package:m_shop/core/cubit/product/product_cubit.dart';
import 'package:m_shop/core/cubit/product/product_state.dart';
import 'package:m_shop/core/cubit/navigation/navigation_cubit.dart';
import 'package:m_shop/core/cubit/order/order_cubit.dart';
import 'package:m_shop/core/cubit/seller/seller_cubit.dart';
import 'package:m_shop/core/repository/home_repository.dart';
import 'package:m_shop/page/home/ui/home_page.dart';

class AppRoot extends StatelessWidget {
  final HomeRepository repo;

  const AppRoot({super.key, required this.repo});

  // تسمح لك تستدعيها كما في main: AppRoot.withRepo(repo)
  factory AppRoot.withRepo(HomeRepository repo) => AppRoot(repo: repo);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(authService: repo.authService)..checkAuthStatus(),
        ),
        BlocProvider<ProductCubit>(
          create: (_) => ProductCubit(repo.productService)..fetchProducts(),
        ),
        BlocProvider<OrderCubit>(
          create: (_) => OrderCubit()..fetchOrders(),
        ),
        BlocProvider<SellerCubit>(
          create: (_) => SellerCubit()..fetchAnalytics(),
        ),
        BlocProvider<NavigationCubit>(
          create: (_) => NavigationCubit(),
        ),
      ],
      child: MultiProvider(
        providers: [
          Provider<HomeRepository>.value(value: repo),
        ],
        child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mazid',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          primaryColor: Colors.orangeAccent,
          scaffoldBackgroundColor: Colors.black,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.orangeAccent,
            brightness: Brightness.dark,
            primary: Colors.orangeAccent,
            surface: Colors.grey[900],
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            centerTitle: true,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              foregroundColor: Colors.black,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          cardTheme: CardTheme(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        home: const HomePage(),
        ),
      ),
    );
  }
}
