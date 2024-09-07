import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'stats_screen.dart'; // Assurez-vous que l'écran Stats est bien importé

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
                    // Naviguer vers l'écran des statistiques de l'équipe
                    _navigateToStats(context, _teams[index]);
                  },
                );
              },
            ),
    );
  }

  Future<void> _navigateToStats(BuildContext context, String teamName) async {
    final prefs = await SharedPreferences.getInstance();
    final players = prefs.getStringList('players_$teamName') ?? [];

    // Naviguer vers l'écran Stats en passant les joueurs
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Stats(teamName: teamName, players: players),
      ),
    );
  }
}
