import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Ensure this import is correct
import 'package:nom_du_projet/pages/main_screen.dart';// Import the main_screen.dart file

class LiveScreen extends StatefulWidget {
  @override
  _LiveScreenState createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  final TextEditingController _teamController = TextEditingController();
  final List<TextEditingController> _playerControllers = [];
  int _playerCount = 0;

  @override
  void dispose() {
    // Dispose of controllers to avoid memory leaks
    _teamController.dispose();
    for (var controller in _playerControllers) {
      controller.dispose();
    }
    super.dispose();
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

  Future<void> _saveTeamAndPlayers(String teamName, List<String> players) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('teamName', teamName);
    await prefs.setStringList('players', players);
  }

  void _startMatch() async {
    final teamName = _teamController.text;
    final players = _playerControllers.map((controller) => controller.text).toList();

    if (teamName.isNotEmpty && players.every((player) => player.isNotEmpty)) {
      await _saveTeamAndPlayers(teamName, players);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
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
