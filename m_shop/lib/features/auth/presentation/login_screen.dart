import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:m_shop/features/auth/data/auth_service.dart';
import 'package:m_shop/features/dashboard/presentation/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController(text: 'manager@factory.com');
  final _passwordController = TextEditingController(text: '123456');
  final _authService = AuthService();
  late final AnimationController _controller;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 14))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_authService.login(_emailController.text.trim(), _passwordController.text.trim())) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const DashboardScreen()));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFFB91C1C),
        content: Text('بيانات الدخول غير صحيحة'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => _LoginBackground(progress: _controller.value),
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1140),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final stacked = constraints.maxWidth < 860;
                      final form = _LoginForm(
                        emailController: _emailController,
                        passwordController: _passwordController,
                        obscurePassword: _obscurePassword,
                        onTogglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
                        onLogin: _login,
                      );

                      if (stacked) {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _LoginHero(progress: _controller.value),
                              const SizedBox(height: 16),
                              form,
                            ],
                          ),
                        );
                      }

                      return Row(
                        children: [
                          Expanded(child: _LoginHero(progress: _controller.value)),
                          const SizedBox(width: 18),
                          SizedBox(width: 420, child: form),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginBackground extends StatelessWidget {
  const _LoginBackground({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF02060A), Color(0xFF07111A), Color(0xFF09131F)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -140 + (progress * 28),
            right: -30 + (math.sin(progress * math.pi * 2) * 24),
            child: _GlowSphere(size: 320, color: const Color(0xFF14B8A6).withValues(alpha: 0.18)),
          ),
          Positioned(
            bottom: -120,
            left: -50 + (math.cos(progress * math.pi * 2) * 24),
            child: _GlowSphere(size: 340, color: const Color(0xFF2563EB).withValues(alpha: 0.16)),
          ),
          Positioned(
            top: 160 + (math.sin(progress * math.pi * 2) * 18),
            left: 220,
            child: _GlowSphere(size: 200, color: const Color(0xFF7C3AED).withValues(alpha: 0.10)),
          ),
          CustomPaint(size: Size.infinite, painter: _GridPainter(progress: progress)),
        ],
      ),
    );
  }
}

class _GlowSphere extends StatelessWidget {
  const _GlowSphere({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0.0)]),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFF294053).withValues(alpha: 0.22)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 38.0;
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final scanRect = Rect.fromLTWH(0, (size.height * progress) - 90, size.width, 180);
    final scanPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          const Color(0xFF14B8A6).withValues(alpha: 0.0),
          const Color(0xFF14B8A6).withValues(alpha: 0.12),
          const Color(0xFF14B8A6).withValues(alpha: 0.0),
          Colors.transparent,
        ],
      ).createShader(scanRect);

    canvas.drawRect(scanRect, scanPaint);
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => oldDelegate.progress != progress;
}

class _LoginHero extends StatelessWidget {
  const _LoginHero({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xCC0A1624), Color(0xBB102133), Color(0xAA123B67)],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF1D3348)),
        boxShadow: const [
          BoxShadow(color: Color(0x22000000), blurRadius: 30, offset: Offset(0, 18)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF14B8A6), Color(0xFF2563EB)]),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(Icons.factory_rounded, color: Colors.white, size: 34),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('واجهة دخول تشغيلية', style: TextStyle(color: Color(0xFF91B4CC), fontWeight: FontWeight.w700)),
                    SizedBox(height: 4),
                    Text('منصة إدارة المصنع', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'لوحة دخول احترافية بإحساس تقني حديث لمتابعة التشغيل والفرق والتنبيهات من أول لحظة.',
            style: TextStyle(color: Color(0xFFD7E6F3), height: 1.8, fontSize: 15),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _HeroTag(label: 'تحليلات فورية'),
              _HeroTag(label: 'أمان تشغيلي'),
              _HeroTag(label: 'تقارير مباشرة'),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _InfoPanel(
                title: 'حالة النظام',
                value: 'مباشر',
                accent: const Color(0xFF14B8A6),
                pulse: progress,
              ),
              _InfoPanel(
                title: 'مستوى الأمان',
                value: 'مستقر',
                accent: const Color(0xFF2563EB),
                pulse: progress + 0.35,
              ),
              _InfoPanel(
                title: 'الاستجابة',
                value: 'سريعة',
                accent: const Color(0xFFF59E0B),
                pulse: progress + 0.65,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroTag extends StatelessWidget {
  const _HeroTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({required this.title, required this.value, required this.accent, required this.pulse});

  final String title;
  final String value;
  final Color accent;
  final double pulse;

  @override
  Widget build(BuildContext context) {
    final animated = 0.85 + ((math.sin(pulse * math.pi * 2) + 1) * 0.08);

    return Transform.scale(
      scale: animated,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accent.withValues(alpha: 0.30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Color(0xFF8FB0C8), fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(color: accent, fontWeight: FontWeight.w900, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onLogin,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: const Color(0xCC0B1624),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF1E344B)),
        boxShadow: const [
          BoxShadow(color: Color(0x22000000), blurRadius: 30, offset: Offset(0, 18)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تسجيل الدخول',
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text(
            'استخدم بيانات المشرف للدخول إلى لوحة التحكم بشكل آمن وسريع.',
            style: TextStyle(color: Color(0xFF8FA9BF), height: 1.6),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: emailController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'البريد الإلكتروني',
              prefixIcon: Icon(Icons.alternate_email_rounded),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: passwordController,
            obscureText: obscurePassword,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'كلمة المرور',
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                onPressed: onTogglePassword,
                icon: Icon(obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline_rounded, color: Color(0xFF74FBE8), size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'الواجهة الآن داكنة بالكامل والكادر نفسه غامق حتى يكون الشكل أكثر فخامة وراحة.',
                    style: TextStyle(color: Color(0xFF9CB2C8), height: 1.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onLogin,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF14B8A6),
                foregroundColor: const Color(0xFF041018),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              child: const Text('دخول إلى الداشبورد', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ),
        ],
      ),
    );
  }
}
