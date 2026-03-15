part of 'dashboard_sections.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Center(
              child: Text(
                user.name.isNotEmpty ? user.name.substring(0, 1) : '?',
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text('حساب إداري', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFBBF7D0).withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text('نشط الآن', style: TextStyle(color: Color(0xFFBBF7D0), fontWeight: FontWeight.w800, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(user.role, style: const TextStyle(color: Color(0xD7FFFFFF), fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text(user.email, style: const TextStyle(color: Color(0xBFFFFFFF), height: 1.4)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.16)),
                ),
                icon: const Icon(Icons.visibility_outlined),
                label: const Text('مراقبة'),
              ),
              const SizedBox(height: 10),
              FilledButton.icon(
                onPressed: () {},
                style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF0F172A)),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('تعديل'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SettingRow extends StatelessWidget {
  const SettingRow({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFFF7FAF9), borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700))),
            Text(value, style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class OverviewLine extends StatelessWidget {
  const OverviewLine({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 10, height: 10, margin: const EdgeInsets.only(top: 5), decoration: const BoxDecoration(color: Color(0xFF0F766E), shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AlertTile extends StatelessWidget {
  const AlertTile({super.key, required this.alert});

  final AlertModel alert;

  @override
  Widget build(BuildContext context) {
    final color = Color(alert.colorHex);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(alert.title, style: TextStyle(color: color, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(alert.description, style: const TextStyle(color: Color(0xFF30413D), height: 1.5)),
        ],
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return SimpleTile(title: user.name, subtitle: '${user.role} • ${user.email}', trailing: user.status);
  }
}

class AttendanceTile extends StatelessWidget {
  const AttendanceTile({super.key, required this.record});

  final AttendanceRecord record;

  @override
  Widget build(BuildContext context) {
    final accent = record.present ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final status = record.present ? 'حاضر' : 'غائب';
    final note = record.present
        ? (record.checkIn != '-' && _late(record.checkIn) ? 'تأخر عن الموعد المحدد' : 'ملتزم بموعد الدوام')
        : 'يحتاج متابعة من الإدارة';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(record.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: accent.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(999)),
                child: Text(status, style: TextStyle(color: accent, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _AttendanceInfoChip(icon: Icons.login_rounded, label: 'دخول', value: record.checkIn),
              _AttendanceInfoChip(icon: Icons.logout_rounded, label: 'انصراف', value: record.checkOut),
              _AttendanceInfoChip(icon: Icons.schedule_rounded, label: 'الساعات', value: '${record.workedHours}'),
            ],
          ),
          const SizedBox(height: 12),
          Text(note, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _QuickAction(label: 'تعديل', icon: Icons.edit_outlined),
              _QuickAction(label: 'متابعة', icon: Icons.visibility_outlined),
              _QuickAction(label: 'اعتماد', icon: Icons.verified_outlined),
            ],
          ),
        ],
      ),
    );
  }

  bool _late(String checkIn) {
    if (checkIn == '-' || !checkIn.contains(':')) {
      return false;
    }

    final parts = checkIn.split(':');
    final hour = int.tryParse(parts.first) ?? 0;
    final minute = int.tryParse(parts.last) ?? 0;
    return hour > 8 || (hour == 8 && minute > 10);
  }
}

class _AttendanceInfoChip extends StatelessWidget {
  const _AttendanceInfoChip({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2ECE8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF0F766E)),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w700)),
          Text(value, style: const TextStyle(color: Color(0xFF667B75))),
        ],
      ),
    );
  }
}

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    final approvalReady = task.progress >= 0.8;
    final delayed = task.progress < 0.4 || task.status.contains('مجدولة');
    final accent = approvalReady ? const Color(0xFF16A34A) : delayed ? const Color(0xFFDC2626) : const Color(0xFF0F766E);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: accent.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(999)),
                child: Text(
                  approvalReady ? 'جاهزة للاعتماد' : delayed ? 'تحتاج تدخل' : task.status,
                  style: TextStyle(color: accent, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(task.description, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _AttendanceInfoChip(icon: Icons.person_outline_rounded, label: 'المسؤول', value: task.assignedTo),
              _AttendanceInfoChip(icon: Icons.calendar_today_outlined, label: 'الموعد', value: task.dueDate),
              _AttendanceInfoChip(icon: Icons.analytics_outlined, label: 'الإنجاز', value: '${(task.progress * 100).round()}%'),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: task.progress,
              minHeight: 9,
              color: accent,
              backgroundColor: const Color(0xFFD9E6E2),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            approvalReady ? 'يمكن للإدارة مراجعة المهمة الآن واعتمادها كمنجزة.' : delayed ? 'يوصى بمتابعة هذه المهمة أو إعادة جدولتها سريعًا.' : 'المهمة تسير بشكل طبيعي وتحتاج متابعة حتى الاكتمال.',
            style: const TextStyle(color: Color(0xFF667B75), height: 1.5),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              const _QuickAction(label: 'متابعة', icon: Icons.visibility_outlined),
              const _QuickAction(label: 'تعديل', icon: Icons.edit_outlined),
              _QuickAction(label: approvalReady ? 'اعتماد' : 'تحديث الحالة', icon: approvalReady ? Icons.fact_check_rounded : Icons.sync_alt_rounded),
              _QuickAction(label: 'إعادة إسناد', icon: Icons.swap_horiz_rounded),
            ],
          ),
        ],
      ),
    );
  }
}

