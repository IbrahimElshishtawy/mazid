// ignore_for_file: unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoogleAuthService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // استخدم serverClientId على Android
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: kIsWeb
        ? null
        : "76266535797-t45dr5js5quu60ijkgogga11f8nkrrtu.apps.googleusercontent.com",
  );

  /// تسجيل الدخول بحساب Google
  static Future<AuthResponse?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint("❌ المستخدم لغى تسجيل الدخول");
        return null;
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        debugPrint("❌ Google tokens not found");
        return null;
      }

      final res = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (res.user != null) {
        debugPrint("✅ تسجيل ناجح: ${res.user!.email}");
      } else {
        debugPrint("❌ فشل تسجيل الدخول في Supabase");
      }

      return res;
    } catch (e, st) {
      debugPrint("❌ Google Sign-In Error: $e");
      debugPrint("$st");
      return null;
    }
  }

  /// تسجيل الخروج
  static Future<void> signOut() async {
    await _supabase.auth.signOut();
    await _googleSignIn.signOut();
    debugPrint("👋 تم تسجيل الخروج");
  }
}
