import 'package:flutter/material.dart';
import 'package:m_shop/app/app.dart';
import 'package:m_shop/features/dashboard/application/dashboard_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await createDashboardStore();
  runApp(DashboardApp(store: store));
}
