import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m_shop/features/auth/presentation/login_screen.dart';

void main() {
  testWidgets('login screen renders title and button', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    expect(find.text('تسجيل الدخول'), findsOneWidget);
    expect(find.text('دخول إلى الداشبورد'), findsOneWidget);
  });
}
