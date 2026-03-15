import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import '../../../../core/widgets/section_components.dart';

class OverviewSection extends StatelessWidget {
  const OverviewSection({super.key, required this.alerts});

  final List<AlertModel> alerts;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 1100;

        return Column(
          children: [
            if (wide)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Expanded(flex: 3, child: _HomeSpotlight()),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: SectionCard(
                        title: '??????? ??????',
                        subtitle: '??? ????????? ????????? ???? ????? ?????? ????.',
                        child: Column(children: alerts.map((alert) => AlertTile(alert: alert)).toList()),
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              const _HomeSpotlight(),
              const SizedBox(height: 16),
              SectionCard(
                title: '??????? ??????',
                subtitle: '??? ????????? ????????? ???? ????? ?????? ????.',
                child: Column(children: alerts.map((alert) => AlertTile(alert: alert)).toList()),
              ),
            ],
            const SizedBox(height: 16),
            const SectionCard(
              title: '???? ???????',
              subtitle: '???? ???? ??????? ???????? ?? ??????.',
              child: Column(
                children: [
                  OverviewLine(title: '????? ??????????', description: '?????? ???????? ?????? ??????? ??????? ?? ???? ?????.'),
                  OverviewLine(title: '????? ?????', description: '?????? ????? ??????? ??? ???????? ???????.'),
                  OverviewLine(title: '???????', description: '???? ????? ?????????? ?????????? ?? ?????? ?????.'),
                  OverviewLine(title: '?????', description: '??????? ?????? ?? ??????? ???????? ??? ??????.'),
                  OverviewLine(title: '?????????', description: '??????? ??????? ?????????? ?????????? ???? ????.'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HomeSpotlight extends StatelessWidget {
  const _HomeSpotlight();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF111827), Color(0xFF0F766E)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F766E).withValues(alpha: 0.16),
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('????? ????? ????? ?????', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('???? ????? ??????? ????? ??????? ??? ?????? ?????? ??????? ????? ???????? ?????? ?????? ?????? ???? ???? ?????.', style: TextStyle(color: Color(0xD7FFFFFF), height: 1.7)),
          const SizedBox(height: 18),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: const [
              _PulseCard(title: '?????? ??????', value: '92%', accent: Color(0xFF34D399)),
              _PulseCard(title: '???? ???????', value: '97%', accent: Color(0xFF60A5FA)),
              _PulseCard(title: '??????? ???????', value: '+18%', accent: Color(0xFFFBBF24)),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('????? ??????? ?????', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                SizedBox(height: 8),
                Text('??????? ????? ??? ????? ??? ??????? ??? ???? ????????? ?????????? ??????? ??? ???? ??????? ???? ????? ?? ?????.', style: TextStyle(color: Color(0xD7FFFFFF), height: 1.6)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text('???? ???????? ?????????', style: TextStyle(color: Color(0xD7FFFFFF), fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: const LinearProgressIndicator(
              value: 0.84,
              minHeight: 10,
              color: Color(0xFFBBF7D0),
              backgroundColor: Color(0x26FFFFFF),
            ),
          ),
          const SizedBox(height: 8),
          const Text('84% ?? ????? ??????? ??? ??????? ?? ???? ??????? ????? ?????????? ??????.', style: TextStyle(color: Color(0xBFFFFFFF), height: 1.5)),
        ],
      ),
    );
  }
}

class _PulseCard extends StatelessWidget {
  const _PulseCard({required this.title, required this.value, required this.accent});

  final String title;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.7, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
      child: Container(
        width: 210,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 12, height: 12, decoration: BoxDecoration(color: accent, shape: BoxShape.circle)),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: Color(0xD7FFFFFF), fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 0.86),
                duration: const Duration(milliseconds: 1100),
                builder: (context, progress, _) => LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  color: accent,
                  backgroundColor: Colors.white.withValues(alpha: 0.12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}








