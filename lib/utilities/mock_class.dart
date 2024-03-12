// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:air_libre_yoga/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

class MockFirebaseCore extends Mock
    with
        MockPlatformInterfaceMixin // Use `with` for mixin
    implements
        FirebasePlatform  {
  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) {
    return super.noSuchMethod(
      Invocation.method(#app, [name]),
      returnValue: FakeFirebaseAppPlatform(),
      returnValueForMissingStub: FakeFirebaseAppPlatform(),
    );
  }

  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) {
    return super.noSuchMethod(
      Invocation.method(
        #initializeApp,
        const [],
        {
          #name: name,
          #options: options,
        },
      ),
      returnValue: Future.value(FakeFirebaseAppPlatform()),
      returnValueForMissingStub: Future.value(FakeFirebaseAppPlatform()),
    );
  }

  @override
  List<FirebaseAppPlatform> get apps {
    return super.noSuchMethod(
      Invocation.getter(#apps),
      returnValue: <FirebaseAppPlatform>[],
      returnValueForMissingStub: <FirebaseAppPlatform>[],
    );
  }
}

Future<MockFirebaseCore> setUpAllMock({String testAppName = 'testApp'}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final mock = MockFirebaseCore();

  const FirebaseOptions testOptions = DefaultFirebaseOptions.android;
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    clearInteractions(mock);
    Firebase.delegatePackingProperty = mock;

    final FirebaseAppPlatform platformApp =
        FirebaseAppPlatform(testAppName, testOptions);

    when(mock.apps).thenReturn([platformApp]);
    when(mock.app(testAppName)).thenReturn(platformApp);
    when(mock.initializeApp(name: testAppName, options: testOptions))
        .thenAnswer((_) {
      return Future.value(platformApp);
    });
  });
  return mock;
}

// ignore: avoid_implementing_value_types
class FakeFirebaseAppPlatform extends Fake implements FirebaseAppPlatform {}
