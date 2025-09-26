import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:m_shop/core/repository/home_repository.dart';
import 'package:m_shop/page/home/controller/home_controller.dart';
import 'package:m_shop/page/home/ui/home_page.dart';

class AppRoot extends StatelessWidget {
  final HomeRepository repo;

  const AppRoot({super.key, required this.repo});

  // تسمح لك تستدعيها كما في main: AppRoot.withRepo(repo)
  factory AppRoot.withRepo(HomeRepository repo) => AppRoot(repo: repo);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<HomeRepository>.value(value: repo),
        ChangeNotifierProvider<HomeController>(
          create: (_) => HomeController(
            authService: repo.authService,
            productService: repo.productService,
          )..initOnce(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mazid',
        theme: ThemeData.dark(useMaterial3: true),
        home: const HomePage(),
      ),
    );
  }
}
