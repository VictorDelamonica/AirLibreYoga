import 'package:flutter/material.dart';

import '../utilities/yogi_class.dart';

class PeopleView extends StatefulWidget {
  const PeopleView({super.key});

  @override
  State<PeopleView> createState() => _PeopleViewState();
}

class _PeopleViewState extends State<PeopleView> {
  final Map<Yogi, bool> _yogiList = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Yogi.getALlYogi().then((List<Yogi> yogis) {
      for (var yogi in yogis) {
        setState(() {
          _yogiList[yogi] = yogi.value;
        });
      }
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? const CircularProgressIndicator()
          : ListView.separated(
              itemBuilder: (context, index) {
                Yogi yogi = _yogiList.keys.elementAt(index);
                return ListTile(
                  title: Text(yogi.name),
                  trailing: SizedBox(
                    width: 70,
                    child: Row(
                      children: [
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
                          child: const Icon(Icons.phone_enabled_rounded),
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
    );
  }
}
