// lib/core/auth/google_auth_service.dart
// ignore_for_file: unused_import

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoogleAuthService {
  GoogleAuthService._();

  static final SupabaseClient _supabase = Supabase.instance.client;

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: const ['email', 'profile', 'openid'],
    clientId: (!kIsWeb && Platform.isIOS)
        ? '76266535797-ebv8h6gfuhk142fvn21qjc0aqj01t2m2.apps.googleusercontent.com'
        : null,
    // Android: لازم يكون Web client ID (مش Android client ID)
    serverClientId: (!kIsWeb && Platform.isAndroid)
        ? '76266535797-ebv8h6gfuhk142fvn21qjc0aqj01t2m2.apps.googleusercontent.com'
        : null,
  );

  static Future<Object?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final res = await _supabase.auth.signInWithOAuth(
          OAuthProvider.google,
          scopes: 'openid email profile',
          redirectTo: Uri.base.origin,
        );
        debugPrint('✅ Google OAuth (web) initiated');
        return res;
      }

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint('❌ المستخدم ألغى تسجيل الدخول');
        return null;
      }

      final googleAuth = await googleUser.authentication;

      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null || accessToken == null) {
        debugPrint(
          '❌ idToken أو accessToken طالع null. تأكد من الإعدادات بالأسفل.',
        );
        return null;
      }

      final res = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (res.user != null) {
        debugPrint('✅ تسجيل ناجح: ${res.user!.email}');
      } else {
        debugPrint('❌ فشل تبادل التوكن في Supabase');
      }
      return res;
    } catch (e, st) {
      debugPrint('❌ Google Sign-In Error: $e');
      debugPrint('$st');
      return null;
    }
  }

  static Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
      debugPrint('👋 تم تسجيل الخروج');
    } catch (e) {
      debugPrint('❌ Sign-Out Error: $e');
    }
  }

  static User? get currentUser => _supabase.auth.currentUser;

  static Stream<AuthState> get onAuthStateChange =>
      _supabase.auth.onAuthStateChange;
}
