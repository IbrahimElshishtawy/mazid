import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazid/core/cubit/auth/auth_cubit.dart';
import 'package:mazid/core/cubit/auth/auth_service.dart';
import 'package:mazid/pages/home/ui/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import 'package:shared_preferences/shared_preferences.dart';

// Pages
import 'package:mazid/pages/auth/login.dart';
import 'package:mazid/pages/auth/Register_page.dart';
import 'package:mazid/pages/spa/intro_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await supa.Supabase.initialize(
    url: 'https://zfmvvfobherprpcyqkqe.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpmbXZ2Zm9iaGVycHJwY3lxa3FlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYxMTE5MzMsImV4cCI6MjA3MTY4NzkzM30.pQNpOdhFGxtACYlw4FtJDBjNyGZE-MQ3kAhcAK8_3Cg',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _determineStartPage() async {
    final prefs = await SharedPreferences.getInstance();
    final introSeen = prefs.getBool('introSeen') ?? false;
    final loggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!introSeen) {
      return const IntroPage();
    } else if (loggedIn) {
      return const HomePage(); // ✅ مش
    } else {
      return const LoginPage();
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
              '/home': (_) => const HomePage(), // ✅ هنا برضه
            },
          );
        },
      ),
    );
  }
}
