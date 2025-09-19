// ignore_for_file: unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoogleAuthService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile', 'openid'],
    serverClientId: kIsWeb
        ? null
        : "76266535797-ebv8h6gfuhk142fvn21qjc0aqj01t2m2.apps.googleusercontent.com",
  );

  static Future<AuthResponse?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint("❌ المستخدم لغى تسجيل الدخول");
        return null;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null || accessToken == null) {
        debugPrint("❌ idToken أو accessToken غير موجود");
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

  static Future<void> signOut() async {
    await _supabase.auth.signOut();
    await _googleSignIn.signOut();
    debugPrint("👋 تم تسجيل الخروج");
  }
}
