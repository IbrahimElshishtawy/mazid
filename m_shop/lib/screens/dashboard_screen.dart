import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:m_shop/services/dashboard_store.dart';
import 'package:m_shop/widgets/chart_widget.dart';
import 'package:m_shop/widgets/notification_widget.dart';
import 'package:m_shop/widgets/stat_card.dart';
import 'package:redux/redux.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<DashboardState, _DashboardVm>(
      converter: _DashboardVm.fromStore,
      builder: (context, vm) {
        final isWide = MediaQuery.of(context).size.width > 920;
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
                    children: [
                      _Header(vm: vm),
                      const SizedBox(height: 20),
                      _TabBar(vm: vm),
                      const SizedBox(height: 20),
                      _StatsSection(vm: vm, isWide: isWide),
                      const SizedBox(height: 20),
                      if (isWide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: _MainSection(vm: vm)),
                            const SizedBox(width: 16),
                            Expanded(flex: 2, child: _SideSection(vm: vm)),
                          ],
                        )
                      else ...[
                        _MainSection(vm: vm),
                        const SizedBox(height: 16),
                        _SideSection(vm: vm),
                      ],
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

class _DashboardVm {
  const _DashboardVm({
    required this.shift,
    required this.tab,
    required this.production,
    required this.tasks,
    required this.employees,
    required this.onShiftChanged,
    required this.onTabChanged,
  });

  final ShiftType shift;
  final DashboardTab tab;
  final List production;
  final List tasks;
  final List employees;
  final ValueChanged<ShiftType> onShiftChanged;
  final ValueChanged<DashboardTab> onTabChanged;

  static _DashboardVm fromStore(Store<DashboardState> store) {
    final state = store.state;
    return _DashboardVm(
      shift: state.shift,
      tab: state.tab,
      production: state.production,
      tasks: state.tasks,
      employees: state.employees,
      onShiftChanged: (shift) => store.dispatch(SetShiftAction(shift)),
      onTabChanged: (tab) => store.dispatch(SetDashboardTabAction(tab)),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.vm});

  final _DashboardVm vm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(colors: [Color(0xFF0F766E), Color(0xFF1D4ED8)]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.factory_rounded, color: Colors.white, size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Text('لوحة تحكم المصنع الذكية', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ShiftType.values.map((shift) {
              final label = switch (shift) {
                ShiftType.morning => 'صباحية',
                ShiftType.evening => 'مسائية',
                ShiftType.night => 'ليلية',
              };
              final selected = vm.shift == shift;
              return InkWell(
                onTap: () => vm.onShiftChanged(shift),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? Colors.white : Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: selected ? const Color(0xFF0F766E) : Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({required this.vm});

  final _DashboardVm vm;

  @override
  Widget build(BuildContext context) {
    final tabs = {
      DashboardTab.overview: 'نظرة عامة',
      DashboardTab.operations: 'العمليات',
      DashboardTab.teams: 'الفرق',
    };

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: tabs.entries.map((entry) {
          final selected = entry.key == vm.tab;
          return Expanded(
            child: InkWell(
              onTap: () => vm.onTabChanged(entry.key),
              borderRadius: BorderRadius.circular(14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFF0F766E) : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  entry.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: selected ? Colors.white : const Color(0xFF5F746E), fontWeight: FontWeight.w700),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection({required this.vm, required this.isWide});

  final _DashboardVm vm;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final cards = [
      const StatCard(title: 'الإنتاج اليومي', value: '2480', subtitle: 'وحدة مكتملة', icon: Icons.precision_manufacturing_rounded, color: Color(0xFF0F766E)),
      const StatCard(title: 'المهام المنجزة', value: '186', subtitle: 'من أصل 214', icon: Icons.task_alt_rounded, color: Color(0xFF2563EB)),
      const StatCard(title: 'نسبة العيوب', value: '1.8%', subtitle: 'أقل من الحد المسموح', icon: Icons.verified_rounded, color: Color(0xFFF59E0B)),
      Text(''),
      const StatCard(title: 'الحضور', value: '94%', subtitle: '128 عامل حاضر', icon: Icons.groups_rounded, color: Color(0xFF7C3AED)),
    ].whereType<StatCard>().toList();

    if (isWide) {
      return Row(children: cards.map((card) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: card))).toList());
    }

    return GridView.builder(
      itemCount: cards.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.2),
      itemBuilder: (context, index) => cards[index],
    );
  }
}

class _MainSection extends StatelessWidget {
  const _MainSection({required this.vm});

  final _DashboardVm vm;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('اتجاه الإنتاج الأسبوعي', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                const Text('مقارنة الفعلي بالمستهدف عبر المخطط البياني.', style: TextStyle(color: Color(0xFF667B75))),
                const SizedBox(height: 18),
                SizedBox(height: 250, child: ChartWidget(data: vm.production.cast())),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (vm.tab != DashboardTab.operations)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('أداء الفرق والموظفين', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  ...vm.employees.map((employee) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(employee.name),
                        subtitle: Text(employee.role),
                      )),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _SideSection extends StatelessWidget {
  const _SideSection({required this.vm});

  final _DashboardVm vm;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('التنبيهات الذكية', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                const NotificationWidget(
                  title: 'انخفاض سرعة الخط B',
                  description: 'تم رصد تراجع 14% خلال آخر 20 دقيقة ويوصى بالمراجعة.',
                  color: Color(0xFFDC2626),
                ),
                const SizedBox(height: 12),
                const NotificationWidget(
                  title: 'جدولة صيانة وقائية',
                  description: 'الآلة CNC-12 ستصل إلى حد الاهتزاز المتوقع خلال 36 ساعة.',
                  color: Color(0xFFF59E0B),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (vm.tab != DashboardTab.teams)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('المهام الحالية', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  ...vm.tasks.map((task) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(task.title),
                        subtitle: Text(task.description),
                        trailing: Text('${(task.progress * 100).round()}%'),
                      )),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
