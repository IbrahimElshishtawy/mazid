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
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionCard(
          title: 'معلومات الشركة والمصنع',
          subtitle: '7 معلومات أساسية بشكل سريع وواضح.',
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 560;
              final itemWidth = wide ? (constraints.maxWidth - 8) / 2 : constraints.maxWidth;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: infoItems
                    .map((item) => SizedBox(width: itemWidth, child: _InfoCard(item: item)))
                    .toList(),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        SectionCard(
          title: 'الأسواق والعملات',
          subtitle: 'متابعة مباشرة للأسواق والعملات المؤثرة على البيع.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...markets.map((market) => _MarketCard(market: market)),
              const SizedBox(height: 10),
              Text(
                'العملات البيعية',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: isDark
              ? [theme.cardColor, const Color(0xFF122031)]
              : const [Color(0xFFFFFFFF), Color(0xFFF4F9F7)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF0F766E),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 10),
          Text(item.title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(
            item.value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontSize: 14,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.note,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
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
    final theme = Theme.of(context);
    final growthColor = market.growth >= 0.1 ? const Color(0xFF16A34A) : const Color(0xFF2563EB);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? theme.colorScheme.surface.withValues(alpha: 0.72)
            : const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: growthColor.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  market.name,
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: growthColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${market.currency} | ${formatPercent(market.growth)} نمو',
                  style: TextStyle(color: growthColor, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'حصة البيع',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                formatPercent(market.share),
                style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: market.share,
              minHeight: 8,
              color: const Color(0xFF0F766E),
              backgroundColor: theme.dividerColor.withValues(alpha: 0.45),
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
    final theme = Theme.of(context);
    final up = currency.change >= 0;
    final accent = up ? const Color(0xFF2563EB) : const Color(0xFFDC2626);
    final sign = up ? '+' : '-';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            currency.code,
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w900, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            currency.value.toStringAsFixed(1),
            style: TextStyle(color: accent, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 3),
          Text(
            '$sign${(currency.change * 100).toStringAsFixed(1)}%',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

