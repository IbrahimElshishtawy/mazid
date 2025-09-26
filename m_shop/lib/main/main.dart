import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:m_shop/core/cubit/auth/auth_service.dart';
import 'package:m_shop/main/approot.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:m_shop/core/service/product/product_service.dart';
import 'package:m_shop/core/repository/home_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    Zone.current.handleUncaughtError(
      details.exception,
      details.stack ?? StackTrace.empty,
    );
  };

  await runZonedGuarded<Future<void>>(
    () async {
      const supabaseUrl = String.fromEnvironment(
        'SUPABASE_URL',
        defaultValue: 'https://zfmvvfobherprpcyqkqe.supabase.co',
      );
      const supabaseAnonKey = String.fromEnvironment(
        'SUPABASE_ANON_KEY',
        defaultValue:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpmbXZ2Zm9iaGVycHJwY3FlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYxMTE5MzMsImV4cCI6MjA3MTY4NzkzM30.pQNpOdhFGxtACYlw4FtJDBjNyGZE-MQ3kAhcAK8_3Cg',
      );

      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        debug: kDebugMode,
        authOptions: const FlutterAuthClientOptions(
          autoRefreshToken: true,
          detectSessionInUri: true,
        ),
      );

      final repo = HomeRepository(
        authService: AuthService(),
        productService: ProductService(),
      );
      await repo.prefetchProducts();

      runApp(AppRoot.withRepo(repo));
    },
    (error, stack) {
      if (kDebugMode) {
        // debugPrint('Uncaught: $error\n$stack');
      }
    },
  );
}
