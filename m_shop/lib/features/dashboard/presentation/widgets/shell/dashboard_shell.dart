import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:m_shop/features/dashboard/application/dashboard_store.dart';
import 'package:m_shop/features/dashboard/presentation/dashboard_vm.dart';

class DashboardShell extends StatelessWidget {
  const DashboardShell({
    super.key,
    required this.vm,
    required this.child,
  });

  final DashboardVm vm;
  final Widget child;

  static const items = [
    ShellItem(DashboardTab.overview, 'الهوم', 'لوحة التشغيل الرئيسية', Icons.dashboard_customize_rounded),
    ShellItem(DashboardTab.profile, 'البروفايل', 'بيانات الحساب الإداري', Icons.account_circle_rounded),
    ShellItem(DashboardTab.users, 'المستخدمون', 'إدارة الحسابات والصلاحيات', Icons.group_rounded),
    ShellItem(DashboardTab.attendance, 'الحضور', 'سجلات الدخول والانصراف', Icons.fact_check_rounded),
    ShellItem(DashboardTab.productivity, 'الإنتاجية', 'مقارنة المستهدف بالفعلي', Icons.insights_rounded),
    ShellItem(DashboardTab.results, 'نتائج الشغل', 'مؤشرات الإنجاز النهائية', Icons.verified_rounded),
    ShellItem(DashboardTab.tasks, 'المهام', 'متابعة الإسناد والتنفيذ', Icons.assignment_rounded),
    ShellItem(DashboardTab.inventory, 'الجرد', 'المخزون والعناصر الحرجة', Icons.inventory_2_rounded),
    ShellItem(DashboardTab.finance, 'الأرباح', 'التقارير والأداء المالي', Icons.payments_rounded),
    ShellItem(DashboardTab.settings, 'الإعدادات', 'خيارات النظام والتشغيل', Icons.settings_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1080;
        final sidebar = _DashboardSidebar(vm: vm, compact: !isWide);

        return Scaffold(
          drawer: isWide
              ? null
              : Drawer(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: sidebar,
                    ),
                  ),
                ),
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              const _AmbientBackground(),
              SafeArea(
                child: Row(
                  children: [
                    if (isWide)
                      SizedBox(
                        width: 292,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: sidebar,
                        ),
                      ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(isWide ? 0 : 10, 10, 10, 10),
                        child: Column(
                          children: [
                            _DashboardTopBar(vm: vm, showMenu: !isWide),
                            const SizedBox(height: 10),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0x44111C28),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(color: const Color(0xFF1C3147)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: child,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ShellItem {
  const ShellItem(this.tab, this.title, this.subtitle, this.icon);

  final DashboardTab tab;
  final String title;
  final String subtitle;
  final IconData icon;
}

class _DashboardTopBar extends StatelessWidget {
  const _DashboardTopBar({required this.vm, required this.showMenu});

  final DashboardVm vm;
  final bool showMenu;

  @override
  Widget build(BuildContext context) {
    final current = DashboardShell.items.firstWhere((item) => item.tab == vm.tab);

    return Builder(
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xCC0B1624), Color(0xAA0F2133)],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF1E344B)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 24,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: Row(
            children: [
              if (showMenu)
                IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu_rounded, color: Colors.white),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(current.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                        const SizedBox(width: 8),
                        const _SignalChip(label: 'نظام مباشر', icon: Icons.bolt_rounded),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(current.subtitle, style: const TextStyle(color: Color(0xFF9CB2C8), height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const _PulseStatus(),
              const SizedBox(width: 8),
              _TopMetric(icon: current.icon, title: 'الوحدة', value: current.title),
              const SizedBox(width: 8),
              const _TopMetric(icon: Icons.notifications_active_outlined, title: 'التنبيهات', value: '3 نشطة'),
            ],
          ),
        );
      },
    );
  }
}

class _DashboardSidebar extends StatelessWidget {
  const _DashboardSidebar({required this.vm, required this.compact});

  final DashboardVm vm;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final currentUser = vm.users.first;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF08111B), Color(0xFF0E1A28), Color(0xFF102235)],
        ),
        borderRadius: BorderRadius.circular(compact ? 22 : 24),
        border: Border.all(color: const Color(0xFF1B3147)),
        boxShadow: const [
          BoxShadow(color: Color(0x2A000000), blurRadius: 28, offset: Offset(0, 20)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SidebarHeader(userName: currentUser.name, role: currentUser.role),
            const SizedBox(height: 10),
            const Text('الوحدات الرئيسية', style: TextStyle(color: Color(0xFF87A3BC), fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: DashboardShell.items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = DashboardShell.items[index];
                  final selected = vm.tab == item.tab;
                  return _SidebarItem(
                    item: item,
                    selected: selected,
                    onTap: () {
                      vm.setTab(item.tab);
                      if (compact) {
                        Navigator.of(context).maybePop();
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            const _SidebarInsightCard(),
          ],
        ),
      ),
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  const _SidebarHeader({required this.userName, required this.role});

  final String userName;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.white.withValues(alpha: 0.10),
            const Color(0xFF14B8A6).withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF14B8A6), Color(0xFF2563EB)]),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    userName.isNotEmpty ? userName.substring(0, 1) : '?',
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('منصة تشغيل ذكية', style: TextStyle(color: Color(0xFF9FC1D8), fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(userName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17)),
                    const SizedBox(height: 4),
                    Text(role, style: const TextStyle(color: Color(0xFF78E1D6), fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(child: _HeaderMetric(label: 'الوضع', value: 'مباشر')),
              SizedBox(width: 10),
              Expanded(child: _HeaderMetric(label: 'الأمان', value: 'مستقر')),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderMetric extends StatelessWidget {
  const _HeaderMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF87A3BC), fontWeight: FontWeight.w700, fontSize: 12)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({required this.item, required this.selected, required this.onTap});

  final ShellItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color(0xFF14B8A6), Color(0xFF0F766E), Color(0xFF123A67)],
                )
              : null,
          color: selected ? null : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: selected ? const Color(0xFF74FBE8) : Colors.white.withValues(alpha: 0.05)),
          boxShadow: selected
              ? const [
                  BoxShadow(color: Color(0x3314B8A6), blurRadius: 22, offset: Offset(0, 12)),
                ]
              : null,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              width: 5,
              height: 38,
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: selected ? Colors.white.withValues(alpha: 0.18) : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(item.icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selected ? const Color(0xFFE1FFFA) : const Color(0xFF86A2BA),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_left_rounded, color: selected ? Colors.white : const Color(0xFF627B91)),
          ],
        ),
      ),
    );
  }
}

