part of 'dashboard_sections.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'الإعدادات',
      subtitle: 'مركز تحكم كامل لإعدادات العرض والتشغيل والتنبيهات داخل الداشبورد.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _AttendanceStatCard(title: 'وضع العرض', value: 'إداري', note: 'واجهة مخصصة للإدارة', color: Color(0xFF0F766E), icon: Icons.dashboard_customize_rounded),
              _AttendanceStatCard(title: 'التحديث اللحظي', value: '5 ث', note: 'تحديث تلقائي للبيانات', color: Color(0xFF2563EB), icon: Icons.sync_rounded),
              _AttendanceStatCard(title: 'التنبيهات', value: 'مفعلة', note: 'تشغيل التنبيهات الذكية', color: Color(0xFF16A34A), icon: Icons.notifications_active_rounded),
              _AttendanceStatCard(title: 'الأمان', value: 'مرتفع', note: 'حماية الوصول والتعديلات', color: Color(0xFFF59E0B), icon: Icons.admin_panel_settings_rounded),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAF9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('إعدادات العرض في الداشبورد', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text('هذا الجزء يتحكم في شكل عرض البيانات، ترتيب البطاقات، أسلوب الجرافيك، وكثافة التفاصيل التي تظهر للإدارة داخل الشاشة.', style: TextStyle(color: Color(0xFF667B75), height: 1.6)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: const [
                    _QuickAction(label: 'حفظ الإعدادات', icon: Icons.save_outlined),
                    _QuickAction(label: 'إعادة الضبط', icon: Icons.restart_alt_rounded),
                    _QuickAction(label: 'تخصيص الكروت', icon: Icons.view_quilt_outlined),
                    _QuickAction(label: 'إعدادات الجرافيك', icon: Icons.bar_chart_rounded),
                    _QuickAction(label: 'ترتيب الأقسام', icon: Icons.widgets_outlined),
                    _QuickAction(label: 'تصدير الإعدادات', icon: Icons.file_download_outlined),
                  ],
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: const [
                    _SettingsFeatureCard(title: 'نمط عرض احترافي', description: 'اختيار واجهة إدارية تفصيلية أو واجهة مختصرة للمتابعة السريعة حسب احتياج المدير.'),
                    _SettingsFeatureCard(title: 'التحكم في الكروت', description: 'إظهار أو إخفاء بطاقات المؤشرات المهمة مثل الأرباح، الجرد، المهام، والحضور.'),
                    _SettingsFeatureCard(title: 'تخصيص الجرافيك', description: 'تحديد نوع الرسوم، كثافة البيانات، وألوان العرض لتناسب نمط الإدارة.'),
                    _SettingsFeatureCard(title: 'ترتيب الداشبورد', description: 'التحكم في ترتيب الأقسام وظهور أهم الوحدات في البداية داخل الشاشة الرئيسية.'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const SectionCard(
            title: 'إعدادات العرض التفصيلية',
            subtitle: 'خيارات تؤثر مباشرة على شكل الداشبورد وطريقة عرض المعلومات.',
            child: Column(
              children: [
                SettingRow(title: 'نمط عرض النتائج اليومية', value: 'تفصيلي'),
                SettingRow(title: 'طريقة عرض الكروت الرئيسية', value: 'تفاعلية'),
                SettingRow(title: 'حجم الجرافيك في الأقسام', value: 'كبير'),
                SettingRow(title: 'عدد الوحدات الظاهرة في الهوم', value: '6 وحدات'),
                SettingRow(title: 'ترتيب العرض الافتراضي', value: 'الأولوية للتشغيل'),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const SectionCard(
            title: 'إعدادات التشغيل والمتابعة',
            subtitle: 'إعدادات مرتبطة بتحديث البيانات والتنبيهات وإدارة المستخدمين.',
            child: Column(
              children: [
                SettingRow(title: 'تفعيل التنبيهات الذكية', value: 'مفعلة'),
                SettingRow(title: 'سرعة تحديث البيانات', value: 'كل 5 ثواني'),
                SettingRow(title: 'صلاحيات تعديل المستخدمين', value: 'مدير فقط'),
                SettingRow(title: 'مراجعة الجرد الحرج', value: 'كل 12 ساعة'),
                SettingRow(title: 'اعتماد التقارير المالية', value: 'يدوي مع مراجعة'),
                SettingRow(title: 'متابعة المهام المتأخرة', value: 'مفعلة تلقائيًا'),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const SectionCard(
            title: 'إعدادات إدارية متقدمة',
            subtitle: 'خيارات تناسب الإدارة عند تخصيص تجربة العمل داخل النظام.',
            child: Column(
              children: [
                OverviewLine(title: 'تخصيص ما يظهر في الهوم', description: 'اختيار الوحدات التي تظهر أولًا مثل الأرباح أو الحضور أو الجرد حسب الأولوية.'),
                OverviewLine(title: 'التحكم في كثافة المعلومات', description: 'عرض مختصر أو موسع للبيانات داخل الأقسام حتى تناسب نوع المتابعة اليومية.'),
                OverviewLine(title: 'تثبيت أسلوب الجرافيك', description: 'يمكن اعتماد نمط جرافيكي موحد للإدارة لتسهيل قراءة الأرقام بسرعة.'),
                OverviewLine(title: 'إعدادات الأمان والمراجعة', description: 'ضبط من يمكنه التعديل، من يعتمد، ومن يطّلع على التقارير التنفيذية.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsFeatureCard extends StatelessWidget {
  const _SettingsFeatureCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2ECE8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0x142563EB),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.settings_suggest_rounded, color: Color(0xFF2563EB)),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 8),
          Text(description, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
        ],
      ),
    );
  }
}
