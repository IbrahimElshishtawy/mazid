import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FacebookAuthService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<void> signInWithFacebook() async {
    try {
      await _supabase.auth.signInWithOAuth(OAuthProvider.facebook);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Facebook Sign-In Error: $e');
      }
    }
  }

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
