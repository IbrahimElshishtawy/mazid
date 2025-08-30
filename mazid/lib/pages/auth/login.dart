// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mazid/core/cubit/auth/auth_cubit.dart';
import 'package:mazid/core/cubit/auth/auth_state.dart';
import 'package:mazid/core/data/admin_data.dart';
import 'package:mazid/pages/auth/OTP/Otp_Verification_Page.dart';
import 'package:mazid/pages/auth/animation/animated_login_button.dart';
import 'package:mazid/pages/auth/animation/login_animation.dart';
import 'package:mazid/pages/auth/widget/from/login_form.dart';
import 'package:mazid/pages/auth/widget/header/login_header.dart';
import 'package:mazid/pages/auth/widget/login_footer.dart';
import 'package:mazid/pages/home/ui/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final identifierController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;

  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    identifierController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _hideKeyboard() => FocusScope.of(context).unfocus();

  bool _isAdminLogin(String identifier, String password) {
    return identifier == AdminData.email && password == AdminData.password;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    _hideKeyboard();
    _animController.forward();

    final identifier = identifierController.text.trim();
    final password = passwordController.text.trim();

    try {
      if (_isAdminLogin(identifier, password)) {
        await _loginAsAdmin();
      } else if (identifier.contains('@')) {
        await _loginWithEmail(identifier, password);
      } else {
        await _loginWithPhone(identifier);
      }
    } catch (e) {
      _animController.reverse();
      if (!mounted) return;
      _showError("حدث خطأ أثناء تسجيل الدخول: $e");
    }
  }

  Future<void> _loginAsAdmin() async {
    _animController.reverse();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  Future<void> _loginWithEmail(String email, String password) async {
    context.read<AuthCubit>().loginWithEmail(email: email, password: password);
  }

  Future<void> _loginWithPhone(String phone) async {
    context.read<AuthCubit>().loginWithPhone(phone);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: GestureDetector(
        onTap: _hideKeyboard,
        child: BackgroundAnimation(
          child: SafeArea(
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) async {
                _animController.reverse();

                if (!mounted) return;

                if (state is Authenticated) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                  );
                } else if (state is AuthOtpSent) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OtpVerificationPage(phone: state.phone),
                    ),
                  );
                } else if (state is AuthFailure) {
                  _showError(state.message);
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: ListView(
                      children: [
                        const SizedBox(height: 50),
                        const LoginHeader(),
                        const SizedBox(height: 30),
                        LoginFormFields(
                          identifierController: identifierController,
                          passwordController: passwordController,
                          obscurePassword: _obscurePassword,
                          onTogglePassword: () {
                            setState(
                              () => _obscurePassword = !_obscurePassword,
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        AnimatedLoginButton(
                          animController: _animController,
                          onPressed: _handleLogin,
                          isLoading: state is AuthLoading,
                          theme: theme,
                        ),
                        const SizedBox(height: 15),
                        const LoginFooter(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
