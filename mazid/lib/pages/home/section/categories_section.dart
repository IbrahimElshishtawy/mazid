// lib/pages/home/widget/categories_section.dart
import 'package:flutter/material.dart';
import 'package:mazid/pages/home/widget/CategoryProductsPage.dart';

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
      {"icon": Icons.pets, "title": "Pets"},
      {"icon": Icons.shopping_bag, "title": "Clothes"},
      {"icon": Icons.laptop, "title": "Laptops"},
      {"icon": Icons.devices_other, "title": "Electronics"},
      {"icon": Icons.watch, "title": "Accessories"},
    ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final cat = categories[index];
          return CategoryWidget(
            cat["icon"] as IconData,
            cat["title"] as String,
            isSelected: selectedCategory == cat["title"],
            onTap: () => onCategorySelected(cat["title"] as String),
          );
        },
      ),
    );
  }
}
