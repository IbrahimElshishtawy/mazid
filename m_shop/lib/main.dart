import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:m_shop/screens/login_screen.dart';
import 'package:m_shop/services/dashboard_store.dart';
import 'package:m_shop/utils/theme_helper.dart';
import 'package:redux/redux.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await createDashboardStore();
  runApp(DashboardApp(store: store));
}

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key, required this.store});

  final Store<DashboardState> store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<DashboardState>(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dashboard App',
        theme: ThemeHelper.lightTheme(),
        home: const LoginScreen(),
      ),
    );
  }
}
