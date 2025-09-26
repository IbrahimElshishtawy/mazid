// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:m_shop/core/cubit/auth/auth_cubit.dart';
import 'package:m_shop/core/cubit/auth/auth_service.dart' as svc;

import 'package:m_shop/page/Auth/UI/ui/Register_page.dart';
import 'package:m_shop/page/Auth/UI/ui/login.dart';
import 'package:m_shop/page/home/ui/home_page.dart';
import 'package:m_shop/page/spa/home/intro_page.dart';

class Mazid extends StatelessWidget {
  const Mazid({super.key});

  Future<bool> _isIntroSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('introSeen') ?? false;
    } catch (e) {
      if (kIsWeb) {
        debugPrint('SharedPreferences(web) read error: $e');
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) =>
              AuthCubit(authService: svc.AuthService())..checkAuthStatus(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mazid',
        theme: ThemeData.dark(useMaterial3: true),
        home: FutureBuilder<bool>(
          future: _isIntroSeen(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final seen = snapshot.data ?? false;
            return seen ? const HomePage() : const IntroPage();
          },
        ),
        routes: {
          '/intro': (_) => const IntroPage(),
          '/login': (_) => const LoginPage(),
          '/register': (_) => const RegisterPage(),
          '/home': (_) => const HomePage(),
        },
      ),
    );
  }
}
