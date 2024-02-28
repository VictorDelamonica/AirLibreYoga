import 'package:air_libre_yoga/main.dart';
import 'package:air_libre_yoga/views/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('EmptyView renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.map_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(EmptyView), findsOneWidget);

    expect(find.text('Empty View'), findsOneWidget);
  });
}
