import 'package:flutter/material.dart';
import 'package:m_shop/features/dashboard/application/dashboard_store.dart';
import 'package:m_shop/features/dashboard/presentation/dashboard_vm.dart';

class DashboardTabs extends StatelessWidget {
  const DashboardTabs({super.key, required this.vm});

  final DashboardVm vm;

  @override
  Widget build(BuildContext context) {
    final tabs = {
      DashboardTab.overview: '????????',
      DashboardTab.users: '??????????',
      DashboardTab.attendance: '??????',
      DashboardTab.productivity: '???????',
      DashboardTab.tasks: '??????',
      DashboardTab.inventory: '???????',
      DashboardTab.finance: '???????',
    };

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: tabs.entries.map((entry) {
        final selected = entry.key == vm.tab;
        return InkWell(
          onTap: () => vm.setTab(entry.key),
          borderRadius: BorderRadius.circular(999),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFF0F766E) : Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: selected ? const Color(0xFF0F766E) : const Color(0xFFE2ECE8)),
            ),
            child: Text(entry.value, style: TextStyle(color: selected ? Colors.white : const Color(0xFF4F6660), fontWeight: FontWeight.w800)),
          ),
        );
      }).toList(),
    );
  }
}
