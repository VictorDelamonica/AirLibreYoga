import 'package:air_libre_yoga/views/empty_view.dart';
import 'package:air_libre_yoga/views/session_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Air Libre Yoga',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const EmbeddedViews(),
    );
  }
}

class EmbeddedViews extends StatefulWidget {
  const EmbeddedViews({super.key});

  @override
  State<EmbeddedViews> createState() => _EmbeddedViewsState();
}

class _EmbeddedViewsState extends State<EmbeddedViews> {
  static const _kEmbeddedViews = <String, Widget>{
    'Session': SessionView(),
    'Other': EmptyView(),
    'Peoples': EmptyView(),
  };

  static const _kIcons = <String, IconData>{
    'Session': Icons.fax_rounded,
    'Other': Icons.map_rounded,
    'Peoples': Icons.person_rounded,
  };

  String _selectedView = 'Session';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedView),
      ),
      body: _kEmbeddedViews[_selectedView],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: _kEmbeddedViews.keys.map((String view) {
          return BottomNavigationBarItem(
            icon: Icon(_kIcons[view]),
            label: view,
          );
        }).toList(),
        currentIndex: _kEmbeddedViews.keys.toList().indexOf(_selectedView),
        onTap: (int index) {
          setState(() {
            _selectedView = _kEmbeddedViews.keys.toList()[index];
          });
        },
      ),
    );
  }
}
