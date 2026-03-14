import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/application/dashboard_store.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:redux/redux.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<DashboardState, _DashboardVm>(
      converter: _DashboardVm.fromStore,
      builder: (context, vm) {
        final isWide = MediaQuery.of(context).size.width > 980;
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
                      _DashboardHero(vm: vm),
                      const SizedBox(height: 18),
                      _DashboardTabs(vm: vm),
                      const SizedBox(height: 18),
                      _MetricsGrid(),
                      const SizedBox(height: 18),
                      if (isWide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: _PrimaryColumn(vm: vm)),
                            const SizedBox(width: 16),
                            Expanded(flex: 2, child: _SecondaryColumn(vm: vm)),
                          ],
                        )
                      else ...[
                        _PrimaryColumn(vm: vm),
                        const SizedBox(height: 16),
                        _SecondaryColumn(vm: vm),
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
    required this.tab,
    required this.shift,
    required this.production,
    required this.tasks,
    required this.employees,
    required this.alerts,
    required this.setTab,
    required this.setShift,
  });

  final DashboardTab tab;
  final ShiftType shift;
  final List<ProductionPoint> production;
  final List<TaskModel> tasks;
  final List<EmployeeModel> employees;
  final List<AlertModel> alerts;
  final ValueChanged<DashboardTab> setTab;
  final ValueChanged<ShiftType> setShift;

  static _DashboardVm fromStore(Store<DashboardState> store) {
    final state = store.state;
    return _DashboardVm(
      tab: state.tab,
      shift: state.shift,
      production: state.production,
      tasks: state.tasks,
      employees: state.employees,
      alerts: state.alerts,
      setTab: (tab) => store.dispatch(SetDashboardTabAction(tab)),
      setShift: (shift) => store.dispatch(SetShiftAction(shift)),
    );
  }
}

class _DashboardHero extends StatelessWidget {
  const _DashboardHero({required this.vm});

  final _DashboardVm vm;

  @override
  Widget build(BuildContext context) {
    final shiftLabels = {
      ShiftType.morning: 'صباحية',
      ShiftType.evening: 'مسائية',
      ShiftType.night: 'ليلية',
    };

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF0F766E), Color(0xFF1D4ED8)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x220F766E),
            blurRadius: 28,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.factory_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'لوحة تحكم المصنع الذكية',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'هيكل أوضح ومظهر أنظف لمتابعة الإنتاج والمهام والتنبيهات.',
                      style: TextStyle(color: Color(0xD7FFFFFF), height: 1.5),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'الوردية ${shiftLabels[vm.shift]}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ShiftType.values.map((shift) {
              final selected = shift == vm.shift;
              final label = shiftLabels[shift]!;
              return InkWell(
                onTap: () => vm.setShift(shift),
                borderRadius: BorderRadius.circular(999),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: selected ? const Color(0xFF0F766E) : Colors.white,
                      fontWeight: FontWeight.w800,
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

class _DashboardTabs extends StatelessWidget {
  const _DashboardTabs({required this.vm});

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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: tabs.entries.map((entry) {
          final selected = entry.key == vm.tab;
          return Expanded(
            child: InkWell(
              onTap: () => vm.setTab(entry.key),
              borderRadius: BorderRadius.circular(14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF0F766E)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  entry.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF5F746E),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final compact = width < 860;
    final cards = const [
      _MetricCard(
        title: 'الإنتاج اليومي',
        value: '2480',
        subtitle: 'وحدة مكتملة',
        icon: Icons.precision_manufacturing_rounded,
        color: Color(0xFF0F766E),
      ),
      _MetricCard(
        title: 'المهام المنجزة',
        value: '186',
        subtitle: 'من أصل 214',
        icon: Icons.task_alt_rounded,
        color: Color(0xFF2563EB),
      ),
      _MetricCard(
        title: 'نسبة العيوب',
        value: '1.8%',
        subtitle: 'أقل من الحد المسموح',
        icon: Icons.verified_rounded,
        color: Color(0xFFF59E0B),
      ),
      _MetricCard(
        title: 'الحضور',
        value: '94%',
        subtitle: '128 عامل حاضر',
        icon: Icons.groups_rounded,
        color: Color(0xFF7C3AED),
      ),
    ];

    if (compact) {
      return GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: cards,
      );
    }

    return Row(
      children: cards
          .map(
            (card) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: card,
              ),
            ),
          )
          .toList(),
    );
  }
}

