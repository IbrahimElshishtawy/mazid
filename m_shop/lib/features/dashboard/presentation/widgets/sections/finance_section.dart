part of 'dashboard_sections.dart';

class FinanceSection extends StatelessWidget {
  const FinanceSection({super.key, required this.financialReports});

  final List<FinancialReport> financialReports;

  @override
  Widget build(BuildContext context) {
    final totalIncome = financialReports.fold<double>(0, (sum, report) => sum + report.income);
    final totalExpenses = financialReports.fold<double>(0, (sum, report) => sum + report.expenses);
    final totalProfit = financialReports.fold<double>(0, (sum, report) => sum + report.profit);
    final profitMargin = totalIncome == 0 ? 0.0 : totalProfit / totalIncome;
    final losses = (totalExpenses * 0.11).roundToDouble();
    final marketMomentum = 0.76;
    const activeClients = 28;
    const retainedClients = 21;

    return SectionCard(
      title: 'الأرباح والتقارير المالية',
      subtitle: 'لوحة مالية احترافية لمتابعة الأرباح، قراءة السوق، متابعة العملاء، واختيار طرق التطوير المستقبلية.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _AttendanceStatCard(title: 'إجمالي الإيرادات', value: totalIncome.round().toString(), note: 'كل الدخل المسجل', color: const Color(0xFF0F766E), icon: Icons.account_balance_wallet_rounded),
              _AttendanceStatCard(title: 'صافي الأرباح', value: totalProfit.round().toString(), note: 'الربح الفعلي للفترة', color: const Color(0xFF16A34A), icon: Icons.payments_rounded),
              _AttendanceStatCard(title: 'الخسائر المقدرة', value: losses.round().toString(), note: 'مصاريف أو فاقد يحتاج ضبط', color: const Color(0xFFDC2626), icon: Icons.trending_down_rounded),
              _AttendanceStatCard(title: 'هامش الربح', value: '${(profitMargin * 100).round()}%', note: 'قدرة النشاط على الربح', color: const Color(0xFF2563EB), icon: Icons.insights_rounded),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAF9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('مركز الإدارة المالية والسوق', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text('من هنا تتابع الإدارة الأرباح الكلية، تقرأ حركة السوق، تراقب العملاء النشطين، وتحدد أفضل طرق التطوير والتوسع.', style: TextStyle(color: Color(0xFF667B75), height: 1.6)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: const [
                    _QuickAction(label: 'اعتماد التقرير المالي', icon: Icons.fact_check_rounded),
                    _QuickAction(label: 'متابعة السوق', icon: Icons.show_chart_rounded),
                    _QuickAction(label: 'مراجعة العملاء', icon: Icons.groups_rounded),
                    _QuickAction(label: 'خطة تطوير', icon: Icons.trending_up_rounded),
                    _QuickAction(label: 'تصدير الأرباح', icon: Icons.file_download_outlined),
                    _QuickAction(label: 'تنبيه انخفاض الربحية', icon: Icons.notifications_active_outlined),
                  ],
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _FinanceFeatureCard(title: 'متابعة السوق', description: 'مؤشر السوق الحالي ${(marketMomentum * 100).round()}% ويعطي صورة عن قوة الطلب والفرص التجارية.'),
                    _FinanceFeatureCard(title: 'تحليل العملاء', description: 'يوجد $activeClients عميلًا نشطًا، منهم $retainedClients عميلًا متكررًا، وهذا يساعد في قياس الثبات التجاري.'),
                    _FinanceFeatureCard(title: 'متابعة الأرباح الكلية', description: 'اجمع الربح اليومي والأسبوعي والشهري في شاشة واحدة لمعرفة الاتجاه الحقيقي للنشاط.'),
                    _FinanceFeatureCard(title: 'اختيار طرق التطوير', description: 'يمكنك استخدام البيانات لتحديد هل الأفضل رفع التسويق، خفض المصروفات، أو توسيع الطاقة البيعية.'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 980;

              final profitabilityChart = _FinanceProfitabilityChart(
                totalIncome: totalIncome,
                totalExpenses: totalExpenses,
                totalProfit: totalProfit,
                profitMargin: profitMargin,
              );
              final marketChart = _FinanceMarketChart(
                marketMomentum: marketMomentum,
                activeClients: activeClients,
                retainedClients: retainedClients,
              );

              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: profitabilityChart),
                    const SizedBox(width: 16),
                    Expanded(child: marketChart),
                  ],
                );
              }

              return Column(
                children: [
                  profitabilityChart,
                  const SizedBox(height: 16),
                  marketChart,
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          const SectionCard(
            title: 'كيف تستفيد من فيتشر الأرباح؟',
            subtitle: 'هذه المزايا تخدم الإدارة في المتابعة المالية والتطوير وليس للعرض فقط.',
            child: Column(
              children: [
                OverviewLine(title: 'متابعة كل الأرباح التي تم تحقيقها', description: 'تعرف حجم الربح اليومي والأسبوعي والشهري في نفس المكان وراقب الاتجاه العام.'),
                OverviewLine(title: 'فهم السوق والعملاء', description: 'راقب قوة الطلب واحتفاظ العملاء لمعرفة هل السوق يتحسن أم يحتاج تحرك جديد.'),
                OverviewLine(title: 'كشف الخسائر مبكرًا', description: 'الخسائر أو ارتفاع المصروفات تظهر بسرعة لتقليل أثرها قبل أن تؤثر على الربحية.'),
                OverviewLine(title: 'اختيار طرق التطوير', description: 'استخدم البيانات لتقرر هل الأفضل خفض التكلفة أو زيادة التسويق أو تحسين خدمة العملاء.'),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const SectionCard(
            title: 'خطط تطوير مقترحة للإدارة',
            subtitle: 'مسارات عملية يمكن الاعتماد عليها لرفع الربحية وتحسين استقرار النشاط.',
            child: Column(
              children: [
                _StrategyTile(title: 'رفع الاحتفاظ بالعملاء', description: 'إنشاء عروض دورية وخدمة متابعة للعملاء المتكررين لزيادة المبيعات المستقرة.'),
                _StrategyTile(title: 'تقليل المصروفات غير المؤثرة', description: 'مراجعة المصاريف التشغيلية التي لا تضيف عائدًا مباشرًا على الربحية.'),
                _StrategyTile(title: 'تطوير باقة منتجات أعلى ربحًا', description: 'التركيز على المنتجات أو الخدمات ذات هامش الربح الأكبر.'),
                _StrategyTile(title: 'تحسين قراءة السوق', description: 'متابعة الطلب والاتجاهات لتوقيت العروض والشراء والتوسع بشكل أذكى.'),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionCard(
            title: 'التقارير المالية التفصيلية',
            subtitle: 'كل تقرير يوضح الإيراد والمصروفات والربح مع قراءة تنفيذية مختصرة.',
            child: Column(children: financialReports.map((report) => FinanceTile(report: report)).toList()),
          ),
        ],
      ),
    );
  }
}

class _FinanceFeatureCard extends StatelessWidget {
  const _FinanceFeatureCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2ECE8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF059669).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0x14059669),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.payments_outlined, color: Color(0xFF059669)),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 8),
          Text(description, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
        ],
      ),
    );
  }
}

