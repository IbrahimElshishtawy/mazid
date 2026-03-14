import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m_shop/widgets/stat_card.dart';

void main() {
  testWidgets('stat card renders title and value', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 250,
            height: 180,
            child: StatCard(
              title: 'الإنتاج',
              value: '100',
              subtitle: 'وحدة',
              icon: Icons.factory,
              color: Colors.teal,
            ),
          ),
        ),
      ),
    );

    expect(find.text('الإنتاج'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
  });
}
