import 'package:air_libre_yoga/utilities/mock_class.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() async {

  const String appName = "My App";
  final mock = await setUpAllMock(testAppName: appName);

  test('Main app renders correctly', () {
    List<FirebaseApp> apps = Firebase.apps;
    verify(mock.apps);
    expect(apps[0], Firebase.app(appName));
  } );
}