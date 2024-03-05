import 'package:air_libre_yoga/main.dart';
import 'package:air_libre_yoga/views/presence_view.dart';
import 'package:air_libre_yoga/views/session_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PresenceView renders correctly', (WidgetTester tester) async {
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

    // Verify if the list of presences is rendered
    expect(find.byType(ListTile), findsNWidgets(9));
  });

  testWidgets('All bottomDialog renders correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.fax_rounded));
    await tester.pumpAndSettle();

    // Verify if SessionView is rendered
    expect(find.byType(SessionView), findsOneWidget);

    // Tap on the first session's "Presences" button
    await tester.tap(find.text('Presences').first);
    await tester.pumpAndSettle();

    expect(find.byType(PresenceView), findsOneWidget);

    //Tap on the Warning icon
    await tester.tap(find.byIcon(Icons.warning_amber_rounded).first);
    await tester.pumpAndSettle();

    expect(find.text('Avertissement'), findsOneWidget);

    await tester.tap(find.text('Ok'));
    await tester.pumpAndSettle();

    //Tap on the Trash icon
    await tester.tap(find.byIcon(Icons.delete_outline_rounded).first);
    await tester.pumpAndSettle();

    expect(find.text('Annuler'), findsOneWidget);
    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();
  });

  testWidgets('Delete yogi correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.fax_rounded));
    await tester.pumpAndSettle();

    // Verify if SessionView is rendered
    expect(find.byType(SessionView), findsOneWidget);

    // Tap on the first session's "Presences" button
    await tester.tap(find.text('Presences').first);
    await tester.pumpAndSettle();

    expect(find.byType(PresenceView), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(9));

    //Tap on the Trash icon
    await tester.tap(find.byIcon(Icons.delete_outline_rounded).first);
    await tester.pumpAndSettle();

    //Tap on the "Oui" button
    await tester.tap(find.text('Confirmer'));
    await tester.pumpAndSettle();
  });

  testWidgets('Add yogi correctly FOR TEST', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.fax_rounded));
    await tester.pumpAndSettle();
  });
}
