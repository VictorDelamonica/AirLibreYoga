import 'dart:async';

import 'package:air_libre_yoga/utilities/logger_class.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../utilities/yogi_class.dart';

class PresenceView extends StatefulWidget {
  const PresenceView(
      {super.key, required this.sessionDay, required this.sessionSchedule});

  final String sessionDay;
  final String sessionSchedule;

  @override
  State<PresenceView> createState() => _PresenceViewState();
}

class _PresenceViewState extends State<PresenceView> {
  List<Yogi> _yogiList = List.empty();
  String sessionAlias = 'allias';

  @override
  void initState() {
    sessionAlias = "${widget.sessionDay} ${widget.sessionSchedule}";
    super.initState();
    fetchYogiData();
  }

  Future<void> fetchYogiData() async {
    _yogiList = await fetchYogiList();
    await Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
    Logger.logInConsoleInfo('Yogi list fetched with ${_yogiList.length} yogis');
    await initPresent();
  }

  Future<List<Yogi>> fetchYogiList() async {
    List<Yogi> yogiList = [];

    FirebaseDatabase database = FirebaseDatabase.instanceFor(
      databaseURL:
          'https://air-libre-yoga-default-rtdb.europe-west1.firebasedatabase.app/',
      app: FirebaseDatabase.instance.app,
    );
    DatabaseReference ref = database.ref();

    DataSnapshot snapshot = await ref.get();

    if (snapshot.value != null) {
      Map<dynamic, dynamic> yogis = snapshot.value as Map<dynamic, dynamic>;
      // Loop through each Yogi
      yogis.forEach((yogiName, yogiData) {
        if (yogiData is Map<dynamic, dynamic>) {
          if (yogiData.containsKey('Sessions')) {
            Map<dynamic, dynamic> sessions = yogiData['Sessions'];
            if (sessions.containsKey(sessionAlias)) {
              Map<dynamic, dynamic> sessionData = sessions[sessionAlias];
              if (sessionData.containsKey('isRegistered')) {
                bool isRegistered = sessionData['isRegistered'];
                if (isRegistered) {
                  Logger.logInConsoleInfo(
                      'Yogi $yogiName is registered for $sessionAlias');
                  yogiList.add(Yogi(
                      name: yogiName,
                      isPresent: sessionData['isPresent'] ?? false,
                      isWarning: yogiData['Warning']));
                }
              }
            }
          }
        }
      });
    }

    return yogiList.reversed.toList();
  }

  int _present = 0;

  Future<void> initPresent() async {
    int present = 0;
    for (var yogi in _yogiList) {
      if (yogi.isPresent) {
        present++;
      }
    }
    setState(() {
      _present = present;
    });
  }

  getCurrentDate() {
    DateTime now = DateTime.now();
    String day = now.day.toString();
    String month = now.month.toString();
    String year = now.year.toString();
    return "$day-$month-$year";
  }