class InventoryTile extends StatelessWidget {
  const InventoryTile({super.key, required this.item});

  final InventoryItem item;

  @override
  Widget build(BuildContext context) {
    final low = item.quantity <= item.minimum;
    final color = low ? const Color(0xFFDC2626) : const Color(0xFF16A34A);
    final coverage = (item.quantity / item.minimum).clamp(0.0, 1.8).toDouble();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(999)),
                child: Text(low ? 'حرج' : 'مستقر', style: TextStyle(color: color, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _AttendanceInfoChip(icon: Icons.inventory_2_outlined, label: 'المتوفر', value: '${item.quantity} ${item.unit}'),
              _AttendanceInfoChip(icon: Icons.warning_amber_outlined, label: 'الحد الأدنى', value: '${item.minimum} ${item.unit}'),
              _AttendanceInfoChip(icon: Icons.speed_outlined, label: 'التغطية', value: '${(coverage * 100).round()}%'),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: (coverage / 1.8).clamp(0.0, 1.0).toDouble(),
              minHeight: 9,
              color: color,
              backgroundColor: const Color(0xFFD9E6E2),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            low ? 'هذا الصنف يحتاج تدخلًا سريعًا أو اعتماد طلب شراء حتى لا يؤثر على التشغيل.' : 'هذا الصنف في مستوى مطمئن ويمكن الاعتماد عليه في التشغيل الحالي.',
            style: const TextStyle(color: Color(0xFF667B75), height: 1.5),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _QuickAction(label: 'تعديل', icon: Icons.edit_outlined),
              _QuickAction(label: 'طلب شراء', icon: Icons.shopping_cart_checkout_rounded),
              _QuickAction(label: 'تحويل مخزني', icon: Icons.swap_horiz_rounded),
              _QuickAction(label: 'متابعة', icon: Icons.visibility_outlined),
            ],
          ),
        ],
      ),
    );
  }
}

class FinanceTile extends StatelessWidget {
  const FinanceTile({super.key, required this.report});

  final FinancialReport report;

  @override
  Widget build(BuildContext context) {
    final margin = report.income == 0 ? 0.0 : report.profit / report.income;
    final healthy = margin >= 0.25;
    final color = healthy ? const Color(0xFF059669) : const Color(0xFFF59E0B);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('تقرير ${report.period}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(999)),
                child: Text(healthy ? 'ربحية قوية' : 'تحتاج تحسين', style: TextStyle(color: color, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _AttendanceInfoChip(icon: Icons.arrow_downward_rounded, label: 'الإيراد', value: report.income.toStringAsFixed(0)),
              _AttendanceInfoChip(icon: Icons.arrow_upward_rounded, label: 'المصروفات', value: report.expenses.toStringAsFixed(0)),
              _AttendanceInfoChip(icon: Icons.savings_outlined, label: 'الربح', value: report.profit.toStringAsFixed(0)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: margin.clamp(0.0, 1.0).toDouble(),
              minHeight: 9,
              color: color,
              backgroundColor: const Color(0xFFD9E6E2),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            healthy ? 'هذا التقرير يظهر ربحية جيدة ويمكن البناء عليه في تطوير النشاط.' : 'هذا التقرير يحتاج مراجعة المصروفات أو تحسين العائد لرفع الربحية.',
            style: const TextStyle(color: Color(0xFF667B75), height: 1.5),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _QuickAction(label: 'اعتماد', icon: Icons.fact_check_rounded),
              _QuickAction(label: 'مراجعة', icon: Icons.visibility_outlined),
              _QuickAction(label: 'تصدير', icon: Icons.file_download_outlined),
              _QuickAction(label: 'مقارنة', icon: Icons.compare_arrows_rounded),
            ],
          ),
        ],
      ),
    );
  }
}

class SimpleTile extends StatelessWidget {
  const SimpleTile({super.key, required this.title, required this.subtitle, required this.trailing, this.accent = const Color(0xFF0F766E)});

  final String title;
  final String subtitle;
  final String trailing;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFF7FAF9), borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: accent, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Color(0xFF667B75), height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(trailing, style: TextStyle(color: accent, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}















