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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Presence View'),
            Text('Day: ${widget.sessionDay}'),
            Text('Schedule: ${widget.sessionSchedule}'),
          ],
        ),
      ),
    );
  }
}
