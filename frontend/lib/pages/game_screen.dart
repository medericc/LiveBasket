import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/team.dart';
import '../models/player.dart';

class GameScreen extends StatefulWidget {
  final List<Player> players;  // Accepting a list of players

  GameScreen({required this.players});  // Modify the constructor to accept a list of players

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<String> stats = ['Points', 'Rebounds', 'Assists', 'Games Played'];
  Player? selectedPlayer; // Variable to keep track of selected player
  List<Player> activePlayers = []; // To track players who are still in the match

  @override
  void initState() {
    super.initState();
    _initializeGamesPlayed();  // Initialize games played to 1 for all players
    _loadPlayerStats(); // Load player stats on startup
    activePlayers = List.from(widget.players); // Initially, all players are active
  }

  // Initialize gamesPlayed to 1 for all players
  void _initializeGamesPlayed() {
    for (var player in widget.players) {
      player.gamesPlayed = 1;  // Set to 1 as they are already selected
    }
  }

  // Load the player stats from SharedPreferences
  void _loadPlayerStats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var player in widget.players) {
      player.points = prefs.getInt('${player.name}_points') ?? 0;
      player.rebounds = prefs.getInt('${player.name}_rebounds') ?? 0;
      player.assists = prefs.getInt('${player.name}_assists') ?? 0;
      // No need to load gamesPlayed since we initialize it to 1 above
    }
    setState(() {}); // Refresh the UI after loading the stats
  }

  // Save the player stats to SharedPreferences
  void _savePlayerStats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var player in widget.players) {
      await prefs.setInt('${player.name}_points', player.points);
      await prefs.setInt('${player.name}_rebounds', player.rebounds);
      await prefs.setInt('${player.name}_assists', player.assists);
      await prefs.setInt('${player.name}_gamesPlayed', player.gamesPlayed);
    }
  }

  // Increment gamesPlayed for selected players
  void _incrementGamesPlayed() {
    for (var player in widget.players) {
      player.gamesPlayed += 1;  // Increment the games played for each player
    }
    _savePlayerStats(); // Save updated stats
  }

  // Stop match button functionality
 void _stopMatch() {
  int totalPoints = 0;
  for (var player in activePlayers) {
    if (selectedPlayer != player) {
      player.gamesPlayed = 0;
    } else {
      totalPoints += player.points;
    }
  }

  // Save match statistics
  _saveMatchStats(totalPoints);  // Save the match total points to SharedPreferences

  _savePlayerStats(); // Save the updated stats for each player

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Match has been stopped.')),
  );
}

void _saveMatchStats(int totalPoints) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('totalPoints', totalPoints); // Save total points for the match
}

  // Remove player from the match (if needed)
  void _removePlayerFromMatch(Player player) {
    setState(() {
      activePlayers.remove(player);  // Remove the player from the active players list
      player.gamesPlayed = 0;  // Set gamesPlayed to 0 for the player being removed
    });
    _savePlayerStats(); // Save the updated stats after removing the player
  }

  // Cancel match button functionality
  void _cancelMatch() {
    for (var player in widget.players) {
      // Reset stats or remove the players’ temporary stats if match is cancelled
      player.points = 0;
      player.rebounds = 0;
      player.assists = 0;
      player.gamesPlayed = 1;  // Reset gamesPlayed back to 1 (or 0 if you want to indicate no match was played)
    }
    _savePlayerStats(); // Save reset stats
    Navigator.pop(context); // Go back to previous screen (or reset state as needed)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drag and Drop Stats'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _savePlayerStats, // Save stats when the user clicks on save
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display the players' stats
            Column(
              children: widget.players.map((player) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPlayer = player; // Set selected player
                    });
                  },
                  child: Card(
                    color: selectedPlayer == player ? Colors.green : Colors.white,
                    child: ListTile(
                      title: Text(player.name),
                      subtitle: Text(
                        'Points: ${player.points}\nRebounds: ${player.rebounds}\nAssists: ${player.assists}\nGames Played: ${player.gamesPlayed}',
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 20),

            // Draggable stats (Points, Rebounds, etc.)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: stats.map((stat) {
                return Draggable<String>(
                  data: stat,
                  child: Card(
                    color: Colors.blueAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        stat,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  feedback: Material(
                    color: Colors.transparent,
                    child: Card(
                      color: Colors.blueAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          stat,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  childWhenDragging: Card(
                    color: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        stat,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 20),

            // DragTarget to accept stats and update the selected player's stats
            DragTarget<String>(
              builder: (context, candidateData, rejectedData) {
                return Card(
                  color: Colors.greenAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Drop Stats Here to Apply',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
              onAccept: (stat) {
                if (selectedPlayer != null) {
                  setState(() {
                    selectedPlayer?.updateStat(stat); // Update the stat for the selected player
                  });
                }
              },
            ),

            // Add Stop and Cancel Match buttons
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _stopMatch,
                  child: Text('Stop Match'),
                ),
                ElevatedButton(
                  onPressed: _cancelMatch,
                  child: Text('Cancel Match'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
