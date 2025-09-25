// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:m_shop/core/cubit/auth/auth_cubit.dart';
import 'package:m_shop/core/cubit/auth/auth_service.dart' as svc;

import 'package:m_shop/page/Auth/UI/ui/Register_page.dart';
import 'package:m_shop/page/Auth/UI/ui/login.dart';
import 'package:m_shop/page/home/ui/home_page.dart';
import 'package:m_shop/page/spa/home/intro_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mazid extends StatelessWidget {
  const Mazid({super.key});

  void _markIntroSeen() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('introSeen', true);
      } catch (e) {
        if (kIsWeb) {
          debugPrint('this problem excption data $e');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _markIntroSeen();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(
            authService: svc.AuthService(), // <-- من الـ service الصح
          )..checkAuthStatus(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Mazid",
        theme: ThemeData.dark(),
        home: const HomePage(),
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
