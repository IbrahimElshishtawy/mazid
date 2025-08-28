import 'package:mazid/core/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;
  Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user != null) {
      final user = UserModel(
        id: response.user!.id,
        name: name,
        email: email,
        avatar: '',
        phone: '',
      );

      await supabase.from('users').insert({
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'avatar': user.avatar,
        'phone': user.phone,
      });

      return user;
    }
    return null;
  }

  // تسجيل الدخول
  Future<UserModel?> login({
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

  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  User? currentUser() {
    return supabase.auth.currentUser;
  }
}
