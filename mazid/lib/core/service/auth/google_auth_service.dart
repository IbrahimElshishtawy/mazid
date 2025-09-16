import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoogleAuthService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  /// تسجيل الدخول باستخدام Google
  static Future<void> signInWithGoogle() async {
    try {
      if (kDebugMode) {
        print('🚀 Starting Google Sign-In process...');
      }

      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: kIsWeb ? null : 'com.mazid://login-callback',
      );

      if (kDebugMode) {
        print('✅ Redirect to Google Auth done, waiting for callback...');
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
      if (kDebugMode) {
        print('🚀 Signing out user...');
      }

      await _supabase.auth.signOut();

      if (kDebugMode) {
        print('✅ User signed out successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Sign-Out Error: $e');
      }
    }
  }

  /// المستخدم الحالي
  static User? get currentUser {
    final user = _supabase.auth.currentUser;
    if (kDebugMode) {
      if (user != null) {
        print('👤 Current user: ${user.email}, id: ${user.id}');
      } else {
        print('⚠️ No user is currently signed in');
      }
    }
    return user;
  }

  static void listenAuthChanges() {
    _supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        if (kDebugMode) {
          print('🎉 User signed in: ${session.user.email}');
        }
      } else if (event == AuthChangeEvent.signedOut) {
        if (kDebugMode) {
          print('👋 User signed out');
        }
      } else {
        if (kDebugMode) {
          print('📌 Auth event: $event');
        }
      }
    });
  }
}
