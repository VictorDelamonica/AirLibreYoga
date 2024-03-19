import 'package:firebase_analytics/firebase_analytics.dart';
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
    await FirebaseAnalytics.instance.logEvent(
      name: "upd_yogi",
      parameters: {
        "content_type": "string",
        "yogi_name": yogi.name,
      },
    );
  }

  static Future<void> deleteYogi(Yogi yogi) async {
    FirebaseDatabase database = FirebaseDatabase.instanceFor(
      databaseURL:
          'https://air-libre-yoga-default-rtdb.europe-west1.firebasedatabase.app/',
      app: FirebaseDatabase.instance.app,
    );
    DatabaseReference ref = database.ref(yogi.name);
    await ref.remove();
    await FirebaseAnalytics.instance.logEvent(
      name: "rem_yogi",
      parameters: {
        "content_type": "string",
        "yogi_name": yogi.name,
      },
    );
  }

  static Future<void> addYogi(Yogi yogi) async {
    FirebaseDatabase database = FirebaseDatabase.instanceFor(
      databaseURL:
          'https://air-libre-yoga-default-rtdb.europe-west1.firebasedatabase.app/',
      app: FirebaseDatabase.instance.app,
    );

    if (yogi.sessionRegister.length < 5) {
      for (var i = yogi.sessionRegister.length; i < 5; i++) {
        yogi.sessionRegister.add(false);
      }
    }

    DatabaseReference ref = database.ref(yogi.name);
    var json = {
      'Missing': 0,
      'value': yogi.value,
      'phone': yogi.phone,
      'Sessions': {
        'LUNDI 10h a 11h': {
          'isRegistered': yogi.sessionRegister[0],
          'attendees': List<String>.empty(growable: true),
        },
        'LUNDI 12h30 a 13h25': {
          'isRegistered': yogi.sessionRegister[1],
          'attendees': List<String>.empty(growable: true),
        },
        'LUNDI 19h a 20h': {
          'isRegistered': yogi.sessionRegister[2],
          'attendees': List<String>.empty(growable: true),
        },
        'MERCREDI 16h30 a 17h45': {
          'isRegistered': yogi.sessionRegister[3],
          'attendees': List<String>.empty(growable: true),
        },
        'MERCREDI 18h a 19h': {
          'isRegistered': yogi.sessionRegister[4],
          'attendees': List<String>.empty(growable: true),
        },
      },
      'Warning': yogi.value
    };
    if (kDebugMode) {
      print('Adding Yogi: ${yogi.name}\n$json');
    }
    await ref.set(json);
    await FirebaseAnalytics.instance.logEvent(
      name: "add_yogi",
      parameters: {
        "content_type": "string",
        "yogi_name": yogi.name,
      },
    );
  }
}
