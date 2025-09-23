// ignore_for_file: deprecated_member_use, use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mazid/core/service/auth/facebook_auth_service.dart';
import 'package:mazid/core/service/auth/google_auth_service.dart';

// لو صفحة الشروط اسمها/مسارها مختلف عدّل الاستيراد ده
import 'package:mazid/pages/Auction/ui/intro_Auction_page.dart'; // يفترض أنها تحتوي على class AuctionTermsPage

class LoginSocialButtons extends StatelessWidget {
  const LoginSocialButtons({super.key});

  /// بعد تسجيل الدخول: شيّك موافقة الشروط الخاصة بالمستخدم الحالي
  Future<void> _routeAfterLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final uid = Supabase.instance.client.auth.currentUser?.id ?? 'global';
    final accepted = prefs.getBool('auction_terms_accepted_$uid') ?? false;

    if (!context.mounted) return;
    if (accepted) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuctionTermsPage()),
      );
    }
  }

  void _showFailSnack(BuildContext context, [String? msg]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg ?? 'Login failed, user not found')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Continue with",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(221, 255, 255, 255),
          ),
        ),
        const SizedBox(width: 12),

        // Google
        _buildSocialCircleButton(
          context,
          icon: FontAwesomeIcons.google,
          color: Colors.redAccent,
          onPressed: () async {
            try {
              await GoogleAuthService.signInWithGoogle();

              // بدل res.user: اعتمد على Supabase.currentUser
              final user = Supabase.instance.client.auth.currentUser;
              if (user != null) {
                await _routeAfterLogin(context);
              } else {
                if (!context.mounted) return;
                _showFailSnack(context);
              }
            } catch (e) {
              if (!context.mounted) return;
              _showFailSnack(context, 'Google login failed: $e');
            }
          },
        ),

        const SizedBox(width: 12),
        const Text(
          "or",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 12),

        // Facebook
        _buildSocialCircleButton(
          context,
          icon: FontAwesomeIcons.facebookF,
          color: Colors.blueAccent,
          onPressed: () async {
            try {
              await FacebookAuthService.signInWithFacebook();

              // اعتمد على Supabase.currentUser بعد الرجوع من المتصفح
              final user =
                  FacebookAuthService.currentUser ??
                  Supabase.instance.client.auth.currentUser;

              if (user != null) {
                await _routeAfterLogin(context);
              } else {
                if (!context.mounted) return;
                _showFailSnack(context);
              }
            } catch (e) {
              if (!context.mounted) return;
              _showFailSnack(context, 'Facebook login failed: $e');
            }
          },
        ),
      ],
    );
  }

  Widget _buildSocialCircleButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Center(child: Icon(icon, color: color, size: 20)),
      ),
    );
  }
}
