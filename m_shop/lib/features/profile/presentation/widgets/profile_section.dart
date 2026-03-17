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
    final summary = ProfileSummary.fromData(
      users: users,
      production: production,
      financialReports: financialReports,
      inventory: inventory,
      tasks: tasks,
      alerts: alerts,
    );
    final layout = ProfileLayout.fromWidth(MediaQuery.sizeOf(context).width);
    final markets = buildCompanyMarkets();
    final currencies = buildCurrencyPoints();
    final infoItems = buildCompanyInfo(summary);

    return SectionCard(
      title: '\u0645\u0644\u0641 \u0627\u0644\u0645\u0627\u0644\u0643 \u0648\u0627\u0644\u0634\u0631\u0643\u0629',
      subtitle: '\u0644\u0648\u062D\u0629 \u0627\u062D\u062A\u0631\u0627\u0641\u064A\u0629 \u0644\u062A\u062A\u0628\u0639 \u0627\u0644\u0634\u0631\u0643\u0629 \u0648\u0627\u0644\u0623\u0633\u0648\u0627\u0642 \u0648\u0627\u0644\u0639\u0645\u0644\u0627\u062A \u0648\u0627\u0644\u0645\u0627\u0644\u064A\u0627\u062A \u0645\u0646 \u0645\u0643\u0627\u0646 \u0648\u0627\u062D\u062F.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileHero(
            user: user,
            summary: summary,
            markets: markets,
            currencies: currencies,
            onOpenMarkets: () => _showMarkets(context, markets, currencies),
            onOpenFinance: () => _showFinance(context, summary),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ProfileMetricCard(
                width: layout.metricWidth,
                title: '\u0627\u0644\u0633\u064A\u0648\u0644\u0629 \u0627\u0644\u0645\u062A\u0627\u062D\u0629',
                value: formatMoney(summary.availableCash),
                note: '\u0631\u0635\u064A\u062F \u062A\u0634\u063A\u064A\u0644\u064A \u0644\u0642\u0631\u0627\u0631 \u0627\u0644\u0634\u0631\u0627\u0621 \u0648\u0627\u0644\u062A\u0648\u0633\u0639.',
                accent: const Color(0xFF0F766E),
                icon: Icons.account_balance_wallet_rounded,
              ),
              ProfileMetricCard(
                width: layout.metricWidth,
                title: '\u0625\u062C\u0645\u0627\u0644\u064A \u0627\u0644\u0631\u0628\u062D',
                value: formatMoney(summary.totalProfit),
                note: '\u0635\u0648\u0631\u0629 \u0633\u0631\u064A\u0639\u0629 \u0644\u0644\u0631\u0628\u062D\u064A\u0629 \u0627\u0644\u062D\u0627\u0644\u064A\u0629.',
                accent: const Color(0xFF16A34A),
                icon: Icons.trending_up_rounded,
              ),
              ProfileMetricCard(
                width: layout.metricWidth,
                title: '\u062A\u0643\u0644\u0641\u0629 \u0627\u0644\u062A\u0634\u063A\u064A\u0644',
                value: formatMoney(summary.totalExpenses),
                note: '\u0645\u062A\u0627\u0628\u0639\u0629 \u0627\u0644\u0645\u0635\u0631\u0648\u0641\u0627\u062A \u0642\u0628\u0644 \u0623\u062B\u0631\u0647\u0627 \u0639\u0644\u0649 \u0627\u0644\u0647\u0627\u0645\u0634.',
                accent: const Color(0xFFDC2626),
                icon: Icons.money_off_csred_rounded,
              ),
              ProfileMetricCard(
                width: layout.metricWidth,
                title: '\u0647\u0627\u0645\u0634 \u0627\u0644\u0631\u0628\u062D',
                value: formatPercent(summary.netMargin),
                note: '\u0623\u0647\u0645 \u0645\u0624\u0634\u0631 \u0644\u0644\u062A\u0633\u0639\u064A\u0631 \u0648\u0627\u0644\u062A\u0634\u063A\u064A\u0644.',
                accent: const Color(0xFF2563EB),
                icon: Icons.percent_rounded,
              ),
            ],
          ),
          const SizedBox(height: 20),
          ProfileChartsGrid(
            financialReports: financialReports,
            production: production,
            markets: markets,
            currencies: currencies,
            summary: summary,
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(width: layout.primaryWidth, child: CompanyInfoPanel(infoItems: infoItems, markets: markets, currencies: currencies)),
              SizedBox(
                width: layout.secondaryWidth,
                child: _OwnerDecisionPanel(
                  summary: summary,
                  markets: markets,
                  currencies: currencies,
                  onOpenMarkets: () => _showMarkets(context, markets, currencies),
                  onOpenFinance: () => _showFinance(context, summary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showMarkets(BuildContext context, List<CompanyMarket> markets, List<CurrencyPoint> currencies) {
    return showProfileInfoSheet(
      context: context,
      title: '\u0627\u0644\u0623\u0633\u0648\u0627\u0642 \u0648\u0627\u0644\u0639\u0645\u0644\u0627\u062A',
      subtitle: '\u0645\u0644\u062E\u0635 \u0633\u0631\u064A\u0639 \u0644\u0644\u0623\u0633\u0648\u0627\u0642 \u0648\u0627\u0644\u0639\u0645\u0644\u0627\u062A \u0627\u0644\u0645\u0631\u062A\u0628\u0637\u0629 \u0628\u0627\u0644\u0628\u064A\u0639.',
      children: [
        ...markets.map((market) => ProfileSheetLine(label: market.name, value: '${market.currency} | ${formatPercent(market.share)} | ${formatPercent(market.growth)}')),
        ...currencies.map((currency) => ProfileSheetLine(label: currency.code, value: '${currency.value.toStringAsFixed(1)} | ${(currency.change * 100).toStringAsFixed(1)}%')),
        const ProfileSheetMessage(message: '\u0645\u062A\u0627\u0628\u0639\u0629 \u0627\u0644\u0623\u0633\u0648\u0627\u0642 \u0648\u0627\u0644\u0639\u0645\u0644\u0627\u062A \u0645\u0646 \u0647\u0646\u0627 \u062A\u0633\u0647\u0644 \u0642\u0631\u0627\u0631 \u0627\u0644\u0625\u0646\u062A\u0627\u062C \u0648\u0627\u0644\u0628\u064A\u0639.'),
      ],
    );
  }

  Future<void> _showFinance(BuildContext context, ProfileSummary summary) {
    return showProfileInfoSheet(
      context: context,
      title: '\u0627\u0644\u0645\u0644\u062E\u0635 \u0627\u0644\u0645\u0627\u0644\u064A',
      subtitle: '\u0642\u0631\u0627\u0621\u0629 \u0645\u0627\u0644\u064A\u0629 \u0633\u0631\u064A\u0639\u0629 \u0644\u0635\u0627\u062D\u0628 \u0627\u0644\u0645\u0635\u0646\u0639.',
      children: [
        ProfileSheetLine(label: '\u0625\u062C\u0645\u0627\u0644\u064A \u0627\u0644\u062F\u062E\u0644', value: formatMoney(summary.totalIncome)),
        ProfileSheetLine(label: '\u0627\u0644\u0633\u064A\u0648\u0644\u0629', value: formatMoney(summary.availableCash)),
        ProfileSheetLine(label: '\u0625\u062C\u0645\u0627\u0644\u064A \u0627\u0644\u0631\u0628\u062D', value: formatMoney(summary.totalProfit)),
        ProfileSheetLine(label: '\u0627\u0644\u0645\u0635\u0631\u0648\u0641\u0627\u062A', value: formatMoney(summary.totalExpenses)),
        ProfileSheetLine(label: '\u0647\u0627\u0645\u0634 \u0627\u0644\u0631\u0628\u062D', value: formatPercent(summary.netMargin)),
        ProfileSheetLine(label: '\u062A\u062D\u0642\u064A\u0642 \u0627\u0644\u0645\u0633\u062A\u0647\u062F\u0641', value: '${(summary.productionRate * 100).round()}%'),
        const ProfileSheetMessage(message: '\u0645\u0646 \u0647\u0646\u0627 \u062A\u0631\u0627\u0642\u0628 \u0623\u0647\u0645 \u0627\u0644\u0645\u0639\u0644\u0648\u0645\u0627\u062A \u0627\u0644\u0645\u0627\u0644\u064A\u0629 \u0645\u0646 \u0646\u0641\u0633 \u0627\u0644\u0635\u0641\u062D\u0629.'),
      ],
    );
  }
}

class _OwnerDecisionPanel extends StatelessWidget {
  const _OwnerDecisionPanel({
    required this.summary,
    required this.markets,
    required this.currencies,
    required this.onOpenMarkets,
    required this.onOpenFinance,
  });

  final ProfileSummary summary;
  final List<CompanyMarket> markets;
  final List<CurrencyPoint> currencies;
  final VoidCallback onOpenMarkets;
  final VoidCallback onOpenFinance;

  @override
  Widget build(BuildContext context) {
    final fastestMarket = markets.reduce((current, next) => current.growth >= next.growth ? current : next);
    final hottestCurrency = currencies.reduce((current, next) => current.change >= next.change ? current : next);

    return SectionCard(
      title: '\u0645\u0631\u0643\u0632 \u0642\u0631\u0627\u0631 \u0627\u0644\u0645\u0627\u0644\u0643',
      subtitle: '\u0623\u0647\u0645 \u0627\u0644\u0625\u0634\u0627\u0631\u0627\u062A \u0627\u0644\u0645\u0627\u0644\u064A\u0629 \u0648\u0627\u0644\u062A\u0634\u063A\u064A\u0644\u064A\u0629 \u0645\u0646 \u0646\u0641\u0633 \u0635\u0641\u062D\u0629 \u0627\u0644\u0628\u0631\u0648\u0641\u0627\u064A\u0644.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [Color(0xFF0F766E), Color(0xFF123A67)]),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('\u0646\u0628\u0636\u0629 \u0627\u0644\u0642\u0631\u0627\u0631', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
                const SizedBox(height: 8),
                Text(summary.actionMessage, style: const TextStyle(color: Color(0xEFFFFFFF), height: 1.6)),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _SignalCard(label: '\u0623\u0633\u0631\u0639 \u0633\u0648\u0642', value: fastestMarket.name, accent: const Color(0xFFFBBF24)),
                    _SignalCard(label: '\u0623\u0633\u062E\u0646 \u0639\u0645\u0644\u0629', value: hottestCurrency.code, accent: const Color(0xFFBFDBFE)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _ProgressLine(label: '\u0627\u0644\u0647\u0627\u0645\u0634 \u0627\u0644\u0631\u0628\u062D\u064A', value: summary.netMargin.clamp(0.0, 1.0).toDouble(), valueLabel: formatPercent(summary.netMargin), color: const Color(0xFF16A34A)),
          _ProgressLine(label: '\u0636\u063A\u0637 \u0627\u0644\u0645\u0635\u0631\u0648\u0641\u0627\u062A', value: summary.expenseShare.clamp(0.0, 1.0).toDouble(), valueLabel: formatPercent(summary.expenseShare), color: const Color(0xFFDC2626)),
          _ProgressLine(label: '\u062A\u062D\u0642\u064A\u0642 \u0627\u0644\u0645\u0633\u062A\u0647\u062F\u0641', value: summary.productionRate.clamp(0.0, 1.0).toDouble(), valueLabel: '${(summary.productionRate * 100).round()}%', color: const Color(0xFF0F766E)),
          _ProgressLine(label: '\u0625\u0646\u062C\u0627\u0632 \u0627\u0644\u0645\u0647\u0627\u0645', value: summary.taskCompletionRate.clamp(0.0, 1.0).toDouble(), valueLabel: '${(summary.taskCompletionRate * 100).round()}%', color: const Color(0xFF2563EB)),
          const SizedBox(height: 16),
          _DecisionLine(title: '\u062A\u0646\u0628\u064A\u0647\u0627\u062A \u0645\u0641\u062A\u0648\u062D\u0629', value: '${summary.alertCount}', note: '\u0623\u064A \u062A\u0646\u0628\u064A\u0647 \u0645\u0641\u062A\u0648\u062D \u064A\u062D\u062A\u0627\u062C \u0645\u062A\u0627\u0628\u0639\u0629 \u0641\u0648\u0631\u064A\u0629.'),
          _DecisionLine(title: '\u062E\u0627\u0645\u0627\u062A \u062D\u0631\u062C\u0629', value: '${summary.lowStockItems}', note: '\u0628\u0646\u0648\u062F \u0642\u0631\u064A\u0628\u0629 \u0645\u0646 \u0627\u0644\u062D\u062F \u0627\u0644\u0623\u062F\u0646\u0649.'),
          _DecisionLine(title: '\u0645\u0647\u0627\u0645 \u0645\u062A\u0623\u062E\u0631\u0629', value: '${summary.delayedTasks}', note: '\u062A\u0634\u064A\u0631 \u0625\u0644\u0649 \u0627\u062E\u062A\u0646\u0627\u0642\u0627\u062A \u0641\u064A \u0627\u0644\u062A\u0646\u0641\u064A\u0630.'),
          const SizedBox(height: 16),
          FilledButton.icon(onPressed: onOpenFinance, icon: const Icon(Icons.account_balance_wallet_rounded), label: const Text('\u0639\u0631\u0636 \u0627\u0644\u0645\u0627\u0644\u064A\u0627\u062A')),
          const SizedBox(height: 10),
          OutlinedButton.icon(onPressed: onOpenMarkets, icon: const Icon(Icons.public_rounded), label: const Text('\u0639\u0631\u0636 \u0627\u0644\u0623\u0633\u0648\u0627\u0642 \u0648\u0627\u0644\u0639\u0645\u0644\u0627\u062A')),
        ],
      ),
    );
  }
}

class _SignalCard extends StatelessWidget {
  const _SignalCard({required this.label, required this.value, required this.accent});

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xDFFFFFFF), fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: accent, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({required this.label, required this.value, required this.valueLabel, required this.color});

  final String label;
  final double value;
  final String valueLabel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800))),
              Text(valueLabel, style: TextStyle(color: color, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(value: value, minHeight: 10, color: color, backgroundColor: const Color(0xFFDCE8E4)),
          ),
        ],
      ),
    );
  }
}

class _DecisionLine extends StatelessWidget {
  const _DecisionLine({required this.title, required this.value, required this.note});

  final String title;
  final String value;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.48), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE2ECE8))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w900))),
                Text(value, style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.w900)),
              ],
            ),
            const SizedBox(height: 6),
            Text(note, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
          ],
        ),
      ),
    );
  }
}


