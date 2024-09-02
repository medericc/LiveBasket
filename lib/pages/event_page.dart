import 'package:flutter/material.dart';
import './home_page.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final events = [
    {
      "speaker": "Lior",
      "date": "12",
      "subject": "Le Code",
      "avatar": "lior"
    },
    {
      "speaker": "Damso",
      "date": "14",
      "subject": "Le Codeb",
      "avatar": "damien"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Planning"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index]; // Correct reference to the map
            final avatar = event['avatar'];
            final speaker = event['speaker'];
            final date = event['date'];
            final subject = event['subject'];

            return ListTile(
              leading: Image.asset("assets/images/$avatar.jpg"),
              title: Text('$speaker ($date)'),
              subtitle: Text('$subject'),
              trailing: const Icon(Icons.more_vert),
            );
          },
        ),
      ),
    );
  }
}
