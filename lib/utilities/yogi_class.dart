import 'package:air_libre_yoga/utilities/logger_class.dart';
import 'package:firebase_database/firebase_database.dart';

class Yogi {
  final String name;
  bool isPresent = false;
  String phone = '';
  bool isWarning = false;
  List<bool> sessionRegister = [];

  Yogi(
      {required this.name,
      this.isPresent = false,
      this.isWarning = false,
      this.sessionRegister = const [],
      this.phone = ''});

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
            isPresent: yogiData['isPresent'] ?? false,
            phone: yogiData['phone'],
            isWarning: yogiData['Warning'],
            sessionRegister: [
              yogiData['Sessions']['LUNDI 10h a 11h']['isRegistered'],
              yogiData['Sessions']['LUNDI 12h30 a 13h25']['isRegistered'],
              yogiData['Sessions']['LUNDI 19h a 20h']['isRegistered'],
              yogiData['Sessions']['MERCREDI 16h30 a 17h45']['isRegistered'],
              yogiData['Sessions']['MERCREDI 18h a 19h']['isRegistered'],
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
    var json = {
      'Missing': 0,
      'phone': yogi.phone,
      'Sessions': {
        'LUNDI 10h a 11h': {
          'isRegistered': yogi.sessionRegister[0],
          'isPresent': false,
          'attendees': List<String>.empty(growable: true),
        },
        'LUNDI 12h30 a 13h25': {
          'isRegistered': yogi.sessionRegister[1],
          'isPresent': false,
          'attendees': List<String>.empty(growable: true),
        },
        'LUNDI 19h a 20h': {
          'isRegistered': yogi.sessionRegister[2],
          'isPresent': false,
          'attendees': List<String>.empty(growable: true),
        },
        'MERCREDI 16h30 a 17h45': {
          'isRegistered': yogi.sessionRegister[3],
          'isPresent': false,
          'attendees': List<String>.empty(growable: true),
        },
        'MERCREDI 18h a 19h': {
          'isRegistered': yogi.sessionRegister[4],
          'isPresent': false,
          'attendees': List<String>.empty(growable: true),
        },
      },
      'Warning': yogi.isWarning
    };
    await ref.update(json);
    Logger.logInFirebase("update_yogi", {"yogi_name": yogi.name});
    Logger.logInConsoleInfo("Yogi ${yogi.name} updated");
  }

  static Future<void> deleteYogi(Yogi yogi) async {
    FirebaseDatabase database = FirebaseDatabase.instanceFor(
      databaseURL:
          'https://air-libre-yoga-default-rtdb.europe-west1.firebasedatabase.app/',
      app: FirebaseDatabase.instance.app,
    );
    DatabaseReference ref = database.ref(yogi.name);
    await ref.remove();
    Logger.logInFirebase("rem_yogi", {"yogi_name": yogi.name});
    Logger.logInConsoleInfo("Yogi ${yogi.name} removed");
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
      'value': yogi.isPresent,
      'phone': yogi.phone,
      'Sessions': {
        'LUNDI 10h a 11h': {
          'isRegistered': yogi.sessionRegister[0],
          'isPresent': false,
          'attendees': List<String>.empty(growable: true),
        },
        'LUNDI 12h30 a 13h25': {
          'isRegistered': yogi.sessionRegister[1],
          'isPresent': false,
          'attendees': List<String>.empty(growable: true),
        },
        'LUNDI 19h a 20h': {
          'isRegistered': yogi.sessionRegister[2],
          'attendees': List<String>.empty(growable: true),
          'isPresent': false,
        },
        'MERCREDI 16h30 a 17h45': {
          'isRegistered': yogi.sessionRegister[3],
          'attendees': List<String>.empty(growable: true),
          'isPresent': false,
        },
        'MERCREDI 18h a 19h': {
          'isRegistered': yogi.sessionRegister[4],
          'attendees': List<String>.empty(growable: true),
          'isPresent': false,
        },
      },
      'Warning': yogi.isPresent
    };
    await ref.set(json);
    Logger.logInFirebase("add_yogi", {"yogi_name": yogi.name});
    Logger.logInConsoleInfo("Yogi ${yogi.name} added");
  }

  static void updateAllYogi() {
    getALlYogi().then((yogis) {
      for (var yogi in yogis) {
        updateYogi(yogi);
      }
    });
  }

  static void updatePresence(List<Yogi> yogiList, String sessionAlias) {
    FirebaseDatabase database = FirebaseDatabase.instanceFor(
      databaseURL:
          'https://air-libre-yoga-default-rtdb.europe-west1.firebasedatabase.app/',
      app: FirebaseDatabase.instance.app,
    );
    DatabaseReference ref = database.ref();

    var nbPresent = 0;
    for (var yogi in yogiList) {
      if (yogi.isPresent) {
        nbPresent++;
      }
      ref.child(yogi.name).child('Sessions').child(sessionAlias).update({
        'isPresent': yogi.isPresent,
      });
    }
    Logger.logInFirebase("update_presence",
        {"session_alias": sessionAlias, "nb_present": nbPresent});
  }
}
