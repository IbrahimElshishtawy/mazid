import 'package:mazid/core/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
    String phone = '',
  }) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user != null) {
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
    }

    return null;
  }

  Future<UserModel?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user != null) {
      final data = await supabase
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .maybeSingle();

      if (data != null) {
        return UserModel.fromJson(data);
      }
    }

    return null;
  }

  Future<void> loginWithPhone(String phone) async {
    await supabase.auth.signInWithOtp(phone: phone);
  }

  Future<UserModel?> verifyPhoneOtp({
    required String phone,
    required String otp,
  }) async {
    final response = await supabase.auth.verifyOTP(
      phone: phone,
      token: otp,
      type: OtpType.sms,
    );

    if (response.user != null) {
      final data = await supabase
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .maybeSingle();

      if (data != null) {
        return UserModel.fromJson(data);
      }
    }

    return null;
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
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
      throw Exception("Either email/password or phone must be provided");
    }
  }
}
