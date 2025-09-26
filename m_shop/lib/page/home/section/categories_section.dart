// lib/pages/home/widget/categories_section.dart
// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';

class CategoriesSection extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoriesSection({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      {"icon": Icons.all_inclusive, "title": "All"},
      {"icon": Icons.brush, "title": "Cosmetic"},
      {"icon": Icons.shopping_bag, "title": "Clothes"},
      {"icon": Icons.laptop, "title": "Laptops"},
      {"icon": Icons.devices_other, "title": "Electronics"},
      {"icon": Icons.spa, "title": "Perfume"},
    ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final title = cat["title"] as String;

          return GestureDetector(
            onTap: () => onCategorySelected(title),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: selectedCategory == title
                      ? Colors.orange
                      : Colors.grey[800],
                  child: Icon(
                    cat["icon"] as IconData,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: TextStyle(
                    color: selectedCategory == title
                        ? Colors.orange
                        : Colors.white,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
