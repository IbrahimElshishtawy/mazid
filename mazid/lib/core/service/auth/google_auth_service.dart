import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoogleAuthService {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],

    clientId: kIsWeb
        ? null
        : "76266535797-t45dr5js5quu60ijkgogga11f8nkrrtu.apps.googleusercontent.com",
  );

  /// تسجيل الدخول باستخدام Google + Supabase
  static Future<void> signInWithGoogle() async {
    try {
      // 1️⃣ سجل الدخول بجوجل
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint("❌ المستخدم لغى تسجيل الدخول");
        return;
      }

      // 2️⃣ هات التوكينات
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        debugPrint("❌ Google tokens not found");
        return;
      }

      // 3️⃣ بعت التوكينات لـ Supabase
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
    } catch (e, st) {
      debugPrint("❌ Google Sign-In Error: $e");
      debugPrint("$st");
    }
  }

  /// تسجيل الخروج
  static Future<void> signOut() async {
    await _supabase.auth.signOut();
    await _googleSignIn.signOut();
    debugPrint("👋 تم تسجيل الخروج");
  }
}
