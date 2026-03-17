import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:m_shop/core/theme/app_theme.dart';
import 'package:m_shop/features/auth/presentation/login_screen.dart';
import 'package:m_shop/features/dashboard/application/dashboard_store.dart';
import 'package:redux/redux.dart';

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key, required this.store});

  final Store<DashboardState> store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<DashboardState>(
      store: store,
      child: StoreConnector<DashboardState, _AppSettingsVm>(
        converter: (store) => _AppSettingsVm(
          themePreference: store.state.themePreference,
          textScale: store.state.textScale,
        ),
        builder: (context, vm) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Factory Dashboard',
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: AppTheme.resolveThemeMode(vm.themePreference),
            builder: (context, child) {
              final mediaQuery = MediaQuery.of(context);
              return MediaQuery(
                data: mediaQuery.copyWith(textScaler: TextScaler.linear(AppTheme.textScaleFactor(vm.textScale))),
                child: child ?? const SizedBox.shrink(),
              );
            },
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}

class _AppSettingsVm {
  const _AppSettingsVm({required this.themePreference, required this.textScale});

  final AppThemePreference themePreference;
  final AppTextScale textScale;
}
