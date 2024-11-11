import 'package:flutter/material.dart';
import 'player_detail_screen.dart';
import '../models/player.dart';
import '../models/team.dart';

class TeamEntryScreen extends StatefulWidget {
  final List<Team> existingTeams;

  TeamEntryScreen({required this.existingTeams});

  @override
  _TeamEntryScreenState createState() => _TeamEntryScreenState();
}

class _TeamEntryScreenState extends State<TeamEntryScreen> {
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _playerNameController = TextEditingController();
  final TextEditingController _playerNumberController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final List<Player> _players = [];
  String _sortOption = 'Numéro'; // Options: 'Numéro' ou 'Nom'
  String _searchText = '';

  void _addPlayer() {
    final playerName = _playerNameController.text;
    final playerNumberText = _playerNumberController.text;
    final playerNumber = int.tryParse(playerNumberText);

    if (playerName.isEmpty || playerNumber == null) {
      _showErrorDialog("Veuillez entrer un nom valide et un numéro valide pour le joueur.");
    } else {
      setState(() {
        _players.add(Player(name: playerName, number: playerNumber));
        _playerNameController.clear();
        _playerNumberController.clear();
      });
    }
  }

  void _removePlayer(int index) {
    setState(() {
      _players.removeAt(index);
    });
  }

  void _navigateToPlayerDetail(Player player) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerDetailScreen(player: player),
      ),
    ).then((_) {
      setState(() {}); // Met à jour l'interface après modification des statistiques
    });
  }

  void _saveTeam() {
    final teamName = _teamNameController.text;

    bool teamExists = widget.existingTeams.any((team) => team.name.toLowerCase() == teamName.toLowerCase());

    if (teamName.isEmpty || _players.isEmpty) {
      _showErrorDialog("Veuillez entrer un nom d'équipe et ajouter au moins un joueur.");
    } else if (teamExists) {
      _showErrorDialog("Une équipe avec ce nom existe déjà.");
    } else {
      final newTeam = Team(name: teamName, players: _players);
      Navigator.pop(context, newTeam); // Retourne la nouvelle équipe
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Erreur"),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
      ),
    );
  }

  void _sortPlayers() {
    setState(() {
      if (_sortOption == 'Nom') {
        _players.sort((a, b) => a.name.compareTo(b.name));
      } else {
        _players.sort((a, b) => a.number.compareTo(b.number));
      }
    });
  }

  List<Player> _getFilteredPlayers() {
    return _players
        .where((player) => player.name.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPlayers = _getFilteredPlayers();

    return Scaffold(
      appBar: AppBar(title: Text('Ajouter une équipe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _teamNameController,
              decoration: InputDecoration(labelText: 'Nom de l\'équipe'),
            ),
            TextField(
              controller: _playerNameController,
              decoration: InputDecoration(labelText: 'Nom du joueur'),
            ),
            TextField(
              controller: _playerNumberController,
              decoration: InputDecoration(labelText: 'Numéro du joueur'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(onPressed: _addPlayer, child: Text('Ajouter joueur')),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(labelText: 'Rechercher un joueur'),
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                  ),
                ),
                DropdownButton<String>(
                  value: _sortOption,
                  items: ['Numéro', 'Nom'].map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _sortOption = newValue!;
                      _sortPlayers();
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredPlayers.length,
                itemBuilder: (context, index) {
                  final player = filteredPlayers[index];
                  return ListTile(
                    title: Text(player.name),
                    subtitle: Text('Numéro: ${player.number}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removePlayer(index),
                    ),
                    onTap: () => _navigateToPlayerDetail(player),
                  );
                },
              ),
            ),
            ElevatedButton(onPressed: _saveTeam, child: Text('Enregistrer équipe')),
          ],
        ),
      ),
    );
  }
}
