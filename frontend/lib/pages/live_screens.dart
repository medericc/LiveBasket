import 'package:flutter/material.dart';
import 'package:nom_du_projet/pages/match_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LiveScreen extends StatefulWidget {
  @override
  _LiveScreenState createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  final TextEditingController _teamController = TextEditingController();
  final List<TextEditingController> _playerControllers = [];
  int _playerCount = 0;
  List<String> _existingTeams = [];

  @override
  void initState() {
    super.initState();
    _loadExistingTeams();
  }

  @override
  void dispose() {
    _teamController.dispose();
    for (var controller in _playerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadExistingTeams() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _existingTeams = prefs.getStringList('teams') ?? [];
    });
  }

void _addPlayer() {
  setState(() {
    _playerCount++;
    _playerControllers.add(TextEditingController());
  });
}

void _removePlayer(int index) {
  setState(() {
    _playerControllers[index].dispose();
    _playerControllers.removeAt(index);
    _playerCount--;
  });
}

bool _isPlayerNameUnique(String playerName) {
  final existingPlayers = _playerControllers.map((controller) => controller.text).toList();
  return !existingPlayers.contains(playerName);
}


void _startMatch() async {
  final teamName = _teamController.text;
  final players = _playerControllers.map((controller) => controller.text).toList();

  // Vérification des noms uniques
  if (players.toSet().length != players.length) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Les noms des joueurs doivent être uniques.')),
    );
    return;
  }

  // Vérifier si l'équipe et tous les joueurs sont renseignés
  if (teamName.isNotEmpty && players.every((player) => player.isNotEmpty)) {
    await _saveTeamAndPlayers(teamName, players);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MatchScreen(
          teamName: teamName,
          players: players,
        ),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Veuillez entrer le nom de l\'équipe et tous les noms des joueurs.')),
    );
  }
}

  Future<void> _saveTeamAndPlayers(String teamName, List<String> players) async {
    final prefs = await SharedPreferences.getInstance();
    final teams = prefs.getStringList('teams') ?? [];

    if (!teams.contains(teamName)) {
      teams.add(teamName);
      await prefs.setStringList('teams', teams);
    }

    await prefs.setStringList('players_$teamName', players);
  }

  Future<void> _loadTeamPlayers(String teamName) async {
    final prefs = await SharedPreferences.getInstance();
    final players = prefs.getStringList('players_$teamName') ?? [];

    _teamController.text = teamName;
    _playerControllers.clear();

    setState(() {
      _playerCount = players.length;
      for (var player in players) {
        _playerControllers.add(TextEditingController(text: player));
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un Match'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _teamController,
              decoration: InputDecoration(
                labelText: 'Nom de l\'équipe',
              ),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              hint: Text('Sélectionner une équipe existante'),
              items: _existingTeams.map((String team) {
                return DropdownMenuItem<String>(
                  value: team,
                  child: Text(team),
                );
              }).toList(),
              onChanged: (String? selectedTeam) {
                if (selectedTeam != null) {
                  _loadTeamPlayers(selectedTeam);
                }
              },
            ),
            SizedBox(height: 16),
            Text('Joueurs'),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _playerCount,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: TextField(
                      controller: _playerControllers[index],
                      decoration: InputDecoration(
                        labelText: 'Joueur ${index + 1}',
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle),
                      onPressed: () => _removePlayer(index),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addPlayer,
              child: Text('Ajouter un joueur'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _startMatch,
              child: Text('Démarrer le Match'),
            ),
          ],
        ),
      ),
    );
  }
}