  Future<void> updateYogiList(Yogi y, bool v) async {
    FirebaseDatabase database = FirebaseDatabase.instanceFor(
      databaseURL:
          'https://air-libre-yoga-default-rtdb.europe-west1.firebasedatabase.app',
      app: FirebaseDatabase.instance.app,
    );
    DatabaseReference ref = database.ref();

    DataSnapshot snapshot = await ref.get();

    if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
      Map<dynamic, dynamic> yogis = snapshot.value as Map<dynamic, dynamic>;

      // Loop through each Yogi
      yogis.forEach((yogiName, yogiData) {
        if (yogiData is Map<dynamic, dynamic>) {
          if (yogiName == y.name) {
            if (yogiData.containsKey('Register') &&
                yogiData['Register'] is Map<dynamic, dynamic>) {
              Map<dynamic, dynamic> register =
                  yogiData['Register'] as Map<dynamic, dynamic>;

              // Check if the Yogi has been registered on the specific date
              if (register.containsKey(sessionAlias)) {
                //add the date to the register and keep the date already present
                if (register[sessionAlias] is Map<dynamic, dynamic>) {
                  Map<dynamic, dynamic> sessionData =
                      register[sessionAlias] as Map<dynamic, dynamic>;
                  sessionData[getCurrentDate()] = v;
                }
              }
            }
          }
        }
      });
      ref.set(yogis);
    }
  }

  bool yogiIsWarning(Yogi y) {
    int count = 0;
    FirebaseDatabase database = FirebaseDatabase.instanceFor(
      databaseURL:
          'https://air-libre-yoga-default-rtdb.europe-west1.firebasedatabase.app',
      app: FirebaseDatabase.instance.app,
    );
    DatabaseReference ref = database.ref();

    return ref.get().then((snapshot) {
          if (snapshot.value != null &&
              snapshot.value is Map<dynamic, dynamic>) {
            Map<dynamic, dynamic> yogis =
                snapshot.value as Map<dynamic, dynamic>;

            // Loop through each Yogi
            yogis.forEach((yogiName, yogiData) {
              if (yogiData is Map<dynamic, dynamic>) {
                if (yogiName == y.name) {
                  if (yogiData.containsKey('Register') &&
                      yogiData['Register'] is Map<dynamic, dynamic>) {
                    Map<dynamic, dynamic> register =
                        yogiData['Register'] as Map<dynamic, dynamic>;

                    // Check if the Yogi has been registered on the specific date
                    if (register.containsKey(sessionAlias)) {
                      //add the date to the register and keep the date already present
                      if (register[sessionAlias] is Map<dynamic, dynamic>) {
                        Map<dynamic, dynamic> sessionData =
                            register[sessionAlias] as Map<dynamic, dynamic>;
                        sessionData.forEach((date, value) {
                          if (value == false) {
                            count++;
                          }
                        });
                      }
                    }
                  }
                }
              }
            });
          }
          return count >= 2;
        }).toString() ==
        "true";
  }

  var _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool isPop) {
        Logger.logInConsoleInfo('Pop invoked: $isPop');
        if (isPop) {
          Yogi.updatePresence(_yogiList, sessionAlias);
        }
        //Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              "${widget.sessionDay} ${widget.sessionSchedule} - $_present / ${_yogiList.length}"),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 10);
                        },
                        itemCount: _yogiList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final yogiName = _yogiList.elementAt(index).name;
                          final isChecked =
                              _yogiList.elementAt(index).isPresent;

                          return ClipRRect(
                            child: ListTile(
                              title: Text(yogiName),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Checkbox(
                                      value: isChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _yogiList.elementAt(index).isPresent =
                                              value!;
                                          if (value == true) {
                                            _present++;
                                          } else {
                                            _present--;
                                          }
                                          updateYogiList(
                                              _yogiList.elementAt(index),
                                              value);
                                        });
                                      },
                                    ),
                                    _yogiList.elementAt(index).isWarning
                                        ? ClipRect(
                                            child: GestureDetector(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16),
                                                          width:
                                                              double.infinity,
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              const Text(
                                                                  'Avertissement',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          24)),
                                                              const SizedBox(
                                                                  height: 8),
                                                              Text(
                                                                  '$yogiName a manqué 3 cours'),
                                                              const SizedBox(
                                                                  height: 8),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: const SizedBox(
                                                                    width: 120,
                                                                    child: Text(
                                                                        'Ok',
                                                                        textAlign:
                                                                            TextAlign.center)),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    _yogiList
                                                                        .remove(
                                                                            yogiName);
                                                                  });
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: const SizedBox(
                                                                    width: 120,
                                                                    child: Text(
                                                                        'Le retirer du cours',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .redAccent),
                                                                        textAlign:
                                                                            TextAlign.center)),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                },
                                                child: const Icon(
                                                  Icons.warning_amber_rounded,
                                                  color: Colors.orangeAccent,
                                                )))
                                        : const Icon(
                                            Icons.warning_amber_rounded,
                                            color: Colors.transparent,
                                          ),
                                    ClipRect(
                                        child: GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      width: double.infinity,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          const Text(
                                                              'Confirmation',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      24)),
                                                          const SizedBox(
                                                              height: 8),
                                                          Text(
                                                              'Voulez-vous vraiment retirer $yogiName du cours?'),
                                                          const SizedBox(
                                                              height: 8),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child:
                                                                const SizedBox(
                                                                    width: 100,
                                                                    child: Text(
                                                                      'Annuler',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    )),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                _yogiList.remove(
                                                                    yogiName);
                                                              });
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const SizedBox(
                                                                width: 100,
                                                                child: Text(
                                                                    'Confirmer',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .redAccent),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center)),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            },
                                            child: const Icon(
                                              Icons.delete_outline_rounded,
                                              color: Colors.redAccent,
                                            )))
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
