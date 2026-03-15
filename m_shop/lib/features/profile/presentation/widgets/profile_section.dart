import 'package:flutter/material.dart';
import 'package:m_shop/core/widgets/section_card.dart';
import 'package:m_shop/features/dashboard/domain/models/dashboard_models.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key, required this.user, required this.users});

  final UserModel user;
  final List<UserModel> users;

  @override
  Widget build(BuildContext context) {
    final activeUsers = users
        .where((item) => item.status == 'نشط' || item.status == 'قيد العمل')
        .length;
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
          title: 'الملف الشخصي',
          subtitle: 'عرض شامل لبيانات المستخدم والملخص المالي والمؤشرات التشغيلية.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileHeader(user: user),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ProfileBadge(title: 'الدور', value: user.role, color: const Color(0xFF0F766E)),
                  ProfileBadge(title: 'الحالة', value: user.status, color: const Color(0xFF2563EB)),
                  ProfileBadge(title: 'المستخدمون النشطون', value: '$activeUsers', color: const Color(0xFF059669)),
                  ProfileBadge(title: 'عدد العمال', value: '$workers', color: const Color(0xFFF59E0B)),
                  ProfileBadge(title: 'المديرون', value: '$managers', color: const Color(0xFF7C3AED)),
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
                    const Text(
                      'المحفظة المالية الحالية',
                      style: TextStyle(color: Color(0xD7FFFFFF), fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${availableBalance.toStringAsFixed(0)} جنيه',
                      style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'نظرة سريعة على الأداء المالي وربحية التشغيل والخسائر الشهرية المتوقعة.',
                      style: TextStyle(color: Color(0xD7FFFFFF), height: 1.6),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: FinanceHighlight(
                            label: 'صافي الربح',
                            value: netProfit.toStringAsFixed(0),
                            color: const Color(0xFF6EE7B7),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FinanceHighlight(
                            label: 'الخسائر الشهرية',
                            value: losses.toStringAsFixed(0),
                            color: const Color(0xFFFCA5A5),
                          ),
                        ),
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
                  FinanceInfoCard(
                    title: 'الإيراد الشهري',
                    value: '${monthlyIncome.toStringAsFixed(0)} جنيه',
                    note: 'أعلى من متوسط الشهر الماضي',
                    accent: const Color(0xFF0F766E),
                  ),
                  FinanceInfoCard(
                    title: 'المصروف الشهري',
                    value: '${monthlyExpenses.toStringAsFixed(0)} جنيه',
                    note: 'يشمل الرواتب والمشتريات',
                    accent: const Color(0xFFF59E0B),
                  ),
                  FinanceInfoCard(
                    title: 'الخسائر التقديرية',
                    value: '${losses.toStringAsFixed(0)} جنيه',
                    note: 'نسبة من إجمالي المصروفات',
                    accent: const Color(0xFFDC2626),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SectionCard(
                title: 'بيانات المستخدم الأساسية',
                subtitle: 'حقول قابلة للمراجعة والتحديث من لوحة الإدارة.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AdminEditField(label: 'اسم المستخدم', value: 'موظف إداري في المنظومة الحالية'),
                    const SizedBox(height: 12),
                    AdminEditField(label: 'البريد الإلكتروني', value: user.email),
                    const SizedBox(height: 12),
                    const AdminEditField(label: 'رقم الهاتف', value: '+20 109 555 8201'),
                    const SizedBox(height: 12),
                    const AdminEditField(label: 'العنوان الوظيفي', value: 'قسم الدعم مع مسؤولية متابعة التقارير اليومية'),
                    const SizedBox(height: 14),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('حفظ التعديلات'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SectionCard(
                title: 'قنوات التواصل المباشرة',
                subtitle: 'بيانات تواصل سريعة ومعلومات الوصول الداخلية.',
                child: Column(
                  children: [
                    SimpleTile(title: 'البريد الإلكتروني', subtitle: user.email, trailing: 'أساسي'),
                    const SimpleTile(title: 'رقم الهاتف', subtitle: '+20 109 555 8201', trailing: 'مفعل'),
                    const SimpleTile(title: 'القسم', subtitle: 'إدارة المتابعة والعمليات اليومية', trailing: 'تشغيلي'),
                    const SimpleTile(title: 'آخر تحديث', subtitle: 'تمت المراجعة منذ يومين', trailing: 'حديث'),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const SectionCard(
                title: 'خطط التحسين المقترحة',
                subtitle: 'مجموعة توجهات عملية لتطوير الأداء الفردي ورفع الكفاءة.',
                child: Column(
                  children: [
                    StrategyTile(
                      title: 'مراجعة الأولويات التشغيلية',
                      description: 'تنظيم أولويات العمل كل صباح قبل بدء المهام اليومية الأساسية.',
                    ),
                    StrategyTile(
                      title: 'رفع جودة المتابعة',
                      description: 'تحديث التقارير بصورة أدق وربطها بنتائج التنفيذ الفعلية داخل الفريق.',
                    ),
                    StrategyTile(
                      title: 'تحسين إدارة الوقت',
                      description: 'تقسيم الأعمال الثقيلة على فترات قصيرة مع نقاط مراجعة واضحة.',
                    ),
                    StrategyTile(
                      title: 'تفعيل التواصل بين الفرق',
                      description: 'مشاركة المستجدات المهمة بسرعة لتقليل التأخير وتحسين التنسيق.',
                    ),
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
                  children: const [
                    BadgeChip(label: 'ملف نشط', fg: Colors.white, bg: Colors.white12),
                    BadgeChip(label: 'قابل للتعديل', fg: Color(0xFFBBF7D0), bg: Color(0x2FBBF7D0)),
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
                label: const Text('عرض'),
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

class BadgeChip extends StatelessWidget {
  const BadgeChip({super.key, required this.label, required this.fg, required this.bg});

  final String label;
  final Color fg;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: TextStyle(color: fg, fontWeight: FontWeight.w800, fontSize: 12)),
    );
  }
}

class ProfileBadge extends StatelessWidget {
  const ProfileBadge({super.key, required this.title, required this.value, required this.color});

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

class FinanceHighlight extends StatelessWidget {
  const FinanceHighlight({super.key, required this.label, required this.value, required this.color});

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

class FinanceInfoCard extends StatelessWidget {
  const FinanceInfoCard({super.key, required this.title, required this.value, required this.note, required this.accent});

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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: accent.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(14)),
            child: Icon(Icons.account_balance_wallet_outlined, color: accent),
          ),
          const SizedBox(height: 14),
          Text(title, style: TextStyle(color: accent, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          Text(note, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
        ],
      ),
    );
  }
}

class AdminEditField extends StatelessWidget {
  const AdminEditField({super.key, required this.label, required this.value});

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
                decoration: BoxDecoration(color: const Color(0x140F766E), borderRadius: BorderRadius.circular(999)),
                child: const Text('قابل للتعديل', style: TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.w800, fontSize: 12)),
              ),
            ],
          ),
        ),
      ],
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

class StrategyTile extends StatelessWidget {
  const StrategyTile({super.key, required this.title, required this.description});

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
