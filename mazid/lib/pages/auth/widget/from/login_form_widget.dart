import 'package:flutter/material.dart';
import 'package:mazid/pages/auth/animation/animated_login_button.dart';
import 'package:mazid/pages/auth/widget/from/login_form.dart';
import 'package:mazid/pages/auth/widget/header/login_header.dart';
import 'package:mazid/pages/auth/widget/header/login_footer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late AnimationController animController;
  bool obscurePassword = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    animController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final supabase = Supabase.instance.client;

      final response = await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response.user != null) {
        // ✅ نجاح تسجيل الدخول
        if (!mounted) return;
        Navigator.pushReplacementNamed(
          context,
          "/home",
          arguments: response.user!.id, // نمرر الـ userId
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ خطأ أثناء تسجيل الدخول: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const SizedBox(height: 50),
            const LoginHeader(),
            const SizedBox(height: 30),
            LoginFormFields(
              emailController: emailController,
              passwordController: passwordController,
              obscurePassword: obscurePassword,
              onTogglePassword: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
            ),
            const SizedBox(height: 20),
            AnimatedLoginButton(
              animController: animController,
              onPressed: _login,
              isLoading: isLoading,
              theme: Theme.of(context),
            ),
            const SizedBox(height: 15),
            const LoginFooter(),
          ],
        ),
      ),
    );
  }
}
