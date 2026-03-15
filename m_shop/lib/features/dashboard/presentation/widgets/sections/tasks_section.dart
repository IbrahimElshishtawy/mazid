part of 'dashboard_sections.dart';

class TasksSection extends StatelessWidget {
  const TasksSection({super.key, required this.tasks});

  final List<TaskModel> tasks;

  @override
  Widget build(BuildContext context) {
    final completedCount = tasks.where((task) => task.progress >= 1).length;
    final inProgressCount = tasks.where((task) => task.progress > 0 && task.progress < 1).length;
    final approvalReadyCount = tasks.where((task) => task.progress >= 0.8).length;
    final delayedCount = tasks.where((task) => task.progress < 0.4 || task.status.contains('مجدولة')).length;

    return SectionCard(
      title: 'المهام',
      subtitle: 'لوحة تنفيذ واعتماد للمهام تساعد الإدارة على المتابعة واتخاذ قرار سريع.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _AttendanceStatCard(title: 'إجمالي المهام', value: '${tasks.length}', note: 'كل المهام النشطة بالمصنع', color: const Color(0xFF0F766E), icon: Icons.assignment_rounded),
              _AttendanceStatCard(title: 'قيد التنفيذ', value: '$inProgressCount', note: 'تحتاج متابعة أثناء العمل', color: const Color(0xFF2563EB), icon: Icons.pending_actions_rounded),
              _AttendanceStatCard(title: 'جاهزة للاعتماد', value: '$approvalReadyCount', note: 'يمكن مراجعتها الآن', color: const Color(0xFF16A34A), icon: Icons.verified_outlined),
              _AttendanceStatCard(title: 'تحتاج تدخل', value: '$delayedCount', note: 'مهام بطيئة أو مؤجلة', color: const Color(0xFFDC2626), icon: Icons.warning_amber_rounded),
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
                const Text('مركز إدارة واعتماد المهام', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text('استخدم هذا القسم لإسناد مهمة، تعديل حالتها، اعتماد تنفيذها، أو تصعيدها لو احتاجت متابعة من الإدارة أو الصيانة.', style: TextStyle(color: Color(0xFF667B75), height: 1.6)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: const [
                    _QuickAction(label: 'إضافة مهمة', icon: Icons.playlist_add_rounded),
                    _QuickAction(label: 'تعديل الحالة', icon: Icons.edit_note_rounded),
                    _QuickAction(label: 'اعتماد التنفيذ', icon: Icons.fact_check_rounded),
                    _QuickAction(label: 'إعادة إسناد', icon: Icons.swap_horiz_rounded),
                    _QuickAction(label: 'تصعيد المهمة', icon: Icons.priority_high_rounded),
                    _QuickAction(label: 'تقرير المهام', icon: Icons.file_download_outlined),
                  ],
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: const [
                    _TaskFeatureCard(title: 'إسناد واضح', description: 'حدد المسؤول عن المهمة والموعد النهائي بسهولة من نفس القسم.'),
                    _TaskFeatureCard(title: 'اعتماد حقيقي', description: 'المهام القريبة من الاكتمال يمكن مراجعتها واعتمادها كمنجزة من الإدارة.'),
                    _TaskFeatureCard(title: 'متابعة التنفيذ', description: 'راقب نسبة الإنجاز لمعرفة من يلتزم ومن يحتاج دعم أو إعادة توجيه.'),
                    _TaskFeatureCard(title: 'تصعيد وتأجيل', description: 'عند التعطل أو التأخير يمكن تصعيد المهمة أو إعادة جدولتها بسرعة.'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const SectionCard(
            title: 'كيف تستفيد من ميزات المهام؟',
            subtitle: 'الهدف من هذا القسم أن يصبح أداة إدارة يومية وليس مجرد قائمة.',
            child: Column(
              children: [
                OverviewLine(title: 'متابعة مسؤولية كل فرد', description: 'تعرف من استلم المهمة ومن اقترب من إنهائها ومن تأخر في التنفيذ.'),
                OverviewLine(title: 'اعتماد المهام الجاهزة', description: 'المهام التي قاربت الاكتمال يمكن مراجعتها واعتمادها بدل تركها معلقة.'),
                OverviewLine(title: 'إعادة التوزيع عند الحاجة', description: 'لو مهمة متأخرة أو المسؤول مشغول، يمكن نقلها إلى شخص أو فريق آخر.'),
                OverviewLine(title: 'تجهيز تقرير تنفيذي', description: 'القسم يساعدك في عرض عدد المهام المكتملة والمتأخرة والجاهزة للاعتماد.'),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionCard(
            title: 'قائمة المهام التنفيذية',
            subtitle: 'كل مهمة تعرض حالتها، تقدمها، وما إذا كانت قابلة للاعتماد الإداري.',
            child: Column(children: tasks.map((task) => TaskTile(task: task)).toList()),
          ),
          const SizedBox(height: 12),
          SimpleTile(title: 'المهام المكتملة', subtitle: '$completedCount من ${tasks.length}', trailing: 'منجز'),
          SimpleTile(title: 'قيد التنفيذ', subtitle: '$inProgressCount مهمة', trailing: 'متابعة'),
          SimpleTile(title: 'جاهزة للاعتماد', subtitle: '$approvalReadyCount مهمة', trailing: 'اعتماد'),
        ],
      ),
    );
  }
}

class _TaskFeatureCard extends StatelessWidget {
  const _TaskFeatureCard({required this.title, required this.description});

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
            child: const Icon(Icons.task_alt_rounded, color: Color(0xFF0F766E)),
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

