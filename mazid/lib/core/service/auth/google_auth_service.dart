// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoogleAuthService {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  /// تسجيل الدخول باستخدام Google
  static Future<void> signInWithGoogle() async {
    try {
      if (kDebugMode) print('🚀 Starting Google Sign-In...');

      // النسخة الجديدة 7.1.1 تستخدم authenticate()
      final googleUser = await _googleSignIn.authenticate();
      if (googleUser == null) {
        if (kDebugMode) print('⚠️ Google Sign-In canceled by user');
        return;
      }

      final googleAuth = googleUser.authentication;
      if (googleAuth.idToken == null) {
        if (kDebugMode) print('❌ No ID Token found from Google');
        return;
      }

      // تسجيل الدخول في Supabase
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google, // صح
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      if (response.session != null) {
        if (kDebugMode) print('🎉 User signed in: ${response.user?.email}');
      } else {
        if (kDebugMode) print('⚠️ No session returned from Supabase');
      }
    } catch (e) {
      if (kDebugMode) print('❌ Google Sign-In Error: $e');
    }
  }

  /// تسجيل الخروج
  static Future<void> signOut() async {
    try {
      if (kDebugMode) print('🚀 Signing out user...');
      await _googleSignIn.disconnect();
      await _supabase.auth.signOut();
      if (kDebugMode) print('✅ User signed out successfully');
    } catch (e) {
      if (kDebugMode) print('❌ Sign-Out Error: $e');
    }
  }

  /// المستخدم الحالي
  static User? get currentUser => _supabase.auth.currentUser;

  /// متابعة التغيرات
  static void listenAuthChanges() {
    _supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        if (kDebugMode) print('🎉 User signed in: ${session.user.email}');
      } else if (event == AuthChangeEvent.signedOut) {
        if (kDebugMode) print('👋 User signed out');
      } else {
        if (kDebugMode) print('📌 Auth event: $event');
      }
    });
  }
}

extension on GoogleSignInAuthentication {
  Null get accessToken => null;
}
