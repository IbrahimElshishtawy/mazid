import 'package:flutter/material.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/profile/presentation/widgets/components/profile_models.dart';

class ProfileHero extends StatelessWidget {
  const ProfileHero({super.key, required this.user, required this.summary, required this.onOpenMarkets, required this.onOpenFinance});

  final UserModel user;
  final ProfileSummary summary;
  final VoidCallback onOpenMarkets;
  final VoidCallback onOpenFinance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF0B1320), Color(0xFF123A67), Color(0xFF0F766E)]),
        boxShadow: [BoxShadow(color: const Color(0xFF123A67).withValues(alpha: 0.18), blurRadius: 34, offset: const Offset(0, 20))],
      ),
      child: Wrap(spacing: 24, runSpacing: 24, alignment: WrapAlignment.spaceBetween, children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const _Badge(label: 'ملف صاحب المصنع والشركة'),
            const SizedBox(height: 16),
            Text('إدارة عليا: ${summary.ownerState}', style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900, height: 1.1)),
            const SizedBox(height: 12),
            const Text('هنا تقدر تتابع صورة الشركة بالكامل: الأسواق، العملات، المؤشرات المالية، الربحية، السيولة، وأداء المصنع من منظور صاحب القرار.', style: TextStyle(color: Color(0xEAFFFFFF), height: 1.6)),
            const SizedBox(height: 18),
            Wrap(spacing: 12, runSpacing: 12, children: [
              _Stat(label: 'السيولة', value: formatMoney(summary.availableCash)),
              _Stat(label: 'الربح', value: formatMoney(summary.totalProfit)),
              _Stat(label: 'الهامش', value: formatPercent(summary.netMargin)),
              _Stat(label: 'التنبيهات', value: '${summary.alertCount}'),
            ]),
          ]),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withValues(alpha: 0.14))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(user.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24)),
              const SizedBox(height: 8),
              Text('مالك / مدير عام', style: const TextStyle(color: Color(0xDEFFFFFF))),
              const SizedBox(height: 12),
              _Line(label: 'البريد', value: user.email),
              _Line(label: 'الدور', value: user.role),
              _Line(label: 'حالة الحساب', value: user.status),
              _Line(label: 'المتابعة', value: 'الأسواق + الماليات + المصنع'),
              const SizedBox(height: 16),
              FilledButton.icon(onPressed: onOpenMarkets, style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFBBF24), foregroundColor: const Color(0xFF0B1320), minimumSize: const Size.fromHeight(50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))), icon: const Icon(Icons.public_rounded), label: const Text('الأسواق والعملات')),
              const SizedBox(height: 10),
              OutlinedButton.icon(onPressed: onOpenFinance, style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: BorderSide(color: Colors.white.withValues(alpha: 0.22)), minimumSize: const Size.fromHeight(50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))), icon: const Icon(Icons.account_balance_wallet_rounded), label: const Text('التفاصيل المالية')),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _Badge extends StatelessWidget { const _Badge({required this.label}); final String label; @override Widget build(BuildContext context) { return Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(999), border: Border.all(color: Colors.white.withValues(alpha: 0.14))), child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800))); } }
class _Stat extends StatelessWidget { const _Stat({required this.label, required this.value}); final String label; final String value; @override Widget build(BuildContext context) { return Container(width: 150, padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withValues(alpha: 0.12))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Color(0xD8FFFFFF), fontWeight: FontWeight.w700)), const SizedBox(height: 8), Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900))])); } }
class _Line extends StatelessWidget { const _Line({required this.label, required this.value}); final String label; final String value; @override Widget build(BuildContext context) { return Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [Expanded(child: Text(label, style: const TextStyle(color: Color(0xD8FFFFFF), fontWeight: FontWeight.w700))), Flexible(child: Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900), textAlign: TextAlign.end))])); } }
