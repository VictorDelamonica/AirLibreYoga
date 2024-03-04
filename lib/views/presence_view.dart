import 'package:flutter/material.dart';

class PresenceView extends StatefulWidget {
  const PresenceView(
      {super.key, required this.sessionDay, required this.sessionSchedule});

  final String sessionDay;
  final String sessionSchedule;

  @override
  State<PresenceView> createState() => _PresenceViewState();
}

class _PresenceViewState extends State<PresenceView> {
  late Map<String, bool> _yogiList;

  @override
  void initState() {
    super.initState();
    _initializeYogiList();
  }

  void _initializeYogiList() {
    _yogiList = {
      'Yogi 1': false,
      'Yogi 2': false,
      'Yogi 3': false,
      'Yogi 4': false,
      'Yogi 5': false,
      'Yogi 6': false,
      'Yogi 7': false,
      'Yogi 8': false,
      'Yogi 9': false,
      'Yogi 10': false,
    };
  }

  int _present = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.sessionDay} ${widget.sessionSchedule} - $_present / ${_yogiList.length}"),
      ),
      body: Center(
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
                  final yogiName = _yogiList.keys.elementAt(index);
                  final isChecked = _yogiList[yogiName] ?? false;

                  return ClipRRect(
                    child: ListTile(
                      title: Text(yogiName),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Checkbox(
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _yogiList[yogiName] = value ?? false;
                                  if (value == true) {
                                    _present++;
                                  } else {
                                    _present--;
                                  }
                                });
                              },
                            ),
                            _yogiList[yogiName]!
                                ? const Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.transparent,
                                  )
                                : ClipRect(
                                    child: GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  width: double.infinity,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      const Text(
                                                          'Avertissement',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 24)),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                          '$yogiName a manqué 3 cours'),
                                                      const SizedBox(height: 8),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const SizedBox(
                                                            width: 120,
                                                            child: Text('Ok',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center)),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _yogiList.remove(
                                                                yogiName);
                                                          });
                                                          Navigator.of(context)
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
                                                                    TextAlign
                                                                        .center)),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                        child: const Icon(
                                          Icons.warning_amber_rounded,
                                          color: Colors.orangeAccent,
                                        ))),
                            ClipRect(
                                child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              padding: const EdgeInsets.all(16),
                                              width: double.infinity,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  const Text('Confirmation',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 24)),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                      'Voulez-vous vraiment retirer $yogiName du cours?'),
                                                  const SizedBox(height: 8),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const SizedBox(
                                                        width: 100,
                                                        child: Text(
                                                          'Annuler',
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _yogiList
                                                            .remove(yogiName);
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const SizedBox(
                                                        width: 100,
                                                        child: Text('Confirmer',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .redAccent),
                                                            textAlign: TextAlign
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
    );
  }
}