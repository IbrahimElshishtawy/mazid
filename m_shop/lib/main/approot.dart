import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:m_shop/core/repository/home_repository.dart';
import 'package:m_shop/page/home/logic/home_cubit.dart';
import 'package:m_shop/page/home/ui/home_page.dart';

class AppRoot extends StatelessWidget {
  final HomeRepository repo;
  const AppRoot({super.key, required this.repo});

  /// Factory مساعد يسهّل تمرير الـ repo من main()
  factory AppRoot.withRepo(HomeRepository repo) => AppRoot(repo: repo);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<HomeRepository>.value(
      value: repo,
      child: BlocProvider<HomeCubit>(
        create: (ctx) {
          final cubit = HomeCubit(ctx.read<HomeRepository>());
          // ما نعطّلش بناء الواجهة
          unawaited(cubit.init());
          return cubit;
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'M Shop',
          theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
          home: const HomePage(),
        ),
      ),
    );
  }
}
