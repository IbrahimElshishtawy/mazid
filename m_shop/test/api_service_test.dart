import 'package:flutter_test/flutter_test.dart';
import 'package:m_shop/services/api_service.dart';

void main() {
  test('api service returns production data', () async {
    final api = ApiService();
    final data = await api.fetchProduction();
    expect(data.isNotEmpty, isTrue);
  });
}
