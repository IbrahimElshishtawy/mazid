import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/profile/presentation/widgets/components/profile_models.dart';

class CompanyInfoPanel extends StatelessWidget {
  const CompanyInfoPanel({super.key, required this.infoItems, required this.markets, required this.currencies});

  final List<CompanyInfoItem> infoItems;
  final List<CompanyMarket> markets;
  final List<CurrencyPoint> currencies;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionCard(
          title: '\u0645\u0639\u0644\u0648\u0645\u0627\u062A \u0627\u0644\u0634\u0631\u0643\u0629 \u0648\u0627\u0644\u0645\u0635\u0646\u0639',
          subtitle: '7 \u0645\u0639\u0644\u0648\u0645\u0627\u062A \u0623\u0633\u0627\u0633\u064A\u0629 \u0628\u0634\u0643\u0644 \u0633\u0631\u064A\u0639 \u0648\u0627\u0636\u062D.',
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 560;
              final itemWidth = wide ? (constraints.maxWidth - 14) / 2 : constraints.maxWidth;
              return Wrap(
                spacing: 14,
                runSpacing: 14,
                children: infoItems.map((item) => SizedBox(width: itemWidth, child: _InfoCard(item: item))).toList(),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: '\u0627\u0644\u0623\u0633\u0648\u0627\u0642 \u0648\u0627\u0644\u0639\u0645\u0644\u0627\u062A',
          subtitle: '\u0645\u062A\u0627\u0628\u0639\u0629 \u0645\u0628\u0627\u0634\u0631\u0629 \u0644\u0644\u0623\u0633\u0648\u0627\u0642 \u0648\u0627\u0644\u0639\u0645\u0644\u0627\u062A \u0627\u0644\u0645\u0624\u062B\u0631\u0629 \u0639\u0644\u0649 \u0627\u0644\u0628\u064A\u0639.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...markets.map((market) => _MarketCard(market: market)),
              const SizedBox(height: 14),
              const Text(
                '\u0627\u0644\u0639\u0645\u0644\u0627\u062A \u0627\u0644\u0628\u064A\u0639\u064A\u0629',
                style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF111827)),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: currencies.map((currency) => _CurrencyCard(currency: currency)).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.item});

  final CompanyInfoItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [Color(0xFFFFFFFF), Color(0xFFF4F9F7)]),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2ECE8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 42, height: 4, decoration: BoxDecoration(color: const Color(0xFF0F766E), borderRadius: BorderRadius.circular(999))),
          const SizedBox(height: 14),
          Text(item.title, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(item.value, style: const TextStyle(fontSize: 16, color: Color(0xFF111827), fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(item.note, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
        ],
      ),
    );
  }
}

class _MarketCard extends StatelessWidget {
  const _MarketCard({required this.market});

  final CompanyMarket market;

  @override
  Widget build(BuildContext context) {
    final growthColor = market.growth >= 0.1 ? const Color(0xFF16A34A) : const Color(0xFF2563EB);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: growthColor.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(market.name, style: const TextStyle(fontWeight: FontWeight.w900))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: growthColor.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(999)),
                child: Text(
                  '${market.currency} | ${formatPercent(market.growth)} \u0646\u0645\u0648',
                  style: TextStyle(color: growthColor, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('\u062D\u0635\u0629 \u0627\u0644\u0628\u064A\u0639', style: TextStyle(color: Color(0xFF667B75), fontWeight: FontWeight.w700)),
              const Spacer(),
              Text(formatPercent(market.share), style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: market.share,
              minHeight: 10,
              color: const Color(0xFF0F766E),
              backgroundColor: const Color(0xFFDDEAE6),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrencyCard extends StatelessWidget {
  const _CurrencyCard({required this.currency});

  final CurrencyPoint currency;

  @override
  Widget build(BuildContext context) {
    final up = currency.change >= 0;
    final accent = up ? const Color(0xFF2563EB) : const Color(0xFFDC2626);
    final sign = up ? '+' : '-';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: accent.withValues(alpha: 0.14))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(currency.code, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
          const SizedBox(height: 6),
          Text(currency.value.toStringAsFixed(1), style: TextStyle(color: accent, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text('$sign${(currency.change * 100).toStringAsFixed(1)}%', style: const TextStyle(color: Color(0xFF667B75), fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
