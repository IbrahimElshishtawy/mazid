import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';
import 'package:m_shop/features/overview/presentation/widgets/components/overview_models.dart';

class OverviewActionPanel extends StatelessWidget {
  const OverviewActionPanel({
    super.key,
    required this.onWorkers,
    required this.onMachines,
    required this.onFinance,
    required this.onMaintenance,
    required this.onPayroll,
  });

  final VoidCallback onWorkers;
  final VoidCallback onMachines;
  final VoidCallback onFinance;
  final VoidCallback onMaintenance;
  final VoidCallback onPayroll;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'محطات المراقبة',
      subtitle: 'اختصارات تنفيذية لمتابعة كل شبر في المصنع من مكان واحد.',
      child: Wrap(
        spacing: 14,
        runSpacing: 14,
        children: [
          _ActionCard(label: 'العمال', note: 'متابعة الحضور والانضباط والمهام اليومية', icon: Icons.groups_rounded, accent: const Color(0xFF0F766E), onPressed: onWorkers),
          _ActionCard(label: 'المكن', note: 'مراقبة الكفاءة والأعطال والتحسينات', icon: Icons.precision_manufacturing_rounded, accent: const Color(0xFF2563EB), onPressed: onMachines),
          _ActionCard(label: 'المالية', note: 'مراجعة الأرباح والخسائر والقبض', icon: Icons.account_balance_wallet_rounded, accent: const Color(0xFF16A34A), onPressed: onFinance),
          _ActionCard(label: 'الصيانة', note: 'فتح تقارير التحسينات والصيانة الوقائية', icon: Icons.build_circle_outlined, accent: const Color(0xFFF59E0B), onPressed: onMaintenance),
          _ActionCard(label: 'الأجور والخصومات', note: 'مراجعة الأجور والخصومات والحوافز', icon: Icons.payments_outlined, accent: const Color(0xFFDC2626), onPressed: onPayroll),
        ],
      ),
    );
  }
}

class FactoryMonitorPanel extends StatelessWidget {
  const FactoryMonitorPanel({
    super.key,
    required this.alerts,
    required this.cameraPoints,
    required this.summary,
  });

  final List<AlertModel> alerts;
  final List<CameraPoint> cameraPoints;
  final OverviewSummary summary;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'المراقبة الحية',
      subtitle: 'متابعة التنبيهات والكاميرات والملاحظات التشغيلية في الوقت الحالي.',
      child: Column(
        children: [
          ...cameraPoints.map((camera) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _MonitorTile(
                  title: camera.name,
                  subtitle: camera.online ? 'الكاميرا تعمل والتغطية ${((camera.coverage) * 100).round()}%' : 'الكاميرا تحتاج مراجعة فورية',
                  accent: camera.online ? const Color(0xFF0F766E) : const Color(0xFFDC2626),
                ),
              )),
          ...alerts.map((alert) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _MonitorTile(
                  title: alert.title,
                  subtitle: alert.description,
                  accent: Color(alert.colorHex),
                ),
              )),
          _MonitorTile(
            title: 'جاهزية الصيانة',
            subtitle: 'مستوى الجاهزية الحالي ${(summary.maintenanceReadiness * 100).round()}% مع احتياج لمتابعة دورية للأصول.',
            accent: const Color(0xFF2563EB),
          ),
        ],
      ),
    );
  }
}

class ImprovementsPanel extends StatelessWidget {
  const ImprovementsPanel({super.key, required this.tasks, required this.inventory});

  final List<TaskModel> tasks;
  final List<InventoryItem> inventory;

  @override
  Widget build(BuildContext context) {
    final lowStock = inventory.where((item) => item.quantity <= item.minimum).length;
    return SectionCard(
      title: 'التحسينات المقترحة',
      subtitle: 'أفكار عملية لتحسين التشغيل وتقليل الهدر وزيادة الرقابة.',
      child: Column(
        children: [
          _IdeaTile(title: 'رفع مراقبة خطوط العمل', description: 'ربط متابعة العمال بالتأخير الفعلي في المهام الحالية لسرعة التدخل قبل نهاية الوردية.'),
          _IdeaTile(title: 'تحسين الصيانة الوقائية', description: 'جدولة مهام الصيانة قبل الذروة الإنتاجية لتفادي توقف المكن وقت الضغط.'),
          _IdeaTile(title: 'تقليل الضغط على المخزون', description: 'هناك $lowStock أصناف قريبة من الحد الأدنى ويجب إعادة ضبط توقيتات التوريد.'),
          _IdeaTile(title: 'ضبط ملف الأجور والخصومات', description: 'ربط الخصومات والحوافز مباشرة بنسبة الإنجاز والانضباط بدل المعالجة اليدوية المتأخرة.'),
          _IdeaTile(title: 'تكثيف متابعة الكاميرات', description: 'تجميع لقطات النقاط الحساسة مع تنبيهات الأعطال لتقليل فترات عدم الرؤية داخل المصنع.'),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.label, required this.note, required this.icon, required this.accent, required this.onPressed});

  final String label;
  final String note;
  final IconData icon;
  final Color accent;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 214,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(22),
          child: Ink(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(22), border: Border.all(color: accent.withValues(alpha: 0.14))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: accent.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: accent)),
              const SizedBox(height: 14),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              const SizedBox(height: 6),
              Text(note, style: const TextStyle(color: Color(0xFF667B75), height: 1.45)),
            ]),
          ),
        ),
      ),
    );
  }
}

class _MonitorTile extends StatelessWidget {
  const _MonitorTile({required this.title, required this.subtitle, required this.accent});
  final String title;
  final String subtitle;
  final Color accent;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(18), border: Border.all(color: accent.withValues(alpha: 0.14))),
      child: Row(children: [Container(width: 12, height: 42, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(999))), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 6), Text(subtitle, style: const TextStyle(color: Color(0xFF667B75), height: 1.45))]))]),
    );
  }
}

class _IdeaTile extends StatelessWidget {
  const _IdeaTile({required this.title, required this.description});
  final String title;
  final String description;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Theme.of(context).cardColor, const Color(0xFF0F766E).withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.10 : 0.04)]), borderRadius: BorderRadius.circular(20), border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.4))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 6), Text(description, style: const TextStyle(color: Color(0xFF667B75), height: 1.5))]),
      ),
    );
  }
}


