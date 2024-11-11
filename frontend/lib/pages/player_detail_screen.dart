import 'package:flutter/material.dart';
import '../models/player.dart';

class PlayerDetailScreen extends StatefulWidget {
  final Player player;

  PlayerDetailScreen({required this.player});

  @override
  _PlayerDetailScreenState createState() => _PlayerDetailScreenState();
}

class _PlayerDetailScreenState extends State<PlayerDetailScreen> {
  late TextEditingController _pointsController;
  late TextEditingController _reboundsController;
  late TextEditingController _assistsController;
  late TextEditingController _gamesPlayedController;

  @override
  void initState() {
    super.initState();
    _pointsController = TextEditingController(text: widget.player.points.toString());
    _reboundsController = TextEditingController(text: widget.player.rebounds.toString());
    _assistsController = TextEditingController(text: widget.player.assists.toString());
    _gamesPlayedController = TextEditingController(text: widget.player.gamesPlayed.toString());
  }

  void _savePlayerStats() {
    setState(() {
      widget.player.points = int.tryParse(_pointsController.text) ?? widget.player.points;
      widget.player.rebounds = int.tryParse(_reboundsController.text) ?? widget.player.rebounds;
      widget.player.assists = int.tryParse(_assistsController.text) ?? widget.player.assists;
      widget.player.gamesPlayed = int.tryParse(_gamesPlayedController.text) ?? widget.player.gamesPlayed;
    });
    Navigator.pop(context); // Retourne à la page précédente avec les stats mises à jour
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Détails du joueur')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Nom : ${widget.player.name}", style: TextStyle(fontSize: 18)),
            Text("Numéro : ${widget.player.number}", style: TextStyle(fontSize: 18)),
            TextField(
              controller: _pointsController,
              decoration: InputDecoration(labelText: 'Points'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _reboundsController,
              decoration: InputDecoration(labelText: 'Rebonds'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _assistsController,
              decoration: InputDecoration(labelText: 'Passes décisives'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _gamesPlayedController,
              decoration: InputDecoration(labelText: 'Matchs joués'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _savePlayerStats, child: Text('Enregistrer les statistiques')),
          ],
        ),
      ),
    );
  }
}
