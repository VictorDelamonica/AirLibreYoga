// import 'package:air_libre_yoga/firebase_options.dart';
// import 'package:air_libre_yoga/main.dart';
// import 'package:air_libre_yoga/utilities/mock_class.dart';
// import 'package:air_libre_yoga/views/presence_view.dart';
// import 'package:air_libre_yoga/views/session_view.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';

Future<void> main() async {
  
//   const String appName = "Presence View";
//   final mock = await setUpAllMock(testAppName: appName);

//   test('Main app renders correctly', () {
//     List<FirebaseApp> apps = Firebase.apps;
//     verify(mock.apps);
//     expect(apps[0], Firebase.app(appName));
//   } );

//   testWidgets('PresenceView renders correctly', (WidgetTester tester) async {
//     await tester.pumpWidget(mock.apps[0]);

//     await tester.tap(find.byIcon(Icons.fax_rounded));
//     await tester.pumpAndSettle();

//     // Verify if SessionView is rendered
//     expect(find.byType(SessionView), findsOneWidget);

//     // Verify if SessionCardView widgets are rendered
//     expect(find.byType(SessionCardView), findsNWidgets(3));

//     // Verify if PresenceView is not initially rendered
//     expect(find.byType(PresenceView), findsNothing);

//     // Tap on the first session's "Presences" button
//     await tester.tap(find.text('Presences').first);
//     await tester.pumpAndSettle();

//     expect(find.byType(PresenceView), findsOneWidget);

//     // Verify if the list of presences is rendered
//     expect(find.byType(ListTile), findsNWidgets(9));
//   });

//   testWidgets('All bottomDialog renders correctly',
//       (WidgetTester tester) async {
//     await tester.pumpWidget(const MyApp());

//     await tester.tap(find.byIcon(Icons.fax_rounded));
//     await tester.pumpAndSettle();

//     // Verify if SessionView is rendered
//     expect(find.byType(SessionView), findsOneWidget);

//     // Tap on the first session's "Presences" button
//     await tester.tap(find.text('Presences').first);
//     await tester.pumpAndSettle();

//     expect(find.byType(PresenceView), findsOneWidget);

//     //Tap on the Warning icon
//     await tester.tap(find.byIcon(Icons.warning_amber_rounded).first);
//     await tester.pumpAndSettle();

//     expect(find.text('Avertissement'), findsOneWidget);

//     await tester.tap(find.text('Ok'));
//     await tester.pumpAndSettle();

//     //Tap on the Trash icon
//     await tester.tap(find.byIcon(Icons.delete_outline_rounded).first);
//     await tester.pumpAndSettle();

//     expect(find.text('Annuler'), findsOneWidget);
//     await tester.tap(find.text('Annuler'));
//     await tester.pumpAndSettle();
//   });
}
