import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazid/core/cubit/auth/auth_cubit.dart';
import 'package:mazid/core/cubit/auth/auth_state.dart';
import 'package:mazid/core/cubit/auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

// Pages
import 'package:mazid/pages/auth/login.dart';
import 'package:mazid/pages/auth/Register_page.dart';
import 'package:mazid/pages/spa/intro_page.dart';
import 'package:mazid/pages/home/ui/home_page.dart';

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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) =>
              AuthCubit(authService: AuthService())..checkAuthStatus(),
        ),
      ],
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Mazid",
            theme: ThemeData.dark(),
            home: _buildHome(state),
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

  Widget _buildHome(AuthState state) {
    if (state is AuthLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (state is Authenticated) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}
