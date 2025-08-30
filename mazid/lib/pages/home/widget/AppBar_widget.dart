// ignore_for_file: file_names

import 'package:flutter/material.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      title: Center(
        child: Text("Mazid Store", style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.black,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: const [
        Icon(Icons.shopping_cart, color: Colors.white),
        SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
