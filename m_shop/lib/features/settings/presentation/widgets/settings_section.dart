import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/application/dashboard_store.dart';
import 'package:m_shop/features/dashboard/presentation/dashboard_vm.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key, required this.vm});

  final DashboardVm vm;

  @override
  Widget build(BuildContext context) {
    final owner = vm.users.isNotEmpty ? vm.users.first : null;
    final permissions = [
      _PermissionItem(
        permission: SystemPermission.notifications,
        title: 'الإشعارات',
        subtitle: 'تنبيهات التشغيل والغياب والتنبيهات الحرجة.',
        value: vm.notificationsEnabled,
        icon: Icons.notifications_active_rounded,
      ),
      _PermissionItem(
        permission: SystemPermission.storage,
        title: 'التخزين والنسخ',
        subtitle: 'حفظ التقارير والنسخ الاحتياطي والتصدير.',
        value: vm.storagePermissionEnabled,
        icon: Icons.sd_storage_rounded,
      ),
      _PermissionItem(
        permission: SystemPermission.camera,
        title: 'الكاميرا والماسح',
        subtitle: 'تصوير الفواتير ومسح الأكواد ومتابعة التشغيل.',
        value: vm.cameraPermissionEnabled,
        icon: Icons.qr_code_scanner_rounded,
      ),
      _PermissionItem(
        permission: SystemPermission.reports,
        title: 'تقارير النظام',
        subtitle: 'الوصول لتقارير الإدارة والتصدير المالي.',
        value: vm.reportsPermissionEnabled,
        icon: Icons.admin_panel_settings_rounded,
      ),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SectionCard(
        title: 'الإعدادات والصلاحيات',
        subtitle: 'لوحة إعدادات كاملة ومنظمة للتحكم في الثيم وحجم النص وصلاحيات النظام.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SettingsHero(
              role: owner?.role ?? 'Manager',
              themePreference: vm.themePreference,
              textScale: vm.textScale,
              enabledPermissions: permissions.where((item) => item.value).length,
            ),
            const SizedBox(height: 20),
            _SettingsBlock(
              title: 'الثيم',
              subtitle: 'اختيار شكل النظام بين الوضع الفاتح والوضع الداكن.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _ThemeChoiceCard(
                    title: 'Light Theme',
                    subtitle: 'واجهة فاتحة واضحة ومريحة للعرض اليومي.',
                    selected: vm.themePreference == AppThemePreference.light,
                    accent: const Color(0xFF0F766E),
                    icon: Icons.light_mode_rounded,
                    onTap: () => vm.setThemePreference(AppThemePreference.light),
                  ),
                  _ThemeChoiceCard(
                    title: 'Dark Theme',
                    subtitle: 'واجهة داكنة أنيقة مناسبة للاستخدام الليلي.',
                    selected: vm.themePreference == AppThemePreference.dark,
                    accent: const Color(0xFF123A67),
                    icon: Icons.dark_mode_rounded,
                    onTap: () => vm.setThemePreference(AppThemePreference.dark),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SettingsBlock(
              title: 'حجم النص',
              subtitle: 'تكبير أو تصغير النص على مستوى النظام بالكامل.',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _TextScaleCard(
                    title: 'صغير',
                    sample: 'Aa',
                    selected: vm.textScale == AppTextScale.compact,
                    onTap: () => vm.setTextScale(AppTextScale.compact),
                  ),
                  _TextScaleCard(
                    title: 'متوسط',
                    sample: 'Aa',
                    selected: vm.textScale == AppTextScale.normal,
                    onTap: () => vm.setTextScale(AppTextScale.normal),
                  ),
                  _TextScaleCard(
                    title: 'كبير',
                    sample: 'Aa',
                    selected: vm.textScale == AppTextScale.large,
                    onTap: () => vm.setTextScale(AppTextScale.large),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SettingsBlock(
              title: 'صلاحيات النظام',
              subtitle: 'التحكم في الصلاحيات الأساسية التي يعتمد عليها تشغيل النظام.',
              child: Column(
                children: permissions
                    .map(
                      (item) => _PermissionTile(
                        item: item,
                        onChanged: (_) => vm.togglePermission(item.permission),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            _SettingsBlock(
              title: 'قراءة الصلاحيات الإدارية',
              subtitle: 'ملخص سريع لما يتيحه هذا الحساب داخل النظام.',
              child: Column(
                children: [
                  _SummaryLine(title: 'الدور الحالي', value: owner?.role ?? 'Manager'),
                  _SummaryLine(title: 'الوصول للوحة التحكم', value: 'مفعل'),
                  _SummaryLine(title: 'إدارة الماليات والتقارير', value: vm.reportsPermissionEnabled ? 'مفعل' : 'محدود'),
                  _SummaryLine(title: 'النسخ والتخزين', value: vm.storagePermissionEnabled ? 'مفعل' : 'متوقف'),
                  _SummaryLine(title: 'التنبيهات الفورية', value: vm.notificationsEnabled ? 'مفعلة' : 'متوقفة'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsHero extends StatelessWidget {
  const _SettingsHero({
    required this.role,
    required this.themePreference,
    required this.textScale,
    required this.enabledPermissions,
  });

  final String role;
  final AppThemePreference themePreference;
  final AppTextScale textScale;
  final int enabledPermissions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF0B1320), Color(0xFF123A67), Color(0xFF0F766E)],
        ),
      ),
      child: Wrap(
        spacing: 18,
        runSpacing: 18,
        alignment: WrapAlignment.spaceBetween,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _HeroPill(label: 'إعدادات النظام'),
                const SizedBox(height: 16),
                const Text(
                  'تحكم كامل في واجهة النظام والصلاحيات',
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, height: 1.15),
                ),
                const SizedBox(height: 12),
                const Text(
                  'من هنا تقدر تبدل الثيم بين الفاتح والداكن، تضبط حجم النص، وتراجع صلاحيات النظام الأساسية بصورة منظمة وواضحة.',
                  style: TextStyle(color: Color(0xE7FFFFFF), height: 1.7),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _HeroMetric(label: 'الدور', value: role),
              _HeroMetric(label: 'الثيم', value: themePreference == AppThemePreference.light ? 'فاتح' : 'داكن'),
              _HeroMetric(label: 'النص', value: _textScaleLabel(textScale)),
              _HeroMetric(label: 'الصلاحيات', value: '$enabledPermissions / 4'),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsBlock extends StatelessWidget {
  const _SettingsBlock({required this.title, required this.subtitle, required this.child});

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _ThemeChoiceCard extends StatelessWidget {
  const _ThemeChoiceCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.accent,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final Color accent;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected ? accent.withValues(alpha: 0.10) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: selected ? accent : const Color(0xFFE2ECE8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
                  child: Icon(icon, color: accent),
                ),
                const Spacer(),
                Icon(selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: accent),
              ],
            ),
            const SizedBox(height: 14),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            const SizedBox(height: 6),
            Text(subtitle, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
          ],
        ),
      ),
    );
  }
}

class _TextScaleCard extends StatelessWidget {
  const _TextScaleCard({required this.title, required this.sample, required this.selected, required this.onTap});

  final String title;
  final String sample;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = const Color(0xFF0F766E);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 168,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? accent.withValues(alpha: 0.10) : theme.cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: selected ? accent : theme.dividerColor.withValues(alpha: 0.45)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(
              sample,
              style: TextStyle(
                fontSize: title == 'كبير' ? 24 : title == 'متوسط' ? 20 : 17,
                fontWeight: FontWeight.w900,
                color: accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({required this.item, required this.onChanged});

  final _PermissionItem item;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? theme.colorScheme.surface.withValues(alpha: 0.72)
            : const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: const Color(0x140F766E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: const Color(0xFF0F766E), size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Switch(value: item.value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark
              ? theme.colorScheme.surface.withValues(alpha: 0.72)
              : const Color(0xFFF7FAF9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            Text(value, style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.label, required this.value});

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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xD8FFFFFF), fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
        ],
      ),
    );
  }
}

class _PermissionItem {
  const _PermissionItem({
    required this.permission,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
  });

  final SystemPermission permission;
  final String title;
  final String subtitle;
  final bool value;
  final IconData icon;
}

String _textScaleLabel(AppTextScale scale) {
  switch (scale) {
    case AppTextScale.compact:
      return 'صغير';
    case AppTextScale.large:
      return 'كبير';
    case AppTextScale.normal:
      return 'متوسط';
  }
}

