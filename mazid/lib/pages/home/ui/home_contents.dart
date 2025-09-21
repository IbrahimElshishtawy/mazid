// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:mazid/pages/Auction/ui/intro_Auction_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mazid/pages/home/controller/home_controller.dart';
import 'package:mazid/pages/home/ui/home_ui.dart';
import 'package:mazid/pages/home/widget/AppBar_widget.dart';
import 'package:mazid/pages/home/widget/bottom_NavigationBar.dart';
import 'package:mazid/pages/home/drawer/ui/drawer_menu.dart';

class HomeContents extends StatefulWidget {
  const HomeContents({super.key});

  @override
  _HomeContentsState createState() => _HomeContentsState();
}

class _HomeContentsState extends State<HomeContents> {
  bool _showTermsPage = false;
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
        _showTermsPage = true;
        _loading = false;
      });
    } else {
      setState(() {
        _showTermsPage = false;
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

    if (_showTermsPage) {
      return const AuctionTermsPage();
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
