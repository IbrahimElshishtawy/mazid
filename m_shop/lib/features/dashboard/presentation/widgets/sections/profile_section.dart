part of 'dashboard_sections.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key, required this.user, required this.users});

  final UserModel user;
  final List<UserModel> users;

  @override
  Widget build(BuildContext context) {
    final activeUsers = users.where((item) => item.status == 'نشط' || item.status == 'في الوردية').length;
    final managers = users.where((item) => item.role == 'Manager').length;
    final workers = users.where((item) => item.role == 'Worker').length;
    const availableBalance = 184500.0;
    const monthlyIncome = 615000.0;
    const monthlyExpenses = 446000.0;
    final losses = (monthlyExpenses * 0.09).roundToDouble();
    final netProfit = monthlyIncome - monthlyExpenses;

    return Column(
      children: [
        SectionCard(
          title: 'البروفايل الإداري',
          subtitle: 'لوحة مدير تنفيذية تشمل الهوية، الماليات، الخسائر، وخطط التطوير.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileHeader(user: user),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _ProfileBadge(title: 'الدور', value: user.role, color: const Color(0xFF0F766E)),
                  _ProfileBadge(title: 'الحالة', value: user.status, color: const Color(0xFF2563EB)),
                  _ProfileBadge(title: 'مستخدمون نشطون', value: '$activeUsers', color: const Color(0xFF059669)),
                  _ProfileBadge(title: 'عمال تحت المتابعة', value: '$workers', color: const Color(0xFFF59E0B)),
                  _ProfileBadge(title: 'المديرون', value: '$managers', color: const Color(0xFF7C3AED)),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xFF0F766E), Color(0xFF134E4A), Color(0xFF111827)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('الرصيد التشغيلي المتاح', style: TextStyle(color: Color(0xD7FFFFFF), fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text('${availableBalance.toStringAsFixed(0)} جنيه', style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 12),
                    const Text('يغطي مصاريف تشغيلية قصيرة المدى ويعطي الإدارة مرونة في المناورة واتخاذ القرار.', style: TextStyle(color: Color(0xD7FFFFFF), height: 1.6)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _FinanceHighlight(label: 'صافي الربح', value: '${netProfit.toStringAsFixed(0)}', color: const Color(0xFF6EE7B7))),
                        const SizedBox(width: 12),
                        Expanded(child: _FinanceHighlight(label: 'الخسائر المقدرة', value: '${losses.toStringAsFixed(0)}', color: const Color(0xFFFCA5A5))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _FinanceInfoCard(title: 'إيرادات شهرية', value: '${monthlyIncome.toStringAsFixed(0)} جنيه', note: 'أداء جيد مقابل الخطة', accent: const Color(0xFF0F766E)),
                  _FinanceInfoCard(title: 'مصروفات شهرية', value: '${monthlyExpenses.toStringAsFixed(0)} جنيه', note: 'تشمل التشغيل والرواتب', accent: const Color(0xFFF59E0B)),
                  _FinanceInfoCard(title: 'الخسائر التشغيلية', value: '${losses.toStringAsFixed(0)} جنيه', note: 'ناتجة عن هدر وتأخير جزئي', accent: const Color(0xFFDC2626)),
                ],
              ),
              const SizedBox(height: 18),
              SectionCard(
                title: 'تعديل معلومات الإدارة',
                subtitle: 'واجهة سريعة لتحديث المعلومات الأساسية للحساب الإداري.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _AdminEditField(label: 'الاسم الإداري', value: 'تحديث اسم الحساب أو المسمى الوظيفي'),
                    const SizedBox(height: 12),
                    _AdminEditField(label: 'البريد الإلكتروني', value: user.email),
                    const SizedBox(height: 12),
                    const _AdminEditField(label: 'رقم الهاتف', value: '+20 109 555 8201'),
                    const SizedBox(height: 12),
                    const _AdminEditField(label: 'الوصف الإداري', value: 'مدير مسؤول عن التشغيل، النتائج، الجرد، والملفات المالية'),
                    const SizedBox(height: 14),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.save_outlined), label: const Text('حفظ التعديلات')),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SectionCard(
                title: 'معلومات الإدارة الأساسية',
                subtitle: 'بيانات الاتصال والوصول والمسؤوليات التنفيذية.',
                child: Column(
                  children: [
                    SimpleTile(title: 'البريد الإلكتروني', subtitle: user.email, trailing: 'موثق'),
                    const SimpleTile(title: 'رقم الهاتف', subtitle: '+20 109 555 8201', trailing: 'متاح'),
                    const SimpleTile(title: 'الصلاحيات', subtitle: 'إدارة المستخدمين، النتائج، الجرد، الأرباح', trailing: 'كاملة'),
                    const SimpleTile(title: 'نطاق المراقبة', subtitle: 'تشغيل، مستخدمون، أداء مالي، ومخزون', trailing: 'شامل'),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const SectionCard(
                title: 'خطط استراتيجية للتطوير',
                subtitle: 'خطوات عملية مقترحة لتقليل الخسائر وتحسين الربحية والنمو.',
                child: Column(
                  children: [
                    _StrategyTile(title: 'تقليل الفاقد التشغيلي', description: 'إعادة ضبط نقاط الهدر في خطوط التعبئة وتقليل التوقفات القصيرة.'),
                    _StrategyTile(title: 'رفع كفاءة المستخدمين', description: 'تدريب المشرفين والعمال على التنفيذ الأسرع ومراقبة الأخطاء بشكل يومي.'),
                    _StrategyTile(title: 'تحسين القرار المالي', description: 'مراجعة المصروفات عالية الأثر وربطها بالعائد الفعلي على التشغيل.'),
                    _StrategyTile(title: 'تنشيط الرقابة على الجرد', description: 'إنشاء دورة مراجعة أسرع للعناصر الحرجة لتقليل نفاد المخزون المفاجئ.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FinanceHighlight extends StatelessWidget {
  const _FinanceHighlight({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Expanded(child: Text(label, style: const TextStyle(color: Color(0xD7FFFFFF), fontWeight: FontWeight.w700))),
            ],
          ),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: color == const Color(0xFFFCA5A5) ? 0.28 : 0.72,
              minHeight: 6,
              color: color,
              backgroundColor: Colors.white.withValues(alpha: 0.12),
            ),
          ),
        ],
      ),
    );
  }
}

class _FinanceInfoCard extends StatelessWidget {
  const _FinanceInfoCard({required this.title, required this.value, required this.note, required this.accent});

  final String title;
  final String value;
  final String note;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.account_balance_wallet_outlined, color: accent),
          ),
          const SizedBox(height: 14),
          Text(title, style: TextStyle(color: accent, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Text(note, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: accent == const Color(0xFFDC2626) ? 0.22 : accent == const Color(0xFFF59E0B) ? 0.64 : 0.82,
              minHeight: 7,
              color: accent,
              backgroundColor: const Color(0xFFE6EFEC),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminEditField extends StatelessWidget {
  const _AdminEditField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAF9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2ECE8)),
          ),
          child: Row(
            children: [
              const Icon(Icons.edit_note_rounded, color: Color(0xFF0F766E), size: 18),
              const SizedBox(width: 10),
              Expanded(child: Text(value, style: const TextStyle(color: Color(0xFF667B75), height: 1.4))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0x140F766E),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text('قابل للتعديل', style: TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.w800, fontSize: 12)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StrategyTile extends StatelessWidget {
  const _StrategyTile({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFF7FAF9), Color(0xFFF0F7F5)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2ECE8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF0F766E), Color(0xFF14B8A6)]),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.trending_up_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0x140F766E), borderRadius: BorderRadius.circular(999)),
                      child: const Text('أولوية عالية', style: TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.w800, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(description, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileBadge extends StatelessWidget {
  const _ProfileBadge({required this.title, required this.value, required this.color});

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 182,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 36, height: 4, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999))),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
