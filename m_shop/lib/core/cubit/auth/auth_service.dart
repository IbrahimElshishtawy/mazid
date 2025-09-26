import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:m_shop/core/data/admin_data.dart';
import 'package:m_shop/core/models/user/user_model.dart';

class AuthService {
  final SupabaseClient supabase = Supabase.instance.client;

  static const String _spKeyAdmin = 'admin_logged_in';

  bool _initialized = false;
  bool _isAdmin = false;

  Future<void> init() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    _isAdmin = prefs.getBool(_spKeyAdmin) ?? false;
    _initialized = true;
  }

  bool isAdminLogin() {
    final adminEmail = AdminData.email.toLowerCase();
    final supaEmail = supabase.auth.currentUser?.email?.toLowerCase();
    return _isAdmin || (supaEmail != null && supaEmail == adminEmail);
  }

  User? currentUser() => supabase.auth.currentUser;

  Future<UserModel?> currentUserProfile() async {
    await init();

    if (isAdminLogin()) {
      return UserModel(
        id: AdminData.id,
        name: AdminData.name,
        email: AdminData.email,
        phone: AdminData.phone,
        avatar: AdminData.avatar,
        imageUrl: AdminData.imageUrl,
        role: AdminData.role,
        password: '',
      );
    }

    final user = supabase.auth.currentUser;
    if (user == null) {
      debugPrint("[AuthService] No user logged in");
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
      debugPrint("[AuthService] User not found in 'users' table");
      return null;
    } catch (e, st) {
      debugPrint("[AuthService] currentUserProfile exception: $e\n$st");
      return null;
    }
  }

  Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
    String phone = '',
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
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
        debugPrint("[AuthService] User inserted in DB: $insertResponse");
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_spKeyAdmin, false);
        _isAdmin = false;
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
      }
      return null;
    } catch (e, st) {
      debugPrint("[AuthService] Registration exception: $e\n$st");
      return null;
    }
  }

  Future<UserModel?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_spKeyAdmin, false);
        _isAdmin = false;

        final data = await supabase
            .from('users')
            .select()
            .eq('id', response.user!.id)
            .maybeSingle();
        if (data != null) {
          return UserModel.fromJson(data);
        }
        debugPrint("[AuthService] User not found in 'users' table");
        return null;
      }
      return null;
    } catch (e, st) {
      debugPrint("[AuthService] Login exception: $e\n$st");
      return null;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_spKeyAdmin, false);
      _isAdmin = false;
      await supabase.auth.signOut();
    } catch (e, st) {
      debugPrint("[AuthService] Logout failed: $e\n$st");
      rethrow;
    }
  }

  Future<UserModel?> getUserData(String userId) async {
    try {
      final data = await supabase
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();
      if (data != null) {
        return UserModel.fromJson(data);
      } else {
        debugPrint("[AuthService] User with id $userId not found");
        return null;
      }
    } catch (e, st) {
      debugPrint("[AuthService] getUserData exception: $e\n$st");
      return null;
    }
  }

  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    await init();

    final isAdminCreds =
        email.trim().toLowerCase() == AdminData.email.toLowerCase() &&
        password == AdminData.password;

    if (isAdminCreds) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_spKeyAdmin, true);
      _isAdmin = true;

      return UserModel(
        id: AdminData.id,
        name: AdminData.name,
        email: AdminData.email,
        phone: AdminData.phone,
        avatar: AdminData.avatar,
        imageUrl: AdminData.imageUrl,
        role: AdminData.role,
        password: '',
      );
    }

    return await loginWithEmail(email: email, password: password);
  }
}
