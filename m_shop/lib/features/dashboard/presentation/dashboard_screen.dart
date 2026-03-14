import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:m_shop/features/dashboard/application/dashboard_store.dart';
import 'package:m_shop/features/dashboard/presentation/dashboard_vm.dart';
import 'package:m_shop/features/dashboard/presentation/widgets/dashboard_content.dart';
import 'package:m_shop/features/dashboard/presentation/widgets/dashboard_hero.dart';
import 'package:m_shop/features/dashboard/presentation/widgets/dashboard_tabs.dart';
import 'package:m_shop/features/dashboard/presentation/widgets/overview_metrics.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<DashboardState, DashboardVm>(
      converter: DashboardVm.fromStore,
      builder: (context, vm) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFE7F4F1), Color(0xFFF7FAF9)],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DashboardHero(vm: vm),
                      const SizedBox(height: 18),
                      DashboardTabs(vm: vm),
                      const SizedBox(height: 18),
                      OverviewMetrics(vm: vm),
                      const SizedBox(height: 18),
                      DashboardContent(vm: vm),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
