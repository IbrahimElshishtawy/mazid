// ignore_for_file: file_names

import 'package:m_shop/core/data/admin_data.dart';
import 'package:m_shop/core/models/user/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  final supabase = Supabase.instance.client;
  bool isAdminLogin() {
    final user = supabase.auth.currentUser;
    if (user == null) return false;
    return user.email == AdminData.email;
  }

  Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
    String phone = '',
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email.trim(),
        password: password,
      );

      if (response.user == null) {
        throw AuthException("فشل إنشاء الحساب، حاول مرة أخرى");
      }

      final userId = response.user!.id;

      await supabase.from('users').insert({
        'id': userId,
        'name': name.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'avatar': '',
        'role': 'user',
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });

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
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException("حدث خطأ أثناء التسجيل");
    }
  }

  Future<UserModel?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      if (email.trim() == AdminData.email &&
          password.trim() == AdminData.password) {
        return UserModel(
          id: AdminData.id,
          name: AdminData.name,
          email: AdminData.email,
          phone: AdminData.phone,
          avatar: AdminData.avatar,
          password: AdminData.password,
          imageUrl: AdminData.imageUrl,
          role: AdminData.role,
        );
      }

      final response = await supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      if (response.user == null) {
        throw AuthException("البريد الإلكتروني أو كلمة المرور غير صحيحة");
      }

      final data = await supabase
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .maybeSingle();

      if (data == null) {
        throw AuthException("المستخدم غير موجود في قاعدة البيانات");
      }

      return UserModel.fromJson(data);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException("تعذر تسجيل الدخول، تحقق من الاتصال بالإنترنت");
    }
  }

  Future<void> loginWithPhone(String phone) async {
    try {
      await supabase.auth.signInWithOtp(phone: phone.trim());
    } catch (e) {
      throw AuthException("فشل إرسال رمز التحقق");
    }
  }

  Future<void> logout() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      throw AuthException("تعذر تسجيل الخروج");
    }
  }

  User? currentUser() {
    return supabase.auth.currentUser;
  }

  Future<UserModel?> login({
    String? email,
    String? phone,
    String? password,
  }) async {
    if (email != null && email.isNotEmpty && password != null) {
      return await loginWithEmail(email: email, password: password);
    } else if (phone != null && phone.isNotEmpty) {
      await loginWithPhone(phone);
      return null;
    } else {
      throw AuthException("يجب إدخال البريد وكلمة المرور أو رقم الهاتف");
    }
  }

  Future<UserModel?> getUserData(String id) async {
    final data = await supabase
        .from('users')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (data == null) return null;
    return UserModel.fromJson(data);
  }
}
