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
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SectionCard(
        title: 'معلومات الشركة والمصنع',
        subtitle: '7 معلومات أساسية يحتاجها صاحب المصنع أمامه بشكل واضح وسريع.',
        child: Column(children: infoItems.map((item) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFF7FAF9), borderRadius: BorderRadius.circular(20)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 10, height: 10, margin: const EdgeInsets.only(top: 6), decoration: const BoxDecoration(color: Color(0xFF0F766E), shape: BoxShape.circle)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 6), Text(item.value, style: const TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text(item.note, style: const TextStyle(color: Color(0xFF667B75), height: 1.45))]))])))).toList()),
      ),
      const SizedBox(height: 16),
      SectionCard(
        title: 'الأسواق والعملات',
        subtitle: 'ملخص سريع لأهم الأسواق البيعية والعملات التي يتم التعامل بها.',
        child: Column(children: [
          ...markets.map((market) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [Expanded(child: Text(market.name, style: const TextStyle(fontWeight: FontWeight.w800))), Text('${market.currency} • ${formatPercent(market.share)}', style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.w800))]))),
          const SizedBox(height: 8),
          Wrap(spacing: 10, runSpacing: 10, children: currencies.map((currency) => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2ECE8))), child: Text('${currency.code}  ${currency.value.toStringAsFixed(1)}', style: const TextStyle(fontWeight: FontWeight.w800)))).toList()),
        ]),
      ),
    ]);
  }
}
