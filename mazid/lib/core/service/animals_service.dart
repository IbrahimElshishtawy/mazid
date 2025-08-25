import 'package:mazid/core/models/animals_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnimalsService {
  final supabase = Supabase.instance.client;
  Future<List<AnimalsModels>> getAnimals() async {
    final data = await supabase
        .from('animals')
        .select()
        .order('created_at', ascending: false);
    return (data as List).map((e) => AnimalsModels.fromJson(e)).toList();
  }
}
