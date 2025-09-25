// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:m_shop/core/widget/home/widget/AppBar_widget.dart';
import 'package:m_shop/core/widget/home/widget/bottom_NavigationBar.dart';
import 'package:m_shop/page/home/controller/home_controller.dart';
import 'package:m_shop/page/home/drawer/ui/drawer_menu.dart';
import 'package:m_shop/page/home/ui/home_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeContents extends StatefulWidget {
  const HomeContents({super.key});

  @override
  _HomeContentsState createState() => _HomeContentsState();
}

class _HomeContentsState extends State<HomeContents> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkAuctionTerms();
  }

  Future<void> _checkAuctionTerms() async {
    final prefs = await SharedPreferences.getInstance();
    final accepted = prefs.getBool('auction_terms_accepted') ?? false;

    if (!accepted) {
      setState(() {
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    return ChangeNotifierProvider(
      create: (context) => HomeController()..init(context),
      child: Consumer<HomeController>(
        builder: (context, controller, child) {
          return Scaffold(
            appBar: AppbarWidget(onSearchChanged: controller.onSearchChanged),
            backgroundColor: Colors.black,
            drawer: DrawerMenu(favoriteProducts: []),
            body: const HomeUI(),
            bottomNavigationBar: BottomNavigationbarWidget(
              currentIndex: controller.currentIndex,
              onTap: (index) {
                controller.changeTab(index);
              },
            ),
          );
        },
      ),
    );
  }
}
