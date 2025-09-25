// lib/core/auth/google_auth_service.dart
// ignore_for_file: unnecessary_null_comparison, dead_code, await_only_futures

import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoogleAuthService {
  GoogleAuthService._();

  static final SupabaseClient _supabase = Supabase.instance.client;

  // ضع القيم الصحيحة الخاصة بتطبيقك:
  // ملاحظة: serverClientId = Web client ID (يُستخدم غالبًا على Android)
  static const String _webClientId =
      '76266535797-ebv8h6gfuhk142fvn21qjc0aqj01t2m2.apps.googleusercontent.com';
  static const String _iosClientId =
      '76266535797-ebv8h6gfuhk142fvn21qjc0aqj01t2m2.apps.googleusercontent.com';

  static bool _initialized = false;
  static Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await GoogleSignIn.instance.initialize(
      clientId: _iosClientId,
      serverClientId: _webClientId,
    );
    _initialized = true;
  }

  /// Web => OAuth redirect عبر Supabase
  /// Mobile/Desktop => GoogleSignIn v7: authenticate() + (idToken, accessToken) ثم signInWithIdToken
  static Future<Object?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final res = await _supabase.auth.signInWithOAuth(
          OAuthProvider.google,
          scopes: 'openid email profile',
          redirectTo: Uri.base.origin,
        );
        debugPrint('✅ Started Google OAuth (Web)');
        return res;
      }

      await _ensureInitialized();

      // جرّب تسجيل خفيف بدون UI
      GoogleSignInAccount? account = await GoogleSignIn.instance
          .attemptLightweightAuthentication();

      // لو فشل، افتح تدفّق تفاعلي
      account ??= await GoogleSignIn.instance.authenticate(
        scopeHint: const ['openid', 'email', 'profile'],
      );

      // المستخدم ألغى
      if (account == null) {
        debugPrint('❌ المستخدم ألغى تسجيل الدخول');
        return null;
      }

      // احصل على idToken
      final idToken = (await account.authentication).idToken;
      if (idToken == null) {
        debugPrint('❌ لم يتم الحصول على idToken');
        return null;
      }

      // احصل على accessToken من الـ Authorization client (v7+)
      const scopes = <String>['openid', 'email', 'profile'];
      final authz = await account.authorizationClient.authorizeScopes(scopes);
      final accessToken = authz.accessToken;

      // إرسال التوكِنز لـ Supabase
      final res = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken, // مطلوب لـ Google
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
        await _ensureInitialized();
        await GoogleSignIn.instance.signOut();
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
