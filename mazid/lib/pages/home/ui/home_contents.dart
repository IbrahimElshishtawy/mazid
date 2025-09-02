import 'package:flutter/material.dart';
import 'package:mazid/pages/home/controller/home_controller.dart';
import 'package:mazid/pages/home/ui/home_ui.dart';
import 'package:mazid/pages/home/widget/AppBar_widget.dart';
import 'package:mazid/pages/home/widget/bottom_NavigationBar.dart';
import 'package:mazid/pages/home/widget/drawer_menu.dart';

class HomeContents extends StatefulWidget {
  const HomeContents({super.key});

  @override
  State<HomeContents> createState() => _HomeContentsState();
}

class _HomeContentsState extends State<HomeContents> {
  final HomeController _controller = HomeController();

  @override
  void initState() {
    super.initState();
    _controller.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(onSearchChanged: _controller.onSearchChanged),
      backgroundColor: Colors.black,
      drawer: DrawerMenu(),
      body: HomeUI(controller: _controller),
      bottomNavigationBar: BottomNavigationbarWidget(
        currentIndex: _controller.currentIndex,
        onTap: (index) {
          if (!mounted) return;
          setState(() => _controller.currentIndex = index);
        },
      ),
    );
  }
}