class _SidebarInsightCard extends StatelessWidget {
  const _SidebarInsightCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF101F31), Color(0xFF13283D)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF21384F)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_graph_rounded, color: Color(0xFF74FBE8), size: 18),
              SizedBox(width: 8),
              Text('إشارة تشغيل', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'اللوحة الآن بتصميم تقني أوضح يسهّل تتبع الوحدات واتخاذ القرار بسرعة.',
            style: TextStyle(color: Color(0xFF9AB5CB), height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _TopMetric extends StatelessWidget {
  const _TopMetric({required this.icon, required this.title, required this.value});

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF74FBE8)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Color(0xFF8EACC4), fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SignalChip extends StatelessWidget {
  const _SignalChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF14B8A6).withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF74FBE8)),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Color(0xFFB7FFF6), fontWeight: FontWeight.w800, fontSize: 12)),
        ],
      ),
    );
  }
}

class _PulseStatus extends StatefulWidget {
  const _PulseStatus();

  @override
  State<_PulseStatus> createState() => _PulseStatusState();
}

class _PulseStatusState extends State<_PulseStatus> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = 0.85 + (_controller.value * 0.35);
        final alpha = (1 - _controller.value).clamp(0.0, 1.0);
        return SizedBox(
          width: 52,
          height: 52,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: scale,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF14B8A6).withValues(alpha: alpha * 0.18),
                  ),
                ),
              ),
              Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF2EF2D0),
                  boxShadow: [BoxShadow(color: Color(0x882EF2D0), blurRadius: 14)],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AmbientBackground extends StatefulWidget {
  const _AmbientBackground();

  @override
  State<_AmbientBackground> createState() => _AmbientBackgroundState();
}

class _AmbientBackgroundState extends State<_AmbientBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 18))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF03070C), Color(0xFF07101A), Color(0xFF09131F)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -140 + (t * 30),
                right: -70 + (math.sin(t * math.pi * 2) * 20),
                child: _GlowOrb(size: 320, color: const Color(0xFF14B8A6).withValues(alpha: 0.20)),
              ),
              Positioned(
                bottom: -120,
                left: -40 + (math.cos(t * math.pi * 2) * 30),
                child: _GlowOrb(size: 300, color: const Color(0xFF2563EB).withValues(alpha: 0.18)),
              ),
              Positioned(
                top: 180 + (math.sin(t * math.pi * 2) * 16),
                left: 260,
                child: _GlowOrb(size: 180, color: const Color(0xFF7C3AED).withValues(alpha: 0.12)),
              ),
              CustomPaint(size: Size.infinite, painter: _TechGridPainter(progress: t)),
            ],
          ),
        );
      },
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0.0)],
        ),
      ),
    );
  }
}

class _TechGridPainter extends CustomPainter {
  const _TechGridPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFF2C4158).withValues(alpha: 0.24)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const spacing = 42.0;
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final scanPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          const Color(0xFF14B8A6).withValues(alpha: 0.0),
          const Color(0xFF14B8A6).withValues(alpha: 0.10),
          const Color(0xFF14B8A6).withValues(alpha: 0.0),
          Colors.transparent,
        ],
        stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
      ).createShader(Rect.fromLTWH(0, size.height * progress - 90, size.width, 180));

    canvas.drawRect(Rect.fromLTWH(0, size.height * progress - 90, size.width, 180), scanPaint);
  }

  @override
  bool shouldRepaint(covariant _TechGridPainter oldDelegate) => oldDelegate.progress != progress;
}

