// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazid/core/cubit/auth/auth_cubit.dart';
import 'package:mazid/core/cubit/auth/auth_service.dart';
import 'package:mazid/pages/home/ui/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Pages
import 'package:mazid/pages/auth/ui/login.dart';
import 'package:mazid/pages/auth/ui/Register_page.dart';
import 'package:mazid/pages/spa/intro_page.dart';

class mazid extends StatelessWidget {
  const mazid({super.key});

  Future<Widget> _determineStartPage() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('isLoggedIn') ?? false;
    final introSeen = prefs.getBool('introSeen') ?? false;

    if (loggedIn) {
      return const HomePage();
    } else {
      if (!introSeen) {
        return const IntroPage();
      } else {
        return const LoginPage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) =>
              AuthCubit(authService: AuthService())..checkAuthStatus(),
        ),
      ],
      child: FutureBuilder<Widget>(
        future: _determineStartPage(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const MaterialApp(
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
            );
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Mazid",
            theme: ThemeData.dark(),
            home: snapshot.data,
            routes: {
              '/intro': (_) => const IntroPage(),
              '/login': (_) => const LoginPage(),
              '/register': (_) => const RegisterPage(),
              '/home': (_) => const HomePage(),
            },
          );
        },
      ),
    );
  }
}
