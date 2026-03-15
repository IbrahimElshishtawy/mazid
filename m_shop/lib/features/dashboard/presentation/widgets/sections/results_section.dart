part of 'dashboard_sections.dart';

class ResultsSection extends StatelessWidget {
  const ResultsSection({super.key, required this.production, required this.tasks});

  final List<ProductionPoint> production;
  final List<TaskModel> tasks;

  @override
  Widget build(BuildContext context) {
    final totalProduction = production.fold<double>(0, (sum, item) => sum + item.actual);
    final totalTarget = production.fold<double>(0, (sum, item) => sum + item.target);
    final completion = totalTarget == 0 ? 0.0 : totalProduction / totalTarget;
    final averageTaskCompletion = tasks.isEmpty ? 0.0 : tasks.fold<double>(0, (sum, task) => sum + task.progress) / tasks.length;
    final completedTasks = tasks.where((task) => task.progress >= 1).length;
    final delayedTasks = tasks.where((task) => task.status.contains('تأ') || task.progress < 0.4).length;
    final strongResult = completion >= 0.9;
    final resultMessage = strongResult
        ? 'النتائج الحالية قوية وتوضح استقرارًا جيدًا في التنفيذ مع فرصة لرفع المستهدف تدريجيًا.'
        : 'النتائج مقبولة لكن تحتاج متابعة أوضح للمهام الضعيفة وتحسين التوافق بين الخطة والتنفيذ.';

    return SectionCard(
      title: 'نتائج الشغل',
      subtitle: 'لوحة واقعية تساعد الإدارة على فهم النتائج والاستفادة منها في القرار اليومي.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _AttendanceStatCard(title: 'الإنتاج الفعلي', value: '${totalProduction.round()}', note: 'ما تم تنفيذه فعليًا', color: const Color(0xFF0F766E), icon: Icons.factory_rounded),
              _AttendanceStatCard(title: 'المستهدف', value: '${totalTarget.round()}', note: 'الخطة الموضوعة للفترة', color: const Color(0xFF2563EB), icon: Icons.flag_circle_rounded),
              _AttendanceStatCard(title: 'إنجاز المهام', value: '${(averageTaskCompletion * 100).round()}%', note: 'متوسط التنفيذ العام', color: const Color(0xFFF59E0B), icon: Icons.assignment_turned_in_rounded),
              _AttendanceStatCard(title: 'المهام المتأخرة', value: '$delayedTasks', note: 'تحتاج تدخل مباشر', color: const Color(0xFFDC2626), icon: Icons.warning_amber_rounded),
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'تقييم النتائج الحالية',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: (strongResult ? const Color(0xFF16A34A) : const Color(0xFFF59E0B)).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        strongResult ? 'نتيجة قوية' : 'تحتاج تحسين',
                        style: TextStyle(
                          color: strongResult ? const Color(0xFF16A34A) : const Color(0xFFF59E0B),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(resultMessage, style: const TextStyle(color: Color(0xFF667B75), height: 1.6)),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: completion.clamp(0.0, 1.0).toDouble(),
                    minHeight: 12,
                    color: strongResult ? const Color(0xFF16A34A) : const Color(0xFF0F766E),
                    backgroundColor: const Color(0xFFD9E6E2),
                  ),
                ),
                const SizedBox(height: 8),
                Text('تحقيق الخطة: ${(completion * 100).round()}% من المستهدف', style: const TextStyle(color: Color(0xFF506662), fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _ResultsBenefitCard(title: 'كيف تستفيد من النتائج؟', description: 'تحديد الخطوط القوية والضعيفة، ثم إعادة توزيع الجهد والموارد حسب الأداء الفعلي.'),
              _ResultsBenefitCard(title: 'ما الذي يحتاج تدخل؟', description: 'أي انخفاض عن المستهدف أو زيادة في المهام المتأخرة يعتبر إشارة لقرار إداري سريع.'),
              _ResultsBenefitCard(title: 'كيف تستخدمها في الإدارة؟', description: 'اعرضها في الاجتماع اليومي لتوضيح الإنجاز، العوائق، والإجراءات المطلوبة للفترة التالية.'),
            ],
          ),
          const SizedBox(height: 18),
          const SectionCard(
            title: 'استخدامات فعلية لميزة نتائج الشغل',
            subtitle: 'المعلومات هنا ليست للعرض فقط، بل لاتخاذ قرار ومتابعة حقيقية.',
            child: Column(
              children: [
                OverviewLine(title: 'مقارنة الفعلي بالمستهدف', description: 'تساعدك على معرفة هل المصنع يتحرك حسب الخطة أم يحتاج تعديل سريع.'),
                OverviewLine(title: 'مراجعة جودة التنفيذ', description: 'متوسط إنجاز المهام يكشف إن كان التنفيذ منظمًا أم أن هناك تعطلاً في المتابعة.'),
                OverviewLine(title: 'تحديد نقاط الضعف', description: 'عدد المهام المتأخرة أو انخفاض النسبة النهائية يكشف مناطق تحتاج تدخل مباشر.'),
                OverviewLine(title: 'تجهيز تقرير إداري سريع', description: 'يمكن للمدير الاعتماد على هذه النتائج في الاجتماعات اليومية أو تقارير نهاية الوردية.'),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SimpleTile(title: 'الإنتاج الفعلي', subtitle: '${totalProduction.round()} وحدة', trailing: 'محقق'),
          SimpleTile(title: 'المستهدف', subtitle: '${totalTarget.round()} وحدة', trailing: 'خطة'),
          SimpleTile(title: 'المهام المكتملة', subtitle: '$completedTasks من ${tasks.length}', trailing: 'منفذ'),
          SimpleTile(title: 'متوسط إنجاز المهام', subtitle: '${(averageTaskCompletion * 100).round()}%', trailing: strongResult ? 'جيد جدًا' : 'يحتاج متابعة'),
        ],
      ),
    );
  }
}

class _ResultsBenefitCard extends StatelessWidget {
  const _ResultsBenefitCard({required this.title, required this.description});

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
            child: const Icon(Icons.analytics_rounded, color: Color(0xFF0F766E)),
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

