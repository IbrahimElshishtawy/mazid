// ignore_for_file: file_names

import 'package:mazid/core/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  final supabase = Supabase.instance.client;

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
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });

      return UserModel(
        id: userId,
        name: name.trim(),
        email: email.trim(),
        avatar: '',
        phone: phone.trim(),
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException("حدث خطأ أثناء التسجيل");
    }
  }

  /// تسجيل الدخول بالبريد
  Future<UserModel?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
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

  /// تسجيل الدخول برقم الهاتف (OTP)
  Future<void> loginWithPhone(String phone) async {
    try {
      await supabase.auth.signInWithOtp(phone: phone.trim());
    } catch (e) {
      throw AuthException("فشل إرسال رمز التحقق");
    }
  }

  /// التحقق من رمز OTP
  Future<UserModel?> verifyPhoneOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await supabase.auth.verifyOTP(
        phone: phone.trim(),
        token: otp.trim(),
        type: OtpType.sms,
      );

      if (response.user == null) {
        throw AuthException("رمز التحقق غير صحيح");
      }

      final data = await supabase
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .maybeSingle();

      if (data == null) {
        throw AuthException("المستخدم غير موجود");
      }

      return UserModel.fromJson(data);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException("حدث خطأ أثناء التحقق من الرمز");
    }
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      throw AuthException("تعذر تسجيل الخروج");
    }
  }

  /// المستخدم الحالي
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
}
