part of 'dashboard_sections.dart';

class ProductivitySection extends StatelessWidget {
  const ProductivitySection({super.key, required this.production});

  final List<ProductionPoint> production;

  @override
  Widget build(BuildContext context) {
    final totalActual = production.fold<double>(0, (sum, item) => sum + item.actual);
    final totalTarget = production.fold<double>(0, (sum, item) => sum + item.target);
    final efficiency = totalTarget == 0 ? 0.0 : totalActual / totalTarget;
    final variance = totalActual - totalTarget;
    final bestDay = production.isEmpty
        ? null
        : production.reduce((a, b) => a.actual >= b.actual ? a : b);

    return Column(
      children: [
        SectionCard(
          title: 'الإنتاجية وتشغيل المصنع',
          subtitle: 'لوحة مدير الإنتاج لمتابعة الأداء، التحكم في القرارات التشغيلية، وتحسين المخرجات اليومية.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _AttendanceStatCard(title: 'الإنتاج الفعلي', value: totalActual.round().toString(), note: 'إجمالي المنفذ خلال الفترة', color: const Color(0xFF0F766E), icon: Icons.factory_rounded),
                  _AttendanceStatCard(title: 'المستهدف', value: totalTarget.round().toString(), note: 'الخطة التشغيلية المعتمدة', color: const Color(0xFF2563EB), icon: Icons.flag_circle_rounded),
                  _AttendanceStatCard(title: 'الكفاءة', value: '${(efficiency * 100).round()}%', note: 'نسبة الإنجاز مقابل المستهدف', color: const Color(0xFFF59E0B), icon: Icons.insights_rounded),
                  _AttendanceStatCard(title: 'الفارق', value: variance.round().toString(), note: variance >= 0 ? 'أعلى من الخطة' : 'أقل من المستهدف', color: variance >= 0 ? const Color(0xFF16A34A) : const Color(0xFFDC2626), icon: Icons.show_chart_rounded),
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
                    const Text('مركز صلاحيات مدير الإنتاج', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    const Text('من هنا يقدر المدير يراجع الخطة، يعدل المستهدف، يرفع الطاقة التشغيلية، ينسق مع الصيانة، ويراقب جودة التنفيذ.', style: TextStyle(color: Color(0xFF667B75), height: 1.6)),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        _QuickAction(label: 'تعديل المستهدف', icon: Icons.edit_note_rounded),
                        _QuickAction(label: 'إضافة خطة إنتاج', icon: Icons.playlist_add_circle_outlined),
                        _QuickAction(label: 'اعتماد التشغيل', icon: Icons.verified_outlined),
                        _QuickAction(label: 'طلب صيانة', icon: Icons.build_circle_outlined),
                        _QuickAction(label: 'إرسال تنبيه للفريق', icon: Icons.campaign_outlined),
                        _QuickAction(label: 'تصدير تقرير الإنتاج', icon: Icons.file_download_outlined),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _ProductivityAdminPanel(title: 'إدارة الخطة اليومية', description: 'إضافة خطة تشغيل، تعديل الكميات المستهدفة، وإعادة توزيع الأولويات حسب ضغط الطلب.'),
                        _ProductivityAdminPanel(title: 'رفع كفاءة التشغيل', description: 'متابعة الأداء الفعلي، تقليل الفاقد، وتحريك الفرق نحو الخطوط الأضعف إنتاجًا.'),
                        _ProductivityAdminPanel(title: 'التنسيق مع الصيانة والجودة', description: 'إيقاف خط، طلب فحص، أو تصعيد جودة عند ظهور انخفاض أو تفاوت غير طبيعي.'),
                        _ProductivityAdminPanel(title: 'المراقبة واتخاذ القرار', description: bestDay == null ? 'لا توجد بيانات كافية حاليًا.' : 'أفضل يوم إنتاج كان ${bestDay.label} ويمكن البناء عليه في التخطيط القادم.'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const SectionCard(
                title: 'ماذا يستطيع المدير فعله هنا؟',
                subtitle: 'أهم الصلاحيات والمهام التي يحتاجها المصنع داخل قسم الإنتاجية.',
                child: Column(
                  children: [
                    OverviewLine(title: 'تعديل المستهدف الإنتاجي', description: 'تحديث الخطة اليومية أو الأسبوعية حسب الطلبات والطاقة المتاحة في المصنع.'),
                    OverviewLine(title: 'متابعة الأداء الفعلي لحظيًا', description: 'مقارنة التنفيذ بالمستهدف واكتشاف الانخفاض أو التحسن بسرعة.'),
                    OverviewLine(title: 'إصدار قرارات تشغيلية', description: 'رفع الوتيرة، إعادة توزيع العمال، أو تحويل العمل إلى خط أكثر كفاءة.'),
                    OverviewLine(title: 'طلب صيانة أو تدخل جودة', description: 'عند تراجع الأداء أو ظهور تفاوت في النتائج يمكن تصعيد الإجراء فورًا.'),
                    OverviewLine(title: 'استخراج تقارير للإدارة', description: 'تصدير ملخص يوضح الكفاءة والفارق وأفضل الأيام وأسوأها للمراجعة السريعة.'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        ProductionChartCard(data: production),
      ],
    );
  }
}

class _ProductivityAdminPanel extends StatelessWidget {
  const _ProductivityAdminPanel({required this.title, required this.description});

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
            color: const Color(0xFF0F766E).withValues(alpha: 0.05),
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
              color: const Color(0x140F766E),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.precision_manufacturing_rounded, color: Color(0xFF0F766E)),
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

