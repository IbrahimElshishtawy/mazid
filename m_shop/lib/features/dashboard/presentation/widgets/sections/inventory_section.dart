part of 'dashboard_sections.dart';

class InventorySection extends StatelessWidget {
  const InventorySection({super.key, required this.inventory});

  final List<InventoryItem> inventory;

  @override
  Widget build(BuildContext context) {
    final lowStockItems = inventory.where((item) => item.quantity <= item.minimum).toList();
    final safeItems = inventory.length - lowStockItems.length;
    final readinessRatio = inventory.isEmpty ? 0.0 : safeItems / inventory.length;
    final totalQuantity = inventory.fold<int>(0, (sum, item) => sum + item.quantity);
    final averageCoverage = inventory.isEmpty ? 0.0 : inventory.fold<double>(0, (sum, item) => sum + (item.quantity / item.minimum)) / inventory.length;

    return SectionCard(
      title: 'الجرد والمخزون',
      subtitle: 'لوحة احترافية لمراقبة المخزون، تنبيهات النقص، واستفادة الإدارة من ميزات الجرد داخل المصنع.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _AttendanceStatCard(title: 'إجمالي الأصناف', value: '${inventory.length}', note: 'العناصر المسجلة بالنظام', color: const Color(0xFF0F766E), icon: Icons.inventory_2_rounded),
              _AttendanceStatCard(title: 'أصناف آمنة', value: '$safeItems', note: 'فوق الحد الأدنى', color: const Color(0xFF16A34A), icon: Icons.verified_rounded),
              _AttendanceStatCard(title: 'أصناف حرجة', value: '${lowStockItems.length}', note: 'تحتاج طلب أو متابعة', color: const Color(0xFFDC2626), icon: Icons.warning_amber_rounded),
              _AttendanceStatCard(title: 'إجمالي الكميات', value: '$totalQuantity', note: 'مجموع الوحدات بالمخزن', color: const Color(0xFF2563EB), icon: Icons.warehouse_rounded),
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
                const Text('مركز تشغيل الجرد للشركات', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text('استخدم هذا القسم لمتابعة المخزون الحرج، اعتماد طلبات الشراء، مراجعة التغطية، وتجهيز رؤية تشغيلية تمنع توقف المصنع بسبب نفاد المواد.', style: TextStyle(color: Color(0xFF667B75), height: 1.6)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: const [
                    _QuickAction(label: 'إضافة صنف', icon: Icons.add_box_outlined),
                    _QuickAction(label: 'تعديل الكميات', icon: Icons.edit_note_rounded),
                    _QuickAction(label: 'اعتماد طلب شراء', icon: Icons.fact_check_rounded),
                    _QuickAction(label: 'تحويل للمخزن', icon: Icons.swap_horiz_rounded),
                    _QuickAction(label: 'تنبيه نفاد', icon: Icons.notifications_active_outlined),
                    _QuickAction(label: 'تقرير الجرد', icon: Icons.file_download_outlined),
                  ],
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: const [
                    _InventoryFeatureCard(title: 'للمخازن والشركات', description: 'مفيد للمصانع والشركات التي تحتاج رؤية سريعة للمخزون الحرج، الطلبات، والتغطية التشغيلية.'),
                    _InventoryFeatureCard(title: 'تنبيه قبل التوقف', description: 'يعطي الإدارة إنذارًا قبل نفاد المواد التي قد تسبب توقف خط الإنتاج أو تأخير التسليم.'),
                    _InventoryFeatureCard(title: 'اعتماد ومراجعة', description: 'يساعد المدير على اعتماد التوريد، متابعة التحويل، واتخاذ قرار شراء أسرع.'),
                    _InventoryFeatureCard(title: 'قراءة واقعية', description: 'يعرض وضع الجرد بشكل أقرب للأنظمة الحقيقية بدل مجرد قائمة أسماء وكميات.'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 980;

              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _InventoryReadinessChart(
                        readinessRatio: readinessRatio,
                        safeItems: safeItems,
                        lowStockItems: lowStockItems.length,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _InventoryCoverageChart(
                        inventory: inventory,
                        averageCoverage: averageCoverage,
                      ),
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  _InventoryReadinessChart(
                    readinessRatio: readinessRatio,
                    safeItems: safeItems,
                    lowStockItems: lowStockItems.length,
                  ),
                  const SizedBox(height: 16),
                  _InventoryCoverageChart(
                    inventory: inventory,
                    averageCoverage: averageCoverage,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          const SectionCard(
            title: 'كيف تستفيد الإدارة من فيتشر الجرد؟',
            subtitle: 'هذه الميزات مصممة لتخدم الشركة أو المصنع في التشغيل اليومي واتخاذ القرار.',
            child: Column(
              children: [
                OverviewLine(title: 'منع توقف خطوط الإنتاج', description: 'اعرف الأصناف الحرجة مبكرًا قبل أن تؤثر على التشغيل أو على خطط التسليم.'),
                OverviewLine(title: 'تحسين قرارات الشراء', description: 'راجع الجاهزية والتغطية قبل اعتماد طلب جديد أو زيادة التوريد.'),
                OverviewLine(title: 'متابعة المخزن بشكل لحظي', description: 'استخدم الجرافيك لمعرفة هل وضع الجرد مطمئن أم يحتاج تدخل فوري.'),
                OverviewLine(title: 'تقارير أقرب للواقع', description: 'القسم يعرض مؤشرات وجرافيك وبطاقات توصل الصورة بسرعة في الاجتماعات والإدارة.'),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionCard(
            title: 'تفاصيل الأصناف والمخزون',
            subtitle: 'عرض تفصيلي لحالة كل صنف ومدى جاهزيته للاستخدام أو الحاجة للتوريد.',
            child: Column(children: inventory.map((item) => InventoryTile(item: item)).toList()),
          ),
        ],
      ),
    );
  }
}

class _InventoryFeatureCard extends StatelessWidget {
  const _InventoryFeatureCard({required this.title, required this.description});

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
            child: const Icon(Icons.inventory_2_outlined, color: Color(0xFF0F766E)),
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

class _InventoryReadinessChart extends StatelessWidget {
  const _InventoryReadinessChart({required this.readinessRatio, required this.safeItems, required this.lowStockItems});

  final double readinessRatio;
  final int safeItems;
  final int lowStockItems;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'جرافيك جاهزية المخزون',
      subtitle: 'نسبة الأصناف الآمنة مقابل العناصر الحرجة.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: readinessRatio.clamp(0.0, 1.0).toDouble(),
                    strokeWidth: 16,
                    color: const Color(0xFF16A34A),
                    backgroundColor: const Color(0xFFF5D0D0),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${(readinessRatio * 100).round()}%', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    const Text('جاهزية', style: TextStyle(color: Color(0xFF667B75), fontWeight: FontWeight.w700)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: SimpleTile(title: 'آمن', subtitle: '$safeItems أصناف', trailing: 'مطمئن', accent: const Color(0xFF16A34A))),
              const SizedBox(width: 12),
              Expanded(child: SimpleTile(title: 'حرج', subtitle: '$lowStockItems أصناف', trailing: 'متابعة', accent: const Color(0xFFDC2626))),
            ],
          ),
        ],
      ),
    );
  }
}

class _InventoryCoverageChart extends StatelessWidget {
  const _InventoryCoverageChart({required this.inventory, required this.averageCoverage});

  final List<InventoryItem> inventory;
  final double averageCoverage;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'جرافيك تغطية الأصناف',
      subtitle: 'يقارن بين الكمية الحالية والحد الأدنى لكل صنف.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...inventory.map(
            (item) {
              final ratio = (item.quantity / item.minimum).clamp(0.0, 1.8).toDouble();
              final color = item.quantity <= item.minimum ? const Color(0xFFDC2626) : const Color(0xFF0F766E);
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w800))),
                        Text('${item.quantity}/${item.minimum} ${item.unit}', style: TextStyle(color: color, fontWeight: FontWeight.w800)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: (ratio / 1.8).clamp(0.0, 1.0).toDouble(),
                        minHeight: 10,
                        color: color,
                        backgroundColor: color.withValues(alpha: 0.12),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Text('متوسط التغطية العامة: ${(averageCoverage * 100).round()}%', style: const TextStyle(color: Color(0xFF506662), fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

