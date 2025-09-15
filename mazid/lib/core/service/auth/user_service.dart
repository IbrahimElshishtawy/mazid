import 'package:mazid/core/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final supabase = Supabase.instance.client;

  Future<List<UserModel>> getUsers({int limit = 50}) async {
    try {
      final data = await supabase
          .from('users')
          .select()
          .order('created_at', ascending: false)
          .limit(limit);
      final listData = (data as List<dynamic>?) ?? [];
      return listData.map((e) => UserModel.fromJson(e)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching users: $e');
      }
      return [];
    }
  }
}
