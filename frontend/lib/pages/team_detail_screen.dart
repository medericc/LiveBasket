import 'package:flutter/material.dart';
import '../models/team.dart';
import '../models/player.dart';
import './game_screen.dart';

class TeamDetailScreen extends StatefulWidget {
  final Team team;

  TeamDetailScreen({required this.team});

  @override
  _TeamDetailScreenState createState() => _TeamDetailScreenState();
}

class _TeamDetailScreenState extends State<TeamDetailScreen> {
  // Track selected players
  List<Player> selectedPlayers = [];
  
  // Controllers for player name and number input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  void _removePlayer(int index) {
    setState(() {
      widget.team.players.removeAt(index);
    });
  }

  void _addPlayer() {
    final name = _nameController.text;
    final number = int.tryParse(_numberController.text);

    if (name.isNotEmpty && number != null) {
      setState(() {
        widget.team.players.add(Player(name: name, number: number));
        _nameController.clear();
        _numberController.clear();
      });
    } else {
      // Show a message if input is invalid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer un nom et un numéro valides.')),
      );
    }
  }

  // Handle player selection
  void _togglePlayerSelection(Player player) {
    setState(() {
      if (selectedPlayers.contains(player)) {
        selectedPlayers.remove(player);
      } else {
        selectedPlayers.add(player);
      }
    });
  }

  void _startMatch() {
    if (selectedPlayers.isNotEmpty) {
      // Navigate to the GameScreen with the selected players
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GameScreen(players: selectedPlayers),  // Pass the 'selectedPlayers' to the GameScreen
        ),
      );
    } else {
      // Optionally show a message if no player is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez sélectionner des joueurs pour démarrer le match.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Détails de l\'équipe: ${widget.team.name}')),
      body: Column(
        children: [
          // Display list of players
          Expanded(
            child: ListView.builder(
              itemCount: widget.team.players.length,
              itemBuilder: (context, index) {
                final player = widget.team.players[index];
                return ListTile(
  title: Text(player.name),
  subtitle: Text('Numéro: ${player.number}'),
  trailing: IconButton(
    icon: Icon(Icons.delete, color: Colors.red),
    onPressed: () => _removePlayer(index),
  ),
  onTap: () {
    _togglePlayerSelection(player);  // Toggle selection when tapped
  },
  selected: selectedPlayers.contains(player),  // Highlight selected players based on the list
  leading: selectedPlayers.contains(player)
      ? Icon(Icons.check, color: Colors.green)
      : null,  // Show check icon for selected players
);
              },
            ),
          ),
          
          // Add player form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nom du joueur'),
                ),
                TextField(
                  controller: _numberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Numéro du joueur'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addPlayer,  // Add the player to the team
                  child: Text('Ajouter un joueur'),
                ),
              ],
            ),
          ),
          
          // Button to start the match
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _startMatch,  // Start the match with the selected players
              child: Text('Lancer le match'),
            ),
          ),
        ],
      ),
    );
  }
}
