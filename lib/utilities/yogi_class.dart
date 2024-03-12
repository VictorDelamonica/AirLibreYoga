import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class Yogi {
  final String name;
  bool value = false;
  String phone = '';
  bool isWarning = false;
  List<bool> sessionRegister = [];

  Yogi(
      {required this.name,
      this.value = false,
      this.isWarning = false,
      this.sessionRegister = const [],
      this.phone = ''});

  bool get isPresent => value;

  static Future<List<Yogi>> getALlYogi() async {
    List<Yogi> yogiList = [];

    FirebaseDatabase database = FirebaseDatabase.instanceFor(
      databaseURL:
          'https://air-libre-yoga-default-rtdb.europe-west1.firebasedatabase.app/',
      app: FirebaseDatabase.instance.app,
    );
    DatabaseReference ref = database.ref();

    DataSnapshot snapshot = await ref.get();
    if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> yogis = snapshot.value as Map<dynamic, dynamic>;
      yogis.forEach((yogiName, yogiData) {
        if (yogiData is Map<dynamic, dynamic>) {
          var yogi = Yogi(
            name: yogiName,
            value: yogiData['value'],
            phone: yogiData['phone'],
            isWarning: yogiData['Warning'],
            sessionRegister: [
              yogiData['Sessions']['LUNDI 10h a 11h']['isRegistered'],
              yogiData['Sessions']['LUNDI 12h30 a 13h25']['isRegistered'],
              yogiData['Sessions']['LUNDI 19h a 20h']['isRegistered'],
            ],
          );
          yogiList.add(yogi);
        }
      });
    }
    return yogiList;
  }

  static Future<void> updateYogi(Yogi yogi) async {
    FirebaseDatabase database = FirebaseDatabase.instanceFor(
      databaseURL:
          'https://air-libre-yoga-default-rtdb.europe-west1.firebasedatabase.app/',
      app: FirebaseDatabase.instance.app,
    );
    DatabaseReference ref = database.ref(yogi.name);
    await ref.update({'value': yogi.value});
  }

  static Future<void> deleteYogi(Yogi yogi) async {
    FirebaseDatabase database = FirebaseDatabase.instanceFor(
      databaseURL:
          'https://air-libre-yoga-default-rtdb.europe-west1.firebasedatabase.app/',
      app: FirebaseDatabase.instance.app,
    );
    DatabaseReference ref = database.ref(yogi.name);
    await ref.remove();
  }

  static Future<void> addYogi(Yogi yogi) async {
    FirebaseDatabase database = FirebaseDatabase.instanceFor(
      databaseURL:
          'https://air-libre-yoga-default-rtdb.europe-west1.firebasedatabase.app/',
      app: FirebaseDatabase.instance.app,
    );

    var session1 = yogi.sessionRegister[0] ? true : false;
    var session2 = yogi.sessionRegister[1] ? true : false;
    var session3 = yogi.sessionRegister[2] ? true : false;

    DatabaseReference ref = database.ref(yogi.name);
    var json = {
      'Missing': 0,
      'value': yogi.value,
      'phone': yogi.phone,
      'Sessions': {
        'LUNDI 10h a 11h': {
          'isRegistered': session1,
        },
        'LUNDI 12h30 a 13h25': {
          'isRegistered': session2,
        },
        'LUNDI 19h a 20h': {
          'isRegistered': session3,
        },
      },
      'Warning': yogi.value
    };
    if (kDebugMode) {
      print('Adding Yogi: ${yogi.name}\n$json');
    }
    await ref.set(json);
  }

  static Future<void> addTestYogi() async {
    FirebaseDatabase database = FirebaseDatabase.instanceFor(
      databaseURL:
          'https://air-libre-yoga-default-rtdb.europe-west1.firebasedatabase.app',
      app: FirebaseDatabase.instance.app,
    );

    var session1 = true;
    var session2 = false;
    var session3 = false;

    DatabaseReference ref = database.ref("Test");
    var json = {
      'Missing': 0,
      'value': false,
      'phone': "yogi.phone",
      'Sessions': {
        'LUNDI 10h a 11h': {
          'isRegistered': session1,
        },
        'LUNDI 12h30 a 13h25': {
          'isRegistered': session2,
        },
        'LUNDI 19h a 20h': {
          'isRegistered': session3,
        },
      },
      'Warning': false
    };
    if (kDebugMode) {
      print(database.databaseURL);
      print(ref.path);
      print(ref.key);
      print('Adding Yogi: ${"Test"}\n$json');
    }
    await ref.set(json);
    await ref.update({'value': true});
    await ref.set({'ERTYUI': false});
  }
}
