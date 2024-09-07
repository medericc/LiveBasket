import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'stats_screen.dart'; // Import StatsScreen
import 'hist_screen.dart';  // Import HistScreen

class TeamsScreen extends StatefulWidget {
  @override
  _TeamsScreenState createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  List<String> _teams = [];

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    final prefs = await SharedPreferences.getInstance();
    final teams = prefs.getStringList('teams') ?? [];
    setState(() {
      _teams = teams;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des équipes'),
      ),
      body: _teams.isEmpty
          ? Center(child: Text('Aucune équipe enregistrée.'))
          : ListView.builder(
              itemCount: _teams.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_teams[index]),
                  onTap: () {
                    _navigateToStats(context, _teams[index]);
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.history),
                    onPressed: () {
                      _navigateToHistory(context, _teams[index]);
                    },
                  ),
                );
              },
            ),
    );
  }

  Future<void> _navigateToStats(BuildContext context, String teamName) async {
    final prefs = await SharedPreferences.getInstance();
    final players = prefs.getStringList('players_$teamName') ?? [];

    // Navigate to the StatsScreen, passing the team name and its players
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StatsScreen(teamName: teamName, players: players),
      ),
    );
  }

  Future<void> _navigateToHistory(BuildContext context, String teamName) async {
    final prefs = await SharedPreferences.getInstance();
    final players = prefs.getStringList('players_$teamName') ?? [];

    // Navigate to the HistScreen, passing both the team name and its players
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistScreen(teamName: teamName, players: players),
      ),
    );
  }
}
