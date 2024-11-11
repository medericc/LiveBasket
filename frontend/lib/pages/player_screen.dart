// lib/pages/player_screen.dart
import 'package:flutter/material.dart';

class PlayerScreen extends StatelessWidget {
  final String teamName;

  // Constructeur pour recevoir le nom de l'équipe
  PlayerScreen({required this.teamName});

  final List<Map<String, dynamic>> players = [
    {'name': 'Player 1', 'points': 20, 'gamesPlayed': 5, 'rebounds': 10, 'assists': 5},
    {'name': 'Player 2', 'points': 15, 'gamesPlayed': 4, 'rebounds': 8, 'assists': 4},
    // Ajouter plus de joueurs avec leurs stats ici
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Players - $teamName'),
      ),
      body: ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) {
          final player = players[index];
          final pointsPerGame = player['gamesPlayed'] > 0 ? (player['points'] / player['gamesPlayed']).toStringAsFixed(2) : '0.00';
          final reboundsPerGame = player['gamesPlayed'] > 0 ? (player['rebounds'] / player['gamesPlayed']).toStringAsFixed(2) : '0.00';
          final assistsPerGame = player['gamesPlayed'] > 0 ? (player['assists'] / player['gamesPlayed']).toStringAsFixed(2) : '0.00';

          return Card(
            child: ListTile(
              title: Text(player['name']),
              subtitle: Text(
                'Points: ${player['points']} (Avg: $pointsPerGame)\n'
                'Rebounds: ${player['rebounds']} (Avg: $reboundsPerGame)\n'
                'Assists: ${player['assists']} (Avg: $assistsPerGame)\n'
                'Games Played: ${player['gamesPlayed']}',
              ),
            ),
          );
        },
      ),
    );
  }
}
