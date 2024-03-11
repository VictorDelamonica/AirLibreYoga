import 'package:firebase_database/firebase_database.dart';

class Yogi {
  final String name;
  bool value;
  bool isWarning = false;

  Yogi({required this.name, required this.value, this.isWarning = false});

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
      // Loop through each Yogi
      yogis.forEach((yogiName, yogiData) {
        if (yogiData is Map<dynamic, dynamic>) {
          if (yogiData.containsKey('Missing')) {
            if (yogiData['Missing'] >= 3) {
              yogiData['Warning'] = true;
            }
          }
          if (yogiData.containsKey('Warning')) {
            print('Warning: ${yogiData['Warning']}');
            yogiList.add(Yogi(
                name: yogiName,
                value: yogiData['value'] ?? false,
                isWarning: yogiData['Warning']));
          } else {
            yogiList
                .add(Yogi(name: yogiName, value: yogiData['value'] ?? false));
          }
        }
      });
    }
    return yogiList;
  }
}
