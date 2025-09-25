// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:m_shop/page/action/home/auction_home_page.dart';

class StatusFilterBar extends StatelessWidget {
  final StatusFilter current;
  final ValueChanged<StatusFilter> onChanged;

  const StatusFilterBar({
    super.key,
    required this.current,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      StatusFilter.all,
      StatusFilter.available,
      StatusFilter.pending,
      StatusFilter.sold,
    ];

    String label(StatusFilter f) {
      switch (f) {
        case StatusFilter.all:
          return 'الكل';
        case StatusFilter.available:
          return 'متاح';
        case StatusFilter.pending:
          return 'قيد الانتظار';
        case StatusFilter.sold:
          return 'مباع';
      }
    }

    return SizedBox(
      height: 46,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          final f = items[i];
          final selected = f == current;
          return ChoiceChip(
            label: Text(label(f)),
            selected: selected,
            onSelected: (_) => onChanged(f),
            labelStyle: TextStyle(
              color: selected ? Colors.black : Colors.white,
              fontWeight: FontWeight.w600,
            ),
            selectedColor: Colors.white,
            backgroundColor: const Color(0xFF1A1A1A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: selected ? Colors.white : Colors.white24),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: items.length,
      ),
    );
  }
}