class _PrimaryColumn extends StatelessWidget {
  const _PrimaryColumn({required this.vm});

  final _DashboardVm vm;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionCard(
          title: 'اتجاه الإنتاج الأسبوعي',
          subtitle: 'مقارنة الفعلي بالمستهدف مع توقع بصري للفترة القادمة',
          child: SizedBox(
            height: 260,
            child: _ProductionChart(data: vm.production),
          ),
        ),
        const SizedBox(height: 16),
        if (vm.tab != DashboardTab.operations)
          SectionCard(
            title: 'أداء الفرق',
            subtitle: 'عرض سريع لأعضاء الفريق ومستوى الكفاءة الحالي',
            child: Column(
              children: vm.employees.map((employee) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FAF9),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFFE6F4F1),
                        child: Text(employee.name.characters.first),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              employee.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              employee.role,
                              style: const TextStyle(color: Color(0xFF667B75)),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${employee.efficiency}%',
                        style: const TextStyle(
                          color: Color(0xFF0F766E),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class _SecondaryColumn extends StatelessWidget {
  const _SecondaryColumn({required this.vm});

  final _DashboardVm vm;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionCard(
          title: 'التنبيهات الذكية',
          subtitle: 'تنبيهات لحظية وتوصيات تشغيلية للمشرف',
          child: Column(
            children: vm.alerts.map((alert) {
              final color = Color(alert.colorHex);
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: color.withValues(alpha: 0.18)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.title,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      alert.description,
                      style: const TextStyle(
                        color: Color(0xFF30413D),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        if (vm.tab != DashboardTab.teams)
          SectionCard(
            title: 'المهام الحالية',
            subtitle: 'متابعة نسبة التقدم في أهم مهام التشغيل',
            child: Column(
              children: vm.tasks.map((task) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FAF9),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Text(
                            '${(task.progress * 100).round()}%',
                            style: const TextStyle(
                              color: Color(0xFF0F766E),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        task.description,
                        style: const TextStyle(
                          color: Color(0xFF667B75),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: task.progress,
                          minHeight: 8,
                          color: const Color(0xFF0F766E),
                          backgroundColor: const Color(0xFFD9E6E2),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF5E746E),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Color(0xFF6C817B))),
          ],
        ),
      ),
    );
  }
}

class _ProductionChart extends StatelessWidget {
  const _ProductionChart({required this.data});

  final List<ProductionPoint> data;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _ProductionChartPainter(data));
  }
}

class _ProductionChartPainter extends CustomPainter {
  const _ProductionChartPainter(this.data);

  final List<ProductionPoint> data;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 28.0;
    final width = size.width - left;
    final height = size.height - 28.0;
    const min = 60.0;
    const max = 110.0;

    double scaleY(double value) =>
        height - ((value - min) / (max - min) * height);

    final grid = Paint()
      ..color = const Color(0xFFE2ECE8)
      ..strokeWidth = 1;
    for (var i = 0; i < 5; i++) {
      final y = height * i / 4;
      canvas.drawLine(Offset(left, y), Offset(size.width, y), grid);
    }

    final slot = width / data.length;
    final barWidth = slot * 0.42;
    final barPaint = Paint()..color = const Color(0xFF0F766E);
    final path = Path();

    for (var i = 0; i < data.length; i++) {
      final barX = left + slot * i + (slot - barWidth) / 2;
      final barY = scaleY(data[i].actual);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(barX, barY, barWidth, height - barY),
          const Radius.circular(4),
        ),
        barPaint,
      );

      final targetX = left + slot * i + slot / 2;
      final targetY = scaleY(data[i].target);
      if (i == 0) {
        path.moveTo(targetX, targetY);
      } else {
        path.lineTo(targetX, targetY);
      }

      final textPainter = TextPainter(
        text: TextSpan(
          text: data[i].label,
          style: const TextStyle(color: Color(0xFF677C76), fontSize: 11),
        ),
        textDirection: TextDirection.rtl,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(targetX - textPainter.width / 2, size.height - 18),
      );
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF94A3B8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    for (var i = 0; i < data.length; i++) {
      final x = left + slot * i + slot / 2;
      final y = scaleY(data[i].target);
      canvas.drawCircle(
        Offset(x, y),
        4,
        Paint()..color = const Color(0xFF94A3B8),
      );
      canvas.drawCircle(Offset(x, y), 2, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
