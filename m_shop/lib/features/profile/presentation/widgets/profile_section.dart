import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/profile/presentation/widgets/components/company_info_panel.dart';
import 'package:m_shop/features/profile/presentation/widgets/components/profile_charts.dart';
import 'package:m_shop/features/profile/presentation/widgets/components/profile_hero.dart';
import 'package:m_shop/features/profile/presentation/widgets/components/profile_metrics.dart';
import 'package:m_shop/features/profile/presentation/widgets/components/profile_models.dart';
import 'package:m_shop/features/profile/presentation/widgets/components/profile_sheet.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({
    super.key,
    required this.user,
    required this.users,
    required this.production,
    required this.financialReports,
    required this.inventory,
    required this.tasks,
    required this.alerts,
  });

  final UserModel user;
  final List<UserModel> users;
  final List<ProductionPoint> production;
  final List<FinancialReport> financialReports;
  final List<InventoryItem> inventory;
  final List<TaskModel> tasks;
  final List<AlertModel> alerts;

  @override
  Widget build(BuildContext context) {
    final summary = ProfileSummary.fromData(users: users, production: production, financialReports: financialReports, inventory: inventory, tasks: tasks, alerts: alerts);
    final layout = ProfileLayout.fromWidth(MediaQuery.sizeOf(context).width);
    final markets = buildCompanyMarkets();
    final currencies = buildCurrencyPoints();
    final infoItems = buildCompanyInfo(summary);

    return SectionCard(
      title: 'ملف المالك والشركة',
      subtitle: 'لوحة احترافية لصاحب المصنع لمتابعة الشركة والأسواق والعملات والماليات والتنفيذ من مكان واحد.',
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        ProfileHero(user: user, summary: summary, onOpenMarkets: () => _showMarkets(context, markets, currencies), onOpenFinance: () => _showFinance(context, summary)),
        const SizedBox(height: 20),
        Wrap(spacing: 12, runSpacing: 12, children: [
          ProfileMetricCard(width: layout.metricWidth, title: 'السيولة المتاحة', value: formatMoney(summary.availableCash), note: 'الرصيد التشغيلي المتاح لصاحب القرار حالياً.', accent: const Color(0xFF0F766E), icon: Icons.account_balance_wallet_rounded),
          ProfileMetricCard(width: layout.metricWidth, title: 'إجمالي الربح', value: formatMoney(summary.totalProfit), note: 'إجمالي الأرباح المسجلة عبر الفترات المالية الحالية.', accent: const Color(0xFF16A34A), icon: Icons.trending_up_rounded),
          ProfileMetricCard(width: layout.metricWidth, title: 'المصروفات', value: formatMoney(summary.totalExpenses), note: 'إجمالي التكاليف والمصروفات المؤثرة على قرار الإدارة.', accent: const Color(0xFFDC2626), icon: Icons.money_off_csred_rounded),
          ProfileMetricCard(width: layout.metricWidth, title: 'هامش الربح', value: formatPercent(summary.netMargin), note: 'مؤشر سريع يساعد صاحب المصنع في تقييم استقرار الشركة.', accent: const Color(0xFF2563EB), icon: Icons.percent_rounded),
        ]),
        const SizedBox(height: 20),
        ProfileChartsGrid(financialReports: financialReports, production: production, markets: markets, currencies: currencies, summary: summary),
        const SizedBox(height: 20),
        Wrap(spacing: 16, runSpacing: 16, children: [
          SizedBox(width: layout.primaryWidth, child: CompanyInfoPanel(infoItems: infoItems, markets: markets, currencies: currencies)),
          SizedBox(width: layout.secondaryWidth, child: SectionCard(title: 'قراءة المالك', subtitle: 'كيف يقرأ صاحب المصنع هذه الصفحة بسرعة؟', child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            _Line(title: 'الأسواق', text: 'تابع السوق الأعلى حصة والأسرع نمواً قبل توجيه الإنتاج القادم.'),
            _Line(title: 'العملات', text: 'راقب العملات التي تبيع بها حتى لا يتأثر هامش الربح بصمت.'),
            _Line(title: 'الماليات', text: 'لو المصروفات ارتفعت أسرع من الربح، أوقف التوسع مؤقتاً وراجع التكلفة أولاً.'),
            _Line(title: 'المصنع', text: 'اربط التنبيهات والربحية والإنتاج في قرار واحد بدل متابعة كل ملف منفصل.'),
            FilledButton.icon(onPressed: () => _showFinance(context, summary), icon: const Icon(Icons.visibility_outlined), label: const Text('فتح الملخص المالي')),
          ]))),
        ]),
      ]),
    );
  }

  Future<void> _showMarkets(BuildContext context, List<CompanyMarket> markets, List<CurrencyPoint> currencies) {
    return showProfileInfoSheet(
      context: context,
      title: 'الأسواق والعملات',
      subtitle: 'ملف سريع عن الأسواق التي تبيع لها الشركة والعملات المرتبطة بها.',
      children: [
        ...markets.map((market) => ProfileSheetLine(label: market.name, value: '${market.currency} • ${formatPercent(market.share)}')),
        ...currencies.map((currency) => ProfileSheetLine(label: currency.code, value: currency.value.toStringAsFixed(1))),
        const ProfileSheetMessage(message: 'متابعة الأسواق والعملات من نفس صفحة المالك تساعدك تقرر بسرعة أين تدفع الإنتاج وأين تحفظ الهامش الربحي.'),
      ],
    );
  }

  Future<void> _showFinance(BuildContext context, ProfileSummary summary) {
    return showProfileInfoSheet(
      context: context,
      title: 'الملخص المالي',
      subtitle: 'قراءة مالية موجهة لصاحب المصنع مباشرة.',
      children: [
        ProfileSheetLine(label: 'السيولة', value: formatMoney(summary.availableCash)),
        ProfileSheetLine(label: 'إجمالي الربح', value: formatMoney(summary.totalProfit)),
        ProfileSheetLine(label: 'إجمالي المصروفات', value: formatMoney(summary.totalExpenses)),
        ProfileSheetLine(label: 'هامش الربح', value: formatPercent(summary.netMargin)),
        const ProfileSheetMessage(message: 'من هنا تقدر تراقب المعلومات المالية الأساسية من غير ما تخرج لشاشة أخرى، وده مهم جداً لصاحب الشركة وقت القرار السريع.'),
      ],
    );
  }
}

class _Line extends StatelessWidget { const _Line({required this.title, required this.text}); final String title; final String text; @override Widget build(BuildContext context) { return Padding(padding: const EdgeInsets.only(bottom: 12), child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFF7FAF9), borderRadius: BorderRadius.circular(18)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 6), Text(text, style: const TextStyle(color: Color(0xFF667B75), height: 1.5))]))); } }
