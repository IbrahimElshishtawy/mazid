import 'package:flutter_test/flutter_test.dart';
import 'package:m_shop/features/auth/data/auth_service.dart';

void main() {
  test('auth service accepts non-empty valid credentials', () {
    final auth = AuthService();
    expect(auth.login('manager@factory.com', '123456'), isTrue);
    expect(auth.login('', '123456'), isFalse);
  });
}
