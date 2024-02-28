import 'package:air_libre_yoga/main.dart';
import 'package:air_libre_yoga/views/presence_view.dart';
import 'package:air_libre_yoga/views/session_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SessionView renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.fax_rounded));
    await tester.pumpAndSettle();

    // Verify if SessionView is rendered
    expect(find.byType(SessionView), findsOneWidget);

    // Verify if SessionCardView widgets are rendered
    expect(find.byType(SessionCardView), findsNWidgets(3));

    // Verify if PresenceView is not initially rendered
    expect(find.byType(PresenceView), findsNothing);

    // Tap on the first session's "Presences" button
    await tester.tap(find.text('Presences').first);
    await tester.pumpAndSettle();

    expect(find.byType(PresenceView), findsOneWidget);
    expect(find.text('Presence View'), findsOneWidget);
    expect(find.text('Day: LUNDI'), findsOneWidget);
    expect(find.text('Schedule: 10h a 11h'), findsOneWidget);
  });
}
