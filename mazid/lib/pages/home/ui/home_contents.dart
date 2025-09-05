import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mazid/pages/home/controller/home_controller.dart';
import 'package:mazid/pages/home/ui/home_ui.dart';
import 'package:mazid/pages/home/widget/AppBar_widget.dart';
import 'package:mazid/pages/home/widget/bottom_NavigationBar.dart';
import 'package:mazid/pages/home/drawer/ui/drawer_menu.dart';

class HomeContents extends StatelessWidget {
  const HomeContents({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeController()..init(context),
      child: Consumer<HomeController>(
        builder: (context, controller, child) {
          return Scaffold(
            appBar: AppbarWidget(onSearchChanged: controller.onSearchChanged),
            backgroundColor: Colors.black,
            drawer: DrawerMenu(favoriteProducts: []),
            body: HomeUI(controller: controller),
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
