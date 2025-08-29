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
        'created_at': DateTime.now().toUtc(),
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

  Future<UserModel?> login({
    required String email,
    required String password,
    required String phone,
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
