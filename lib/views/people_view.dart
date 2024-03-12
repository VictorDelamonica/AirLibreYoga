import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utilities/yogi_class.dart';

class PeopleView extends StatefulWidget {
  const PeopleView({super.key});

  @override
  State<PeopleView> createState() => _PeopleViewState();
}

class _PeopleViewState extends State<PeopleView> {
  late List<Yogi> _yogiList;
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(true);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool _session1 = false;
  bool _session2 = false;
  bool _session3 = false;

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  void refreshList({re = false}) async {
    _yogiList = [];
    _isLoading.value = true;
    await Yogi.getALlYogi().then((List<Yogi> yogis) {
      for (var yogi in yogis) {
        setState(() {
          _yogiList.add(yogi);
        });
      }
    });
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading.value = false;
      });
    });
    if (kDebugMode) {
      print('Yogi list: $_yogiList');
    }
    re ? refreshList(re: false) : null;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isLoading,
      builder: (BuildContext context, bool value, Widget? child) {
        return Center(
          child: _isLoading.value == true
              ? const CircularProgressIndicator()
              : Stack(children: [
                  ListView.separated(
                      itemBuilder: (context, index) {
                        Yogi yogi = _yogiList.elementAt(index);
                        return ListTile(
                          title: Text(yogi.name),
                          trailing: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Supprimer'),
                                            content: Text(
                                                'Voulez-vous supprimer ${yogi.name} ?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Yogi.deleteYogi(yogi);
                                                  Navigator.pop(context);
                                                  refreshList();
                                                },
                                                child: const Text('Supprimer'),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: const Icon(Icons.delete_rounded),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Avertissement'),
                                            content: Text(
                                                '${yogi.name} a manqué plusieurs séances'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Ok'),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: Icon(Icons.warning_amber_outlined,
                                      color: yogi.isWarning
                                          ? Colors.amber
                                          : Colors.transparent),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Appeler'),
                                            content: Text(
                                                'Voulez-vous appeler ${yogi.name} ?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Appeler'),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child:
                                      const Icon(Icons.phone_enabled_rounded),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemCount: _yogiList.length),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text('Ajouter un Yogi',
                                            style: TextStyle(fontSize: 24)),
                                        const SizedBox(height: 16),
                                        TextField(
                                          decoration: const InputDecoration(
                                            labelText: 'Nom du Yogi',
                                            border: OutlineInputBorder(),
                                          ),
                                          controller: nameController,
                                        ),
                                        const SizedBox(height: 16),
                                        TextField(
                                          keyboardType: TextInputType.phone,
                                          decoration: const InputDecoration(
                                            labelText: 'Téléphone',
                                            border: OutlineInputBorder(),
                                          ),
                                          controller: phoneController,
                                        ),
                                        const SizedBox(height: 16),
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text("Lundi 10h a 11h"),
                                                Checkbox(
                                                    value: _session1,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _session1 = value!;
                                                      });
                                                    }),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text("Lundi 19h a 20h"),
                                                Checkbox(
                                                    value: _session2,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _session2 = value!;
                                                      });
                                                    }),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                    "Mercredi 10h a 11h"),
                                                Checkbox(
                                                    value: _session3,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _session3 = value!;
                                                      });
                                                    }),
                                              ],
                                            ),
                                          ],
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (nameController.text.isEmpty) {
                                              return;
                                            }
                                            var yogi = Yogi(
                                              name: nameController.text,
                                              value: false,
                                              phone: phoneController.text,
                                              sessionRegister: [
                                                _session1,
                                                _session2,
                                                _session3
                                              ],
                                            );
                                            Yogi.addYogi(yogi);
                                            Navigator.pop(context);
                                            refreshList(re: true);
                                          },
                                          child: const Text('Ajouter'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            });
                      },
                      child: const Icon(Icons.add_rounded),
                    ),
                  )
                ]),
        );
      },
    );
  }
}
