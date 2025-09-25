// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNavigationbarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigationbarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: currentIndex,
      height: 60,
      backgroundColor: Colors.black,
      color: Colors.orange,
      buttonBackgroundColor: Colors.deepOrange,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 400),
      items: const <Widget>[
        Icon(Icons.notifications, size: 28, color: Colors.white), // 0
        Icon(Icons.gavel, size: 28, color: Colors.white), // 1
        Icon(Icons.home, size: 28, color: Colors.white), // 2
        Icon(Icons.swap_horiz, size: 28, color: Colors.white), // 3
        Icon(Icons.person, size: 28, color: Colors.white), // 4
      ],
      onTap: onTap,
    );
  }
}
