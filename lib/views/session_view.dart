import 'package:air_libre_yoga/views/presence_view.dart';
import 'package:flutter/material.dart';

class SessionView extends StatelessWidget {
  const SessionView({super.key});

  static const _kSessionCards = <SessionCardView>[
    SessionCardView(
      day: 'LUNDI',
      schedule: '10h a 11h',
      description:
          'Valbonne Village\nSalle St Bernardin\nrue de la Brague\nTous niveaux',
    ),
    SessionCardView(
      day: 'LUNDI',
      schedule: '12h30 a 13h25',
      description:
          'Valbonne Village\nSalle St Bernardin\nrue de la Brague\nPlutot avancé',
    ),
    SessionCardView(
      day: 'LUNDI',
      schedule: '19h a 20h',
      description:
          'Valbonne\nSalle St Helene\n407 ch. de la Verriere\nTous niveaux',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView(
        children: _kSessionCards,
      ),
    );
  }
}

class SessionCardView extends StatelessWidget {
  const SessionCardView({
    required this.day,
    required this.schedule,
    required this.description,
    super.key,
  });

  final String day;
  final String schedule;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 200,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Text>[
                Text(day,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                Text(schedule),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(description, style: const TextStyle(fontSize: 16)),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PresenceView(
                                sessionDay: day, sessionSchedule: schedule)));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('Presences',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
