import 'package:mazid/core/models/barter_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BarterService {
  final supabase = Supabase.instance.client;
  Future<List<BarterModel>> getBarters() async {
    final data = await supabase
        .from('barters')
        .select()
        .order('created_at', ascending: false);
    return (data as List).map((e) => BarterModel.fromJson(e)).toList();
  }
}
