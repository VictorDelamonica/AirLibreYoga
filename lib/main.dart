import 'package:air_libre_yoga/firebase_options.dart';
import 'package:air_libre_yoga/views/empty_view.dart';
import 'package:air_libre_yoga/views/people_view.dart';
import 'package:air_libre_yoga/views/session_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform
    );
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

  runApp(const MyApp());
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
    'Peoples': PeopleView(),
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
