// ignore_for_file: file_names

import 'package:flutter/material.dart';

class AppbarWidget extends StatefulWidget implements PreferredSizeWidget {
  final ValueChanged<String>? onSearchChanged;

  const AppbarWidget({super.key, this.onSearchChanged});

  @override
  State<AppbarWidget> createState() => _AppbarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppbarWidgetState extends State<AppbarWidget> {
  bool _isSearching = false;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      iconTheme: const IconThemeData(color: Colors.white),
      title: _isSearching
          ? TextField(
              controller: _controller,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Search products...",
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              onChanged: widget.onSearchChanged,
            )
          : const Text("Mazid Shop", style: TextStyle(color: Colors.white)),
      actions: [
        IconButton(
          icon: Icon(
            _isSearching ? Icons.close : Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              if (_isSearching) {
                _controller.clear();
                widget.onSearchChanged?.call("");
              }
              _isSearching = !_isSearching;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.shopify_sharp, color: Colors.white),
          onPressed: () {
            // cart action
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
