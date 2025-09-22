// lib/core/auth/facebook_auth_service.dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FacebookAuthService {
  FacebookAuthService._();
  static final SupabaseClient _supabase = Supabase.instance.client;

  static const String _deepLinkScheme = 'mazid'; // غيّره لو عندك اسم تاني

  static const String _authCallbackHost = 'login-callback';

  static String _redirectTo() {
    if (kIsWeb) {
      return Uri.base.origin;
    }
    return '$_deepLinkScheme://$_authCallbackHost';
  }

  /// تسجيل دخول فيسبوك
  static Future<bool> signInWithFacebook() async {
    try {
      final res = await _supabase.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo: _redirectTo(),

        scopes: 'public_profile,email',

        authScreenLaunchMode: kIsWeb
            ? LaunchMode.platformDefault
            : LaunchMode.externalApplication,
      );
      if (kDebugMode) {
        print('✅ Facebook OAuth launched. Awaiting redirect...');
      }
      return res;
    } catch (e, st) {
      if (kDebugMode) {
        print('❌ Facebook Sign-In Error: $e\n$st');
      }
      rethrow;
    }
  }

  /// تسجيل الخروج
  static Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      if (kDebugMode) print('✅ User signed out');
    } catch (e) {
      if (kDebugMode) print('❌ Sign-Out Error: $e');
      rethrow;
    }
  }

  /// المستخدم الحالي
  static User? get currentUser => _supabase.auth.currentUser;

  static Stream<AuthState> get onAuthStateChange =>
      _supabase.auth.onAuthStateChange;
}
