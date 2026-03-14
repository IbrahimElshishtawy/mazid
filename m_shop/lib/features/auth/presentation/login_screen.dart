import 'package:flutter/material.dart';
import 'package:m_shop/features/auth/data/auth_service.dart';
import 'package:m_shop/features/dashboard/presentation/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'manager@factory.com');
  final _passwordController = TextEditingController(text: '123456');
  final _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_authService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    )) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('بيانات الدخول غير صحيحة')));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFFE6F4F1), Color(0xFFF7FAF9)],
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 980),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final stacked = constraints.maxWidth < 760;
                    if (stacked) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _LoginHero(),
                          const SizedBox(height: 20),
                          _LoginForm(
                            emailController: _emailController,
                            passwordController: _passwordController,
                            onLogin: _login,
                          ),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(child: _LoginHero()),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _LoginForm(
                            emailController: _emailController,
                            passwordController: _passwordController,
                            onLogin: _login,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF0F766E), Color(0xFF1D4ED8)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x220F766E),
            blurRadius: 30,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.factory_rounded, color: Colors.white, size: 42),
          SizedBox(height: 18),
          Text(
            'منصة إدارة المصنع',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'واجهة أكثر ترتيبًا لمتابعة الإنتاج والمهام والتنبيهات وأداء الفرق من مكان واحد.',
            style: TextStyle(
              color: Color(0xD7FFFFFF),
              height: 1.6,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 22),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _HeroChip(label: 'تحليلات فورية'),
              _HeroChip(label: 'صيانة تنبؤية'),
              _HeroChip(label: 'تقارير الفرق'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تسجيل الدخول',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'استخدم بيانات المشرف للدخول إلى لوحة التحكم.',
              style: TextStyle(color: Color(0xFF647974)),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'كلمة المرور'),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onLogin,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text('دخول إلى الداشبورد'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
