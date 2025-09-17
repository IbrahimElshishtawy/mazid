import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoogleAuthService {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<void> signInWithGoogle() async {
    try {
      // تسجيل الدخول بحساب جوجل (Native)
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // المستخدم لغى العملية

      final googleAuth = await googleUser.authentication;

      // إرسال الـ token لـ Supabase
      final res = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      print('✅ Logged in as: ${res.user?.email}');
    } catch (e) {
      print('❌ Google Sign-In Error: $e');
    }
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _supabase.auth.signOut();
    print('✅ User signed out');
  }

  static User? get currentUser => _supabase.auth.currentUser;
}
