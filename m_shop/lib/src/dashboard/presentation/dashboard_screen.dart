import 'dart:math' as math;

import 'package:flutter/material.dart';

// ─── Entry Point ────────────────────────────────────────────────────────────
void main() => runApp(const FactoryApp());

class FactoryApp extends StatelessWidget {
  const FactoryApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'لوحة تحكم المصنع',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const DashboardScreen(),
    );
  }

  ThemeData _buildTheme() => ThemeData(
    useMaterial3: true,
    fontFamily: 'Cairo',
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F766E),
      brightness: Brightness.light,
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE5EAE8), width: 1),
      ),
      color: Colors.white,
      margin: EdgeInsets.zero,
    ),
  );
}

// ─── Dashboard Screen ────────────────────────────────────────────────────────
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int _selectedShift = 1;
  int _selectedTab = 0;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  // ── Per-shift data ────────────────────────────────────────────────────────
  static const _shiftData = [
    _ShiftSnapshot(
      production: '2,100',
      tasks: '162',
      taskTotal: '201',
      defect: '2.3%',
      attendance: '91%',
      workers: '124',
      attendancePct: 0.91,
    ),
    _ShiftSnapshot(
      production: '2,480',
      tasks: '186',
      taskTotal: '214',
      defect: '1.8%',
      attendance: '94%',
      workers: '128',
      attendancePct: 0.94,
    ),
    _ShiftSnapshot(
      production: '1,890',
      tasks: '138',
      taskTotal: '175',
      defect: '2.1%',
      attendance: '88%',
      workers: '119',
      attendancePct: 0.88,
    ),
  ];

  _ShiftSnapshot get _snap => _shiftData[_selectedShift];

  final List<_MachineStatus> machines = const [
    _MachineStatus(
      name: 'CNC-12',
      status: 'جاهزة للعمل',
      progress: 0.86,
      statusColor: Color(0xFF16A34A),
    ),
    _MachineStatus(
      name: 'Line-A3',
      status: 'تحت المراجعة',
      progress: 0.48,
      statusColor: Color(0xFFF59E0B),
    ),
    _MachineStatus(
      name: 'Press-07',
      status: 'قيد الصيانة',
      progress: 0.22,
      statusColor: Color(0xFFDC2626),
    ),
    _MachineStatus(
      name: 'Pack-19',
      status: 'إنتاج نشط',
      progress: 0.91,
      statusColor: Color(0xFF2563EB),
    ),
  ];

  final List<_AlertItem> alerts = const [
    _AlertItem(
      title: 'انخفاض سرعة الخط B',
      description:
          'تراجع 14% خلال آخر 20 دقيقة — يُوصى بمراجعة وحدة التغذية فوراً.',
      severity: 'عاجل',
      icon: Icons.warning_amber_rounded,
      color: Color(0xFFDC2626),
      bg: Color(0xFFFEF2F2),
      border: Color(0xFFFECACA),
    ),
    _AlertItem(
      title: 'جدولة صيانة وقائية',
      description: 'CNC-12 ستصل لحد الاهتزاز المتوقع خلال 36 ساعة.',
      severity: 'متوسط',
      icon: Icons.build_circle_rounded,
      color: Color(0xFFF59E0B),
      bg: Color(0xFFFFFBEB),
      border: Color(0xFFFDE68A),
    ),
    _AlertItem(
      title: 'فريق التغليف تجاوز الهدف',
      description: 'الفريق المسائي حقق 108% من المستهدف — يُنصح برفع الحصة.',
      severity: 'إيجابي',
      icon: Icons.emoji_events_rounded,
      color: Color(0xFF16A34A),
      bg: Color(0xFFF0FDF4),
      border: Color(0xFFBBF7D0),
    ),
  ];

  final List<_TeamPerformance> teams = const [
    _TeamPerformance(
      name: 'الوردية الصباحية',
      score: 92,
      tasks: 74,
      color: Color(0xFF0F766E),
    ),
    _TeamPerformance(
      name: 'الوردية المسائية',
      score: 87,
      tasks: 63,
      color: Color(0xFF2563EB),
    ),
    _TeamPerformance(
      name: 'فريق التغليف',
      score: 95,
      tasks: 49,
      color: Color(0xFF7C3AED),
    ),
    _TeamPerformance(
      name: 'فريق الصيانة',
      score: 81,
      tasks: 28,
      color: Color(0xFFF59E0B),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _switchShift(int v) {
    _fadeCtrl.reset();
    setState(() => _selectedShift = v);
    _fadeCtrl.forward();
  }

  // ── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 880;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F6F5),
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 16),
                        _buildMetricsRow(isWide),
                        const SizedBox(height: 16),
                        _buildTabBar(),
                        const SizedBox(height: 16),
                        if (isWide) _buildWideBody() else _buildNarrowBody(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Header ───────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF0F766E), Color(0xFF1E40AF)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x340F766E),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -50,
              left: -30,
              child: _circle(180, Colors.white.withValues(alpha: 0.04)),
            ),
            Positioned(
              bottom: -60,
              right: -20,
              child: _circle(220, Colors.white.withValues(alpha: 0.04)),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.factory_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'لوحة تحكم المصنع الذكية',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'تحديث فوري — كل 30 ثانية',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.65),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _LiveBadge(),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // KPI strip
                  _buildKpiStrip(),
                  const SizedBox(height: 22),
                  // Shift selector
                  _buildShiftSelector(),
                  const SizedBox(height: 20),
                  // Feature badges
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      _HeaderBadge(
                        icon: Icons.bolt_rounded,
                        label: 'تحليلات فورية',
                      ),
                      _HeaderBadge(
                        icon: Icons.psychology_rounded,
                        label: 'توصيات ذكية',
                      ),
                      _HeaderBadge(
                        icon: Icons.handyman_rounded,
                        label: 'صيانة تنبؤية',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiStrip() {
    final items = [
      ('${_snap.production}', 'وحدة منتجة'),
      (_snap.attendance, 'معدل الحضور'),
      (_snap.defect, 'نسبة العيوب'),
      ('86%', 'كفاءة الخطوط'),
    ];
    return Row(
      children: items.asMap().entries.map((e) {
        final divider = e.key < items.length - 1;
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      e.value.$1,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      e.value.$2,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              if (divider)
                Container(
                  width: 1,
                  height: 36,
                  color: Colors.white.withValues(alpha: 0.18),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildShiftSelector() {
    const shifts = ['صباحية', 'مسائية', 'ليلية'];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: shifts.asMap().entries.map((e) {
          final selected = e.key == _selectedShift;
          return Expanded(
            child: GestureDetector(
              onTap: () => _switchShift(e.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Text(
                  e.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected
                        ? const Color(0xFF0F766E)
                        : Colors.white.withValues(alpha: 0.75),
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Metrics Row ──────────────────────────────────────────────────────────
  Widget _buildMetricsRow(bool isWide) {
    final cards = [
      _MetricCardData(
        title: 'الإنتاج اليومي',
        value: _snap.production,
        sub: 'وحدة مكتملة',
        trend: '+12%',
        trendUp: true,
        icon: Icons.precision_manufacturing_rounded,
        color: const Color(0xFF0F766E),
        bgColor: const Color(0xFFE6F4F1),
      ),
      _MetricCardData(
        title: 'المهام المنجزة',
        value: _snap.tasks,
        sub: 'من أصل ${_snap.taskTotal}',
        trend: '+8%',
        trendUp: true,
        icon: Icons.task_alt_rounded,
        color: const Color(0xFF2563EB),
        bgColor: const Color(0xFFEFF6FF),
      ),
      _MetricCardData(
        title: 'نسبة العيوب',
        value: _snap.defect,
        sub: 'أقل من الهدف',
        trend: '-0.6%',
        trendUp: false,
        trendGood: true,
        icon: Icons.verified_rounded,
        color: const Color(0xFFF59E0B),
        bgColor: const Color(0xFFFFFBEB),
      ),
      _MetricCardData(
        title: 'الحضور',
        value: _snap.attendance,
        sub: '${_snap.workers} عامل',
        trend: '+3%',
        trendUp: true,
        icon: Icons.groups_rounded,
        color: const Color(0xFF7C3AED),
        bgColor: const Color(0xFFF5F3FF),
      ),
    ];
    if (isWide) {
      return Row(
        children: cards
            .map(
              (c) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: _MetricCard(data: c),
                ),
              ),
            )
            .toList(),
      );
    }
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.45,
      children: cards.map((c) => _MetricCard(data: c)).toList(),
    );
  }

  // ── Tab Bar ──────────────────────────────────────────────────────────────
  Widget _buildTabBar() {
    const tabs = [
      (Icons.bar_chart_rounded, 'الإنتاج'),
      (Icons.precision_manufacturing_rounded, 'الآلات'),
      (Icons.groups_rounded, 'الفرق'),
      (Icons.notifications_active_rounded, 'التنبيهات'),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.asMap().entries.map((e) {
          final selected = e.key == _selectedTab;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = e.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF0F766E) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF0F766E)
                      : const Color(0xFFE5EAE8),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    e.value.$1,
                    size: 16,
                    color: selected ? Colors.white : const Color(0xFF6B7F79),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    e.value.$2,
                    style: TextStyle(
                      color: selected ? Colors.white : const Color(0xFF4B635D),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Body layouts ─────────────────────────────────────────────────────────
  Widget _buildWideBody() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _buildLeftPanel()),
        const SizedBox(width: 14),
        Expanded(flex: 2, child: _buildRightPanel()),
      ],
    );
  }

  Widget _buildNarrowBody() {
    switch (_selectedTab) {
      case 0:
        return _buildLeftPanel();
      case 1:
        return _buildMachinesPanel();
      case 2:
        return _buildTeamsPanel();
      case 3:
        return _buildAlertsPanel();
      default:
        return _buildLeftPanel();
    }
  }

  Widget _buildLeftPanel() => Column(
    children: [
      _buildProductionCard(),
      const SizedBox(height: 14),
      _buildTeamsPanel(),
    ],
  );

  Widget _buildRightPanel() => Column(
    children: [
      _buildMachinesPanel(),
      const SizedBox(height: 14),
      _buildAlertsPanel(),
      const SizedBox(height: 14),
      _buildEnvPanel(),
    ],
  );

  // ── Production Chart ─────────────────────────────────────────────────────
  Widget _buildProductionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(
              title: 'اتجاه الإنتاج الأسبوعي',
              subtitle: 'مقارنة الفعلي بالمستهدف مع قراءة تنبؤية',
              action: _ChipAction(label: 'أسبوعي'),
            ),
            const SizedBox(height: 10),
            // Legend
            Wrap(
              spacing: 16,
              children: [
                _LegendDot(color: const Color(0xFF0F766E), label: 'الفعلي'),
                _LegendDot(color: const Color(0xFF94A3B8), label: 'المستهدف'),
                _LegendDot(
                  color: const Color(0xFF93C5FD),
                  label: 'متوقع',
                  dashed: true,
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 200,
              child: _BarLineChart(
                actuals: const [72, 84, 78, 91, 88, 96],
                targets: const [76, 79, 82, 84, 86, 90, 95],
                forecast: 104,
                labels: const ['أحد', 'اثن', 'ثلا', 'أرب', 'خمي', 'جمع', 'سبت'],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF86EFAC)),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.trending_up_rounded,
                    color: Color(0xFF15803D),
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'التوقع: زيادة 10% في الإنتاج الأسبوع القادم إذا استمر معدل الجودة الحالي.',
                      style: TextStyle(
                        color: Color(0xFF14532D),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Teams ────────────────────────────────────────────────────────────────
  Widget _buildTeamsPanel() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle(
              title: 'مقارنة أداء الفرق',
              subtitle: 'الفرق الأعلى إنجازًا حسب الكفاءة والمهام',
            ),
            const SizedBox(height: 14),
            ...teams.map(
              (t) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _TeamTile(team: t),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Machines ─────────────────────────────────────────────────────────────
  Widget _buildMachinesPanel() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle(
              title: 'حالة الآلات',
              subtitle: 'عرض مباشر للأصول الحيوية',
            ),
            const SizedBox(height: 14),
            // Donut summary
            _MachineDonutSummary(machines: machines),
            const SizedBox(height: 14),
            ...machines.map(
              (m) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _MachineTile(machine: m),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Alerts ───────────────────────────────────────────────────────────────
  Widget _buildAlertsPanel() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle(
              title: 'التنبيهات الذكية',
              subtitle: 'أحداث لحظية وتوصيات تشغيلية',
            ),
            const SizedBox(height: 14),
            ...alerts.map(
              (a) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _AlertTile(alert: a),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Environment ──────────────────────────────────────────────────────────
  Widget _buildEnvPanel() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle(
              title: 'البيئة والسلامة',
              subtitle: 'قياسات لحظية من الحساسات',
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _EnvGauge(
                  label: 'الحرارة',
                  value: '24°',
                  unit: 'C',
                  pct: 0.48,
                  color: const Color(0xFFF59E0B),
                ),
                const SizedBox(width: 10),
                _EnvGauge(
                  label: 'الرطوبة',
                  value: '46',
                  unit: '%',
                  pct: 0.46,
                  color: const Color(0xFF2563EB),
                ),
                const SizedBox(width: 10),
                _EnvGauge(
                  label: 'جودة الهواء',
                  value: '92',
                  unit: 'AQI',
                  pct: 0.92,
                  color: const Color(0xFF16A34A),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────
  static Widget _circle(double size, Color color) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}

// ─── Live Badge ──────────────────────────────────────────────────────────────
class _LiveBadge extends StatefulWidget {
  @override
  State<_LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<_LiveBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: _c,
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: Color(0xFF4ADE80),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'مباشر',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Header Badge ─────────────────────────────────────────────────────────────
class _HeaderBadge extends StatelessWidget {
  const _HeaderBadge({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 15),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Title ────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
    this.action,
  });
  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF647873),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}

class _ChipAction extends StatelessWidget {
  const _ChipAction({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F4F1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF0F766E),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─── Metric Card ──────────────────────────────────────────────────────────────
class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.data});
  final _MetricCardData data;

  @override
  Widget build(BuildContext context) {
    final trendColor = data.trendGood
        ? const Color(0xFF16A34A)
        : (data.trendUp ? const Color(0xFF16A34A) : const Color(0xFFDC2626));
    final trendBg = data.trendGood || data.trendUp
        ? const Color(0xFFDCFCE7)
        : const Color(0xFFFEE2E2);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: data.bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(data.icon, color: data.color, size: 20),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: trendBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        data.trendUp
                            ? Icons.arrow_upward_rounded
                            : Icons.arrow_downward_rounded,
                        size: 11,
                        color: trendColor,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        data.trend,
                        style: TextStyle(
                          color: trendColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              data.value,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              data.title,
              style: const TextStyle(
                color: Color(0xFF4B635D),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              data.sub,
              style: const TextStyle(color: Color(0xFF6B7F79), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Team Tile ────────────────────────────────────────────────────────────────
class _TeamTile extends StatelessWidget {
  const _TeamTile({required this.team});
  final _TeamPerformance team;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: team.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    team.name.substring(0, 1),
                    style: TextStyle(
                      color: team.color,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  team.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                '${team.tasks} مهمة',
                style: const TextStyle(color: Color(0xFF5E746E), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: team.score / 100,
              minHeight: 8,
              backgroundColor: const Color(0xFFDDE8E4),
              color: team.color,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${team.score}% كفاءة',
                style: TextStyle(
                  color: team.color,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              if (team.score >= 93)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '⭐ الأفضل',
                    style: TextStyle(
                      color: Color(0xFF166534),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Machine Donut Summary ────────────────────────────────────────────────────
class _MachineDonutSummary extends StatelessWidget {
  const _MachineDonutSummary({required this.machines});
  final List<_MachineStatus> machines;

  @override
  Widget build(BuildContext context) {
    final active = machines.where((m) => m.progress > 0.7).length;
    final review = machines
        .where((m) => m.progress >= 0.3 && m.progress <= 0.7)
        .length;
    final maint = machines.where((m) => m.progress < 0.3).length;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: CustomPaint(
              painter: _DonutPainter(
                values: [
                  active.toDouble(),
                  review.toDouble(),
                  maint.toDouble(),
                ],
                colors: const [
                  Color(0xFF16A34A),
                  Color(0xFFF59E0B),
                  Color(0xFFDC2626),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DonutLegendItem(
                color: const Color(0xFF16A34A),
                label: 'نشطة',
                count: active,
              ),
              const SizedBox(height: 6),
              _DonutLegendItem(
                color: const Color(0xFFF59E0B),
                label: 'مراجعة',
                count: review,
              ),
              const SizedBox(height: 6),
              _DonutLegendItem(
                color: const Color(0xFFDC2626),
                label: 'صيانة',
                count: maint,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutLegendItem extends StatelessWidget {
  const _DonutLegendItem({
    required this.color,
    required this.label,
    required this.count,
  });
  final Color color;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          '$label ($count)',
          style: const TextStyle(fontSize: 12, color: Color(0xFF4B635D)),
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter({required this.values, required this.colors});
  final List<double> values;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold(0.0, (a, b) => a + b);
    if (total == 0) return;
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );
    double startAngle = -math.pi / 2;
    for (var i = 0; i < values.length; i++) {
      final sweep = (values[i] / total) * 2 * math.pi;
      canvas.drawArc(
        rect,
        startAngle,
        sweep - 0.05,
        false,
        Paint()
          ..color = colors[i]
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12
          ..strokeCap = StrokeCap.round,
      );
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

// ─── Machine Tile ─────────────────────────────────────────────────────────────
class _MachineTile extends StatelessWidget {
  const _MachineTile({required this.machine});
  final _MachineStatus machine;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: machine.statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      machine.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      machine.status,
                      style: TextStyle(
                        color: machine.statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: machine.progress,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFDDE8E4),
                    color: machine.statusColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${(machine.progress * 100).round()}%',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4B635D),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Alert Tile ───────────────────────────────────────────────────────────────
class _AlertTile extends StatelessWidget {
  const _AlertTile({required this.alert});
  final _AlertItem alert;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: alert.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: alert.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(alert.icon, color: alert.color, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  alert.title,
                  style: TextStyle(
                    color: alert.color,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: alert.color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  alert.severity,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            alert.description,
            style: const TextStyle(
              color: Color(0xFF32433F),
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Env Gauge ────────────────────────────────────────────────────────────────
class _EnvGauge extends StatelessWidget {
  const _EnvGauge({
    required this.label,
    required this.value,
    required this.unit,
    required this.pct,
    required this.color,
  });
  final String label;
  final String value;
  final String unit;
  final double pct;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAF9),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: CustomPaint(
                painter: _ArcPainter(pct: pct, color: color),
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A2E28),
                    ),
                  ),
                  TextSpan(
                    text: unit,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B7F79),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Color(0xFF6B7F79), fontSize: 11),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'طبيعي',
                style: TextStyle(
                  color: Color(0xFF166534),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  const _ArcPainter({required this.pct, required this.color});
  final double pct;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;
    final bg = Paint()
      ..color = const Color(0xFFDDE8E4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7;
    final fg = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bg);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      pct * 2 * math.pi,
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

// ─── Bar+Line Chart ───────────────────────────────────────────────────────────
class _LegendDot extends StatelessWidget {
  const _LegendDot({
    required this.color,
    required this.label,
    this.dashed = false,
  });
  final Color color;
  final String label;
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: dashed ? color.withValues(alpha: 0.5) : color,
            borderRadius: BorderRadius.circular(3),
            border: dashed ? Border.all(color: color, width: 1.5) : null,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF6B7F79), fontSize: 12),
        ),
      ],
    );
  }
}

class _BarLineChart extends StatelessWidget {
  const _BarLineChart({
    required this.actuals,
    required this.targets,
    required this.forecast,
    required this.labels,
  });
  final List<double> actuals;
  final List<double> targets;
  final double forecast;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BarLineChartPainter(
        actuals: actuals,
        targets: targets,
        forecast: forecast,
        labels: labels,
      ),
    );
  }
}

class _BarLineChartPainter extends CustomPainter {
  _BarLineChartPainter({
    required this.actuals,
    required this.targets,
    required this.forecast,
    required this.labels,
  });
  final List<double> actuals;
  final List<double> targets;
  final double forecast;
  final List<String> labels;

  @override
  void paint(Canvas canvas, Size size) {
    const lp = 30.0;
    const bp = 28.0;
    final cw = size.width - lp;
    final ch = size.height - bp;
    const maxVal = 115.0;
    const minVal = 55.0;

    // Grid
    final gridP = Paint()
      ..color = const Color(0xFFE8F0EC)
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final y = ch * i / 4;
      canvas.drawLine(Offset(lp, y), Offset(size.width, y), gridP);
      final lbl = TextPainter(
        text: TextSpan(
          text: '${(maxVal - (maxVal - minVal) * i / 4).round()}',
          style: const TextStyle(color: Color(0xFF9DB4AE), fontSize: 9),
        ),
        textDirection: TextDirection.rtl,
      )..layout();
      lbl.paint(canvas, Offset(0, y - 6));
    }

    final totalBars = labels.length;
    final barW = (cw / totalBars) * 0.45;

    double _y(double v) => ch - ((v - minVal) / (maxVal - minVal)) * ch;

    // Bars (actuals)
    final barP = Paint()..color = const Color(0xFF0F766E);
    for (var i = 0; i < actuals.length; i++) {
      final x = lp + (cw / totalBars) * i + (cw / totalBars) * 0.275;
      final y = _y(actuals[i]);
      final rr = RRect.fromRectAndRadius(
        Rect.fromLTWH(x - barW / 2, y, barW, ch - y),
        const Radius.circular(4),
      );
      canvas.drawRRect(rr, barP);
    }

    // Forecast bar
    {
      final i = totalBars - 1;
      final x = lp + (cw / totalBars) * i + (cw / totalBars) * 0.275;
      final y = _y(forecast);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x - barW / 2, y, barW, ch - y),
          const Radius.circular(4),
        ),
        Paint()..color = const Color(0xFF93C5FD),
      );
    }

    // Target line
    final targetPath = Path();
    for (var i = 0; i < targets.length; i++) {
      final x = lp + (cw / totalBars) * i + cw / totalBars / 2;
      final y = _y(targets[i]);
      i == 0 ? targetPath.moveTo(x, y) : targetPath.lineTo(x, y);
    }
    canvas.drawPath(
      targetPath,
      Paint()
        ..color = const Color(0xFF94A3B8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );

    // Dots on target
    for (var i = 0; i < targets.length; i++) {
      final x = lp + (cw / totalBars) * i + cw / totalBars / 2;
      final y = _y(targets[i]);
      canvas.drawCircle(
        Offset(x, y),
        3.5,
        Paint()..color = const Color(0xFF94A3B8),
      );
      canvas.drawCircle(Offset(x, y), 2, Paint()..color = Colors.white);
    }

    // X labels
    for (var i = 0; i < labels.length; i++) {
      final x = lp + (cw / totalBars) * i + cw / totalBars / 2;
      final tp = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(
            color: i == labels.length - 1
                ? const Color(0xFF2563EB)
                : const Color(0xFF6B7F79),
            fontSize: 11,
            fontWeight: i == labels.length - 1
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.rtl,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, size.height - 18));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

// ─── Data Models ──────────────────────────────────────────────────────────────
class _ShiftSnapshot {
  const _ShiftSnapshot({
    required this.production,
    required this.tasks,
    required this.taskTotal,
    required this.defect,
    required this.attendance,
    required this.workers,
    required this.attendancePct,
  });
  final String production;
  final String tasks;
  final String taskTotal;
  final String defect;
  final String attendance;
  final String workers;
  final double attendancePct;
}

class _MetricCardData {
  const _MetricCardData({
    required this.title,
    required this.value,
    required this.sub,
    required this.trend,
    required this.trendUp,
    required this.icon,
    required this.color,
    required this.bgColor,
    this.trendGood = false,
  });
  final String title;
  final String value;
  final String sub;
  final String trend;
  final bool trendUp;
  final bool trendGood;
  final IconData icon;
  final Color color;
  final Color bgColor;
}

class _MachineStatus {
  const _MachineStatus({
    required this.name,
    required this.status,
    required this.progress,
    required this.statusColor,
  });
  final String name;
  final String status;
  final double progress;
  final Color statusColor;
}

class _AlertItem {
  const _AlertItem({
    required this.title,
    required this.description,
    required this.severity,
    required this.icon,
    required this.color,
    required this.bg,
    required this.border,
  });
  final String title;
  final String description;
  final String severity;
  final IconData icon;
  final Color color;
  final Color bg;
  final Color border;
}

class _TeamPerformance {
  const _TeamPerformance({
    required this.name,
    required this.score,
    required this.tasks,
    required this.color,
  });
  final String name;
  final int score;
  final int tasks;
  final Color color;
}
