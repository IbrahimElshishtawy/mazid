import 'package:flutter/material.dart';
import 'package:m_shop/features/overview/presentation/widgets/components/overview_models.dart';

class OverviewHero extends StatelessWidget {
  const OverviewHero({
    super.key,
    required this.summary,
    required this.onOpenFactory,
    required this.onOpenCameras,
  });

  final OverviewSummary summary;
  final VoidCallback onOpenFactory;
  final VoidCallback onOpenCameras;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF111827), Color(0xFF0F766E), Color(0xFF0891B2)],
        ),
        boxShadow: [
          BoxShadow(color: const Color(0xFF0F766E).withValues(alpha: 0.18), blurRadius: 34, offset: const Offset(0, 20)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(top: -28, right: -24, child: Container(width: 170, height: 170, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.05)))),
          Positioned(bottom: -30, left: 12, child: Container(width: 220, height: 86, decoration: BoxDecoration(borderRadius: BorderRadius.circular(26), color: Colors.white.withValues(alpha: 0.05)))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HeroBadge(label: 'لوحة التحكم الرئيسية للمصنع'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 22,
                runSpacing: 22,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('المصنع الآن ${summary.factoryState}', style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 12),
                        const Text(
                          'من هنا تقدر تتابع العمال، المكن، الأرباح والخسائر، الصيانة، التحسينات، الكاميرات، الأجور، الخصومات، والقبض في شاشة واحدة.',
                          style: TextStyle(color: Color(0xE7FFFFFF), height: 1.6),
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            HeroStat(label: 'عمال حاضرون', value: '${summary.presentWorkers}'),
                            HeroStat(label: 'كفاءة المكن', value: '${(summary.machineEfficiency * 100).round()}%'),
                            HeroStat(label: 'تغطية الكاميرات', value: '${(summary.cameraCoverage * 100).round()}%'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('حالة مالية سريعة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                              const SizedBox(height: 10),
                              Text(formatMoney(summary.totalProfit), style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                              const SizedBox(height: 6),
                              Text('خسائر تقديرية ${formatMoney(summary.totalLosses)}', style: const TextStyle(color: Color(0xD8FFFFFF))),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: onOpenFactory,
                          style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFBBF24), foregroundColor: const Color(0xFF111827), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                          icon: const Icon(Icons.factory_outlined),
                          label: const Text('فتح تقرير المصنع'),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: onOpenCameras,
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: BorderSide(color: Colors.white.withValues(alpha: 0.22)), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                          icon: const Icon(Icons.videocam_outlined),
                          label: const Text('فتح متابعة الكاميرات'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HeroStat extends StatelessWidget {
  const HeroStat({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 152,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0x1AFFFFFF), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withValues(alpha: 0.12))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Color(0xDBFFFFFF), fontWeight: FontWeight.w700)), const SizedBox(height: 8), Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18))]),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(color: const Color(0x1AFFFFFF), borderRadius: BorderRadius.circular(999), border: Border.all(color: Colors.white.withValues(alpha: 0.14))),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
    );
  }
}
