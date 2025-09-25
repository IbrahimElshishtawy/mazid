// lib/core/service/auth_service.dart
// ignore_for_file: avoid_print

import 'package:m_shop/core/data/admin_data.dart';
import 'package:m_shop/core/models/user/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  /// هل المستخدم الحالي هو الأدمن؟
  bool isAdminLogin() {
    final user = supabase.auth.currentUser;
    final emailNow = user?.email?.toLowerCase();
    final adminEmail = AdminData.email.toLowerCase();
    return emailNow != null && emailNow == adminEmail;
  }

  /// المستخدم الحالي من Supabase (متزامنة)
  /// استخدمها لما تحتاج user.id أو user.email بدون await
  User? currentUser() {
    return supabase.auth.currentUser;
  }

  /// بروفايل المستخدم من جدول users (غير متزامنة)
  /// استخدمها لما تحتاج بيانات التطبيق من الجدول (name/phone/role...)
  Future<UserModel?> currentUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      print("❌ [AuthService] No user logged in");
      return null;
    }
    try {
      final data = await supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (data != null) {
        return UserModel.fromJson(data);
      }
      print("❌ [AuthService] User not found in 'users' table");
      return null;
    } catch (e, st) {
      print("🔥 [AuthService] currentUserProfile exception: $e\n$st");
      return null;
    }
  }

  Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
    String phone = '',
  }) async {
    print("🔄 [AuthService] Registering: $email");

    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      print("🟢 [AuthService] signUp response: $response");

      if (response.user != null) {
        final userId = response.user!.id;

        final insertResponse = await supabase.from('users').insert({
          'id': userId,
          'name': name.trim(),
          'email': email.trim(),
          'phone': phone.trim(),
          'avatar': '',
          'role': 'user',
          'created_at': DateTime.now().toUtc().toIso8601String(),
        }).select();

        print("✅ [AuthService] User inserted in DB: $insertResponse");

        return UserModel(
          id: userId,
          name: name.trim(),
          email: email.trim(),
          avatar: '',
          phone: phone.trim(),
          password: '',
          imageUrl: '',
          role: 'user',
        );
      } else {
        print("❌ [AuthService] Registration failed for $email");
        return null;
      }
    } catch (e, st) {
      print("🔥 [AuthService] Registration exception: $e\n$st");
      return null;
    }
  }

  /// تسجيل الدخول بالبريد
  Future<UserModel?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    print("🔄 [AuthService] Login with email: $email");

    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      print("🟢 [AuthService] signIn response: $response");

      if (response.user != null) {
        final data = await supabase
            .from('users')
            .select()
            .eq('id', response.user!.id)
            .maybeSingle();

        print("🟢 [AuthService] User data from DB: $data");

        if (data != null) {
          return UserModel.fromJson(data);
        } else {
          print(
            "❌ [AuthService] User not found in 'users' table. "
            "تأكد من سياسة RLS على جدول users",
          );
          return null;
        }
      } else {
        print("❌ [AuthService] Invalid email or password");
        return null;
      }
    } catch (e, st) {
      print("🔥 [AuthService] Login exception: $e\n$st");
      return null;
    }
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    print("🔄 [AuthService] Logging out...");
    try {
      await supabase.auth.signOut();
      print("✅ [AuthService] Logout success");
    } catch (e, st) {
      print("❌ [AuthService] Logout failed: $e\n$st");
      rethrow;
    }
  }

  /// جلب بيانات أي مستخدم بواسطة userId من جدول users
  Future<UserModel?> getUserData(String userId) async {
    try {
      final data = await supabase
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (data != null) {
        print("🟢 [AuthService] Fetched user data for $userId: $data");
        return UserModel.fromJson(data);
      } else {
        print("❌ [AuthService] User with id $userId not found");
        return null;
      }
    } catch (e, st) {
      print("🔥 [AuthService] getUserData exception: $e\n$st");
      return null;
    }
  }

  /// تسجيل دخول شامل (بريد)
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    return await loginWithEmail(email: email, password: password);
  }
}
