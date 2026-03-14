import 'package:flutter/material.dart';
import 'package:m_shop/screens/dashboard_screen.dart';
import 'package:m_shop/services/auth_service.dart';
import 'package:m_shop/utils/validation_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (!ValidationHelper.isValidEmail(email) || !ValidationHelper.isStrongPassword(password)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('بيانات الدخول غير صحيحة')));
      return;
    }

    if (_authService.login(email, password)) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const DashboardScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('تسجيل الدخول', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                const SizedBox(height: 20),
                TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'البريد الإلكتروني')),
                const SizedBox(height: 12),
                TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'كلمة المرور')),
                const SizedBox(height: 20),
                FilledButton(onPressed: _login, child: const Text('دخول')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
