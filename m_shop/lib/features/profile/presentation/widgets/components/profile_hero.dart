import 'package:flutter/material.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/profile/presentation/widgets/components/profile_models.dart';

class ProfileHero extends StatelessWidget {
  const ProfileHero({
    super.key,
    required this.user,
    required this.summary,
    required this.markets,
    required this.currencies,
    required this.onOpenMarkets,
    required this.onOpenFinance,
  });

  final UserModel user;
  final ProfileSummary summary;
  final List<CompanyMarket> markets;
  final List<CurrencyPoint> currencies;
  final VoidCallback onOpenMarkets;
  final VoidCallback onOpenFinance;

  @override
  Widget build(BuildContext context) {
    final topMarket = markets.reduce((current, next) => current.share >= next.share ? current : next);
    final topCurrency = currencies.reduce((current, next) => current.value >= next.value ? current : next);

    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF08111E), Color(0xFF123A67), Color(0xFF0F766E)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF123A67).withValues(alpha: 0.18),
            blurRadius: 34,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Wrap(
        spacing: 24,
        runSpacing: 24,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: const [
                    _Badge(label: '\u0644\u0648\u062D\u0629 \u0635\u0627\u062D\u0628 \u0627\u0644\u0645\u0635\u0646\u0639'),
                    _Badge(label: '8 \u0631\u0633\u0648\u0645 \u062A\u0646\u0641\u064A\u0630\u064A\u0629'),
                    _Badge(label: '7 \u0645\u0639\u0644\u0648\u0645\u0627\u062A \u0623\u0633\u0627\u0633\u064A\u0629'),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  '\u0625\u062F\u0627\u0631\u0629 \u0639\u0644\u064A\u0627: ${summary.ownerState}',
                  style: const TextStyle(color: Colors.white, fontSize: 31, fontWeight: FontWeight.w900, height: 1.1),
                ),
                const SizedBox(height: 12),
                const Text(
                  '\u0647\u0646\u0627 \u062A\u062A\u0627\u0628\u0639 \u0627\u0644\u0623\u0633\u0648\u0627\u0642 \u0648\u0627\u0644\u0639\u0645\u0644\u0627\u062A \u0648\u0627\u0644\u0645\u0627\u0644\u064A\u0627\u062A \u0648\u0627\u0644\u062A\u0646\u0641\u064A\u0630 \u0645\u0646 \u0645\u0643\u0627\u0646 \u0648\u0627\u062D\u062F \u0648\u0628\u0634\u0643\u0644 \u0648\u0627\u0636\u062D.',
                  style: TextStyle(color: Color(0xEAFFFFFF), height: 1.7),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBBF24).withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.insights_rounded, color: Color(0xFFFCD34D)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '\u0642\u0631\u0627\u0621\u0629 \u0627\u0644\u0642\u0631\u0627\u0631 \u0627\u0644\u064A\u0648\u0645\u064A',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 6),
                            Text(summary.actionMessage, style: const TextStyle(color: Color(0xE7FFFFFF), height: 1.6)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _Stat(label: '\u0627\u0644\u0633\u064A\u0648\u0644\u0629', value: formatMoney(summary.availableCash)),
                    _Stat(label: '\u0627\u0644\u0631\u0628\u062D', value: formatMoney(summary.totalProfit)),
                    _Stat(label: '\u0627\u0644\u0645\u0633\u062A\u0647\u062F\u0641', value: '${(summary.productionRate * 100).round()}%'),
                    _Stat(label: '\u0627\u0644\u0645\u0647\u0627\u0645 \u0627\u0644\u0645\u0643\u062A\u0645\u0644\u0629', value: '${summary.completedTasks}/${summary.totalTasks}'),
                  ],
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _InsightPill(
                      icon: Icons.public_rounded,
                      title: '\u0623\u0639\u0644\u0649 \u0633\u0648\u0642 \u0628\u064A\u0639',
                      value: '${topMarket.name} | ${formatPercent(topMarket.share)}',
                    ),
                    _InsightPill(
                      icon: Icons.currency_exchange_rounded,
                      title: '\u0623\u0639\u0644\u0649 \u0639\u0645\u0644\u0629',
                      value: '${topCurrency.code} | ${topCurrency.value.toStringAsFixed(1)}',
                    ),
                  ],
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white.withValues(alpha: 0.12),
                        child: Text(
                          user.name.isNotEmpty ? user.name.substring(0, 1) : '?',
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22)),
                            const SizedBox(height: 4),
                            const Text('\u0645\u0627\u0644\u0643 / \u0645\u062F\u064A\u0631 \u0639\u0627\u0645', style: TextStyle(color: Color(0xDEFFFFFF))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _Line(label: '\u0627\u0644\u0628\u0631\u064A\u062F', value: user.email),
                  _Line(label: '\u0627\u0644\u062F\u0648\u0631', value: user.role),
                  _Line(label: '\u0627\u0644\u062D\u0627\u0644\u0629', value: user.status),
                  _Line(label: '\u062E\u0627\u0645\u0627\u062A \u062D\u0631\u062C\u0629', value: '${summary.lowStockItems}'),
                  _Line(label: '\u062A\u0646\u0628\u064A\u0647\u0627\u062A', value: '${summary.alertCount}'),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: onOpenMarkets,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFBBF24),
                      foregroundColor: const Color(0xFF0B1320),
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    icon: const Icon(Icons.public_rounded),
                    label: const Text('\u0627\u0644\u0623\u0633\u0648\u0627\u0642 \u0648\u0627\u0644\u0639\u0645\u0644\u0627\u062A'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: onOpenFinance,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.22)),
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    icon: const Icon(Icons.account_balance_wallet_rounded),
                    label: const Text('\u0627\u0644\u0645\u0644\u062E\u0635 \u0627\u0644\u0645\u0627\u0644\u064A'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xD8FFFFFF), fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _InsightPill extends StatelessWidget {
  const _InsightPill({required this.icon, required this.title, required this.value});

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFFCD34D), size: 18),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Color(0xD8FFFFFF), fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Color(0xD8FFFFFF), fontWeight: FontWeight.w700))),
          Flexible(
            child: Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900), textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}
