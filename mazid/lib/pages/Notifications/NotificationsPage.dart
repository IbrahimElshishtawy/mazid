import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  // مثال بيانات إشعارات
  final List<Map<String, String>> notifications = [
    {
      'title': 'طلب جديد',
      'subtitle': 'تم إرسال طلبك بنجاح.',
      'time': 'قبل 2 دقيقة',
    },
    {
      'title': 'تحديث التطبيق',
      'subtitle': 'تم إصدار نسخة جديدة من التطبيق.',
      'time': 'قبل ساعة',
    },
    {
      'title': 'رسالة من الدعم',
      'subtitle': 'يرجى التحقق من بريدك الإلكتروني.',
      'time': 'أمس',
    },
    {
      'title': 'تذكير',
      'subtitle': 'لديك مهمة لم تنجز بعد.',
      'time': 'منذ يومين',
    },
  ];

  NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإشعارات'), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.notifications, color: Colors.blue),
              title: Text(notification['title'] ?? ''),
              subtitle: Text(notification['subtitle'] ?? ''),
              trailing: Text(
                notification['time'] ?? '',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              onTap: () {
                // فعل عند الضغط على الإشعار، مثال فتح تفاصيل
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم الضغط على: ${notification['title']}'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
