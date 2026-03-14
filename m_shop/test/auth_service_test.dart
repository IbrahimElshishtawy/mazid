import 'package:flutter_test/flutter_test.dart';
import 'package:m_shop/utils/validation_helper.dart';

void main() {
  test('email validation works', () {
    expect(ValidationHelper.isValidEmail('test@example.com'), isTrue);
    expect(ValidationHelper.isValidEmail('bad-email'), isFalse);
  });
}
