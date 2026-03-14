import 'package:flutter_test/flutter_test.dart';
import 'package:m_shop/features/dashboard/application/dashboard_store.dart';

void main() {
  test('dashboard store starts with seeded data', () async {
    final store = await createDashboardStore();
    expect(store.state.production.isNotEmpty, isTrue);
    expect(store.state.tasks.isNotEmpty, isTrue);
    expect(store.state.employees.isNotEmpty, isTrue);
  });
}
