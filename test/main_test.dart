import 'package:air_libre_yoga/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Main app renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(BottomNavigationBar), findsOneWidget);

    await tester.tap(find.byIcon(Icons.fax_rounded));
    await tester.pump();

    expect(find.text("Session"), findsWidgets);

    await tester.tap(find.byIcon(Icons.map_rounded));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.person_rounded));
    await tester.pump();

    expect(find.text('Peoples'), findsWidgets);
  });
}