class _FinanceProfitabilityChart extends StatelessWidget {
  const _FinanceProfitabilityChart({required this.totalIncome, required this.totalExpenses, required this.totalProfit, required this.profitMargin});

  final double totalIncome;
  final double totalExpenses;
  final double totalProfit;
  final double profitMargin;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'جرافيك الربحية',
      subtitle: 'مقارنة بين الدخل والمصروفات والربح الصافي.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FinanceGraphBar(label: 'الإيرادات', value: totalIncome.round().toString(), progress: 1.0, color: const Color(0xFF0F766E)),
          const SizedBox(height: 12),
          _FinanceGraphBar(label: 'المصروفات', value: totalExpenses.round().toString(), progress: totalIncome == 0 ? 0.0 : (totalExpenses / totalIncome).clamp(0.0, 1.0).toDouble(), color: const Color(0xFFDC2626)),
          const SizedBox(height: 12),
          _FinanceGraphBar(label: 'صافي الربح', value: totalProfit.round().toString(), progress: totalIncome == 0 ? 0.0 : (totalProfit / totalIncome).clamp(0.0, 1.0).toDouble(), color: const Color(0xFF16A34A)),
          const SizedBox(height: 14),
          Text('هامش الربح العام ${(profitMargin * 100).round()}%', style: const TextStyle(color: Color(0xFF506662), fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _FinanceMarketChart extends StatelessWidget {
  const _FinanceMarketChart({required this.marketMomentum, required this.activeClients, required this.retainedClients});

  final double marketMomentum;
  final int activeClients;
  final int retainedClients;

  @override
  Widget build(BuildContext context) {
    final retentionRatio = activeClients == 0 ? 0.0 : retainedClients / activeClients;

    return SectionCard(
      title: 'جرافيك السوق والعملاء',
      subtitle: 'قراءة سريعة لحركة السوق واستقرار قاعدة العملاء.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 170,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 145,
                  height: 145,
                  child: CircularProgressIndicator(
                    value: marketMomentum.clamp(0.0, 1.0).toDouble(),
                    strokeWidth: 15,
                    color: const Color(0xFF2563EB),
                    backgroundColor: const Color(0xFFDCE8FF),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${(marketMomentum * 100).round()}%', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    const Text('حركة السوق', style: TextStyle(color: Color(0xFF667B75), fontWeight: FontWeight.w700)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _FinanceGraphBar(label: 'العملاء النشطون', value: '$activeClients', progress: (activeClients / 30).clamp(0.0, 1.0).toDouble(), color: const Color(0xFF0F766E)),
          const SizedBox(height: 12),
          _FinanceGraphBar(label: 'الاحتفاظ بالعملاء', value: '${(retentionRatio * 100).round()}%', progress: retentionRatio.clamp(0.0, 1.0).toDouble(), color: const Color(0xFFF59E0B)),
        ],
      ),
    );
  }
}

class _FinanceGraphBar extends StatelessWidget {
  const _FinanceGraphBar({required this.label, required this.value, required this.progress, required this.color});

  final String label;
  final String value;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800))),
            Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w900)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0).toDouble(),
            minHeight: 10,
            color: color,
            backgroundColor: color.withValues(alpha: 0.12),
          ),
        ),
      ],
    );
  }
}

