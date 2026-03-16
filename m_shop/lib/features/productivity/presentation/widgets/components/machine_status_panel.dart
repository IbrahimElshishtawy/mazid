import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/productivity/presentation/widgets/components/productivity_models.dart';

class MachineStatusPanel extends StatelessWidget {
  const MachineStatusPanel({
    super.key,
    required this.selectedJourney,
    required this.selectedMachineName,
    required this.onSelectMachine,
    required this.onOpenMachine,
  });

  final ProductJourney selectedJourney;
  final String selectedMachineName;
  final ValueChanged<MachineInfo> onSelectMachine;
  final ValueChanged<MachineInfo> onOpenMachine;

  @override
  Widget build(BuildContext context) {
    final selectedMachine = selectedJourney.machines.firstWhere(
      (machine) => machine.name == selectedMachineName,
      orElse: () => selectedJourney.machines.first,
    );

    return SectionCard(
      title: 'ملف الماكينات العاملة',
      subtitle: 'تفاصيل أعمق عن الماكينات التي يمر عليها المنتج وحالة كل ماكينة حالياً.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [selectedMachine.accent.withValues(alpha: 0.16), Colors.white],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: selectedMachine.accent.withValues(alpha: 0.16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(selectedMachine.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22)),
                const SizedBox(height: 8),
                Text('الموديل: ${selectedMachine.model}', style: const TextStyle(color: Color(0xFF667B75))),
                const SizedBox(height: 14),
                _InfoLine(label: 'الحالة', value: selectedMachine.status),
                _InfoLine(label: 'المنتج الحالي', value: selectedMachine.currentProduct),
                _InfoLine(label: 'الكفاءة', value: formatPercent(selectedMachine.efficiency)),
                _InfoLine(label: 'درجة الحرارة', value: '${selectedMachine.temperature}°'),
                _InfoLine(label: 'ساعات التشغيل', value: '${selectedMachine.operatingHours.toStringAsFixed(1)} ساعة'),
                _InfoLine(label: 'عدد المنتظرين', value: '${selectedMachine.queueCount}'),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.72), borderRadius: BorderRadius.circular(16)),
                  child: Text(selectedMachine.maintenanceNote, style: const TextStyle(height: 1.5)),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => onOpenMachine(selectedMachine),
                  icon: const Icon(Icons.settings_suggest_rounded),
                  label: const Text('فتح تقرير الماكينة'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...selectedJourney.machines.map(
            (machine) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => onSelectMachine(machine),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: machine.name == selectedMachine.name ? machine.accent.withValues(alpha: 0.08) : const Color(0xFFF7FAF9),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: machine.name == selectedMachine.name ? machine.accent.withValues(alpha: 0.24) : Colors.transparent),
                  ),
                  child: Row(
                    children: [
                      Container(width: 12, height: 12, decoration: BoxDecoration(color: machine.accent, shape: BoxShape.circle)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(machine.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                            const SizedBox(height: 4),
                            Text(machine.status, style: const TextStyle(color: Color(0xFF667B75), fontSize: 12)),
                          ],
                        ),
                      ),
                      Text(formatPercent(machine.efficiency), style: TextStyle(color: machine.accent, fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Color(0xFF667B75), fontWeight: FontWeight.w700))),
          Flexible(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w900), textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}
