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
          drawer: isWide ? null : Drawer(child: SafeArea(child: sidebar)),
          backgroundColor: const Color(0xFFF4F8F7),
          body: SafeArea(
            child: Row(
              children: [
                if (isWide)
                  SizedBox(
                    width: 310,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: sidebar,
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(isWide ? 8 : 16, 16, 16, 16),
                    child: Column(
                      children: [
                        _DashboardTopBar(vm: vm, showMenu: !isWide),
                        const SizedBox(height: 16),
                        Expanded(child: child),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE1ECE9)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D0F172A),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              if (showMenu)
                IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu_rounded),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(current.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 2),
                    Text(current.subtitle, style: const TextStyle(color: Color(0xFF6B807B))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7F3),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(current.icon, size: 18, color: const Color(0xFF0F766E)),
                    const SizedBox(width: 8),
                    Text(current.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F8F7),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.notifications_active_outlined, size: 18, color: Color(0xFF0F766E)),
                    SizedBox(width: 8),
                    Text('3 تنبيهات', style: TextStyle(fontWeight: FontWeight.w800)),
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

class _DashboardSidebar extends StatelessWidget {
  const _DashboardSidebar({required this.vm, required this.compact});

  final DashboardVm vm;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final currentUser = vm.users.first;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(compact ? 0 : 28),
        boxShadow: compact
            ? null
            : const [
                BoxShadow(
                  color: Color(0x1A0F172A),
                  blurRadius: 24,
                  offset: Offset(0, 16),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.white.withValues(alpha: 0.08),
                    Colors.white.withValues(alpha: 0.03),
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0x1AFFFFFF),
                    child: Text(
                      currentUser.name.isNotEmpty ? currentUser.name.substring(0, 1) : '?',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(currentUser.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 4),
                        Text(currentUser.role, style: const TextStyle(color: Color(0xFF9FB2AE))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text('الوحدات الرئيسية', style: TextStyle(color: Color(0xFF8FA5A0), fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: DashboardShell.items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = DashboardShell.items[index];
                  final selected = vm.tab == item.tab;
                  return InkWell(
                    onTap: () {
                      vm.setTab(item.tab);
                      if (compact) {
                        Navigator.of(context).maybePop();
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        gradient: selected
                            ? const LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [Color(0xFF0F766E), Color(0xFF134E4A)],
                              )
                            : null,
                        color: selected ? null : Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: selected ? const Color(0xFF6EE7B7) : Colors.transparent),
                        boxShadow: selected
                            ? const [
                                BoxShadow(
                                  color: Color(0x220F766E),
                                  blurRadius: 18,
                                  offset: Offset(0, 10),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            width: 4,
                            height: 34,
                            decoration: BoxDecoration(
                              color: selected ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          const SizedBox(width: 12),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: selected ? Colors.white.withValues(alpha: 0.16) : Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(item.icon, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                                const SizedBox(height: 2),
                                Text(
                                  item.subtitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: selected ? const Color(0xFFD1FAE5) : const Color(0xFF8FA5A0),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_left_rounded,
                            color: selected ? Colors.white : const Color(0xFF6B807B),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('حالة اليوم', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                  SizedBox(height: 8),
                  Text('استقرار جيد في التشغيل مع 3 تنبيهات فقط تحتاج مراجعة.', style: TextStyle(color: Color(0xFF9FB2AE), height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
