// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:mazid/pages/home/ui/home_page.dart';

class BottomNavigationbarWidget extends StatefulWidget {
  const BottomNavigationbarWidget({super.key});

  @override
  State<BottomNavigationbarWidget> createState() =>
      _BottomNavigationbarWidgetState();
}

class _BottomNavigationbarWidgetState extends State<BottomNavigationbarWidget> {
  int _selectedIndex = 2;

  final List<Widget> _pages = [
    const Center(
      child: Text("شراء", style: TextStyle(color: Colors.white, fontSize: 22)),
    ),
    const Center(
      child: Text("مزاد", style: TextStyle(color: Colors.white, fontSize: 22)),
    ),
    const HomePage(), // ✅ بدون Scaffold أو AppBar هنا
    const Center(
      child: Text(
        "استبدال",
        style: TextStyle(color: Colors.white, fontSize: 22),
      ),
    ),
    const Center(
      child: Text(
        "الحساب",
        style: TextStyle(color: Colors.white, fontSize: 22),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: _pages),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60,
        backgroundColor: Colors.black,
        color: Colors.orange,
        buttonBackgroundColor: Colors.deepOrange,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 400),
        items: const <Widget>[
          Icon(Icons.shopping_cart, size: 28, color: Colors.white),
          Icon(Icons.gavel, size: 28, color: Colors.white),
          Icon(Icons.home, size: 28, color: Colors.white),
          Icon(Icons.swap_horiz, size: 28, color: Colors.white),
          Icon(Icons.person, size: 28, color: Colors.white),
        ],
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}
