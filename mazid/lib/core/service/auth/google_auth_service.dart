import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoogleAuthService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<void> signInWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(
        Provider.google,
        options: AuthOptions(
          redirectTo: 'io.supabase.flutter://login-callback',
        ),
      );
      if (kDebugMode) {
        print('✅ Google Sign-In initiated');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Google Sign-In Error: $e');
      }
    }
  }

  /// تسجيل الخروج
  static Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      if (kDebugMode) {
        print('✅ User signed out');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Sign-Out Error: $e');
      }
    }
  }

  static User? get currentUser => _supabase.auth.currentUser;
}
