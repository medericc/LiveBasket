import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<Player> players = [];  // List to store the players' stats
  int totalPoints = 0;

  @override
  void initState() {
    super.initState();
    _loadPlayerStats();  // Load player stats from SharedPreferences
    _loadMatchStats();   // Load match total points
  }

  // Load player stats
  void _loadPlayerStats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Assuming you have a list of player names
    List<String> playerNames = ['Player1', 'Player2', 'Player3']; // Example player names

    setState(() {
      players = playerNames.map((name) {
        return Player(
          name: name,
          number: 0,
          points: prefs.getInt('${name}_points') ?? 0,
          rebounds: prefs.getInt('${name}_rebounds') ?? 0,
          assists: prefs.getInt('${name}_assists') ?? 0,
          gamesPlayed: prefs.getInt('${name}_gamesPlayed') ?? 0,
        );
      }).toList();
    });
  }

  // Load match statistics
  void _loadMatchStats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      totalPoints = prefs.getInt('totalPoints') ?? 0;  // Load the total points for the match
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display match total points
            Text(
              'Total Points: $totalPoints',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Display each player's stats
            Expanded(
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  Player player = players[index];
                  return Card(
                    child: ListTile(
                      title: Text(player.name),
                      subtitle: Text(
                        'Points: ${player.points}\nRebounds: ${player.rebounds}\nAssists: ${player.assists}\nGames Played: ${player.gamesPlayed}',
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
