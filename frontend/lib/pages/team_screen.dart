// lib/pages/team_screen.dart
import 'package:flutter/material.dart';
import './player_screen.dart';
class TeamScreen extends StatelessWidget {
  final List<String> teams = ['Team A', 'Team B', 'Team C']; // Exemple d'équipes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teams'),
      ),
      body: ListView.builder(
        itemCount: teams.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(teams[index]),
              onTap: () {
                // Navigation vers l'écran des joueurs avec l'équipe sélectionnée
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayerScreen(teamName: teams[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
