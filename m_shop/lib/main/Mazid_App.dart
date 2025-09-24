// ignore_for_file: camel_case_types

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Mazid extends StatelessWidget {
  const Mazid({super.key});

  // نسجّل introSeen في الخلفية بعد أول فريم (من غير ما نعمل FutureBuilder)
  void _markIntroSeen() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('introSeen', true);
      } catch (e) {
        if (kDebugMode) {
          print('this problem excption data $e');
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
          create: (_) =>
              AuthCubit(authService: AuthService())..checkAuthStatus(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Mazid",
        theme: ThemeData.dark(),
        // ابدأ مباشرة بالهوم
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
