import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import nécessaire pour SharedPreferences
import 'dart:convert';
class MatchScreen extends StatefulWidget {
  final String teamName;
  final List<String> players;

  MatchScreen({required this.teamName, required this.players});

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  late Map<int, Map<String, int>> playerStats;
  List<Map<String, dynamic>> actionHistory = [];

  @override
  void initState() {
    super.initState();
    // Initialize player stats based on the dynamic list of players
    playerStats = {
      for (int i = 0; i < widget.players.length; i++)
        i + 1: {
          'points': 0,
          'rebounds': 0,
          'assists': 0,
          'steals': 0,
          'blocks': 0,
          'oneMade': 0,
          'oneMiss': 0,
          'twoMade': 0,
          'twoMiss': 0,
          'threeMade': 0,
          'threeMiss': 0,
          'turnover': 0
        }
    };
  }

  void _applyAction(int playerId, String action, {bool undo = false}) {
    int multiplier = undo ? -1 : 1;

    setState(() {
      switch (action) {
        case 'rebound':
          playerStats[playerId]!['rebounds'] = playerStats[playerId]!['rebounds']! + (1 * multiplier);
          break;
        case 'assist':
          playerStats[playerId]!['assists'] = playerStats[playerId]!['assists']! + (1 * multiplier);
          break;
        case 'steal':
          playerStats[playerId]!['steals'] = playerStats[playerId]!['steals']! + (1 * multiplier);
          break;
        case 'block':
          playerStats[playerId]!['blocks'] = playerStats[playerId]!['blocks']! + (1 * multiplier);
          break;
        case 'oneMade':
          playerStats[playerId]!['oneMade'] = playerStats[playerId]!['oneMade']! + (1 * multiplier);
          playerStats[playerId]!['points'] = playerStats[playerId]!['points']! + (1 * multiplier);
          break;
        case 'twoMade':
          playerStats[playerId]!['twoMade'] = playerStats[playerId]!['twoMade']! + (1 * multiplier);
          playerStats[playerId]!['points'] = playerStats[playerId]!['points']! + (2 * multiplier);
          break;
        case 'threeMade':
          playerStats[playerId]!['threeMade'] = playerStats[playerId]!['threeMade']! + (1 * multiplier);
          playerStats[playerId]!['points'] = playerStats[playerId]!['points']! + (3 * multiplier);
          break;
        case 'oneMiss':
          playerStats[playerId]!['oneMiss'] = playerStats[playerId]!['oneMiss']! + (1 * multiplier);
          break;
        case 'twoMiss':
          playerStats[playerId]!['twoMiss'] = playerStats[playerId]!['twoMiss']! + (1 * multiplier);
          break;
        case 'threeMiss':
          playerStats[playerId]!['threeMiss'] = playerStats[playerId]!['threeMiss']! + (1 * multiplier);
          break;
        case 'turnover':
          playerStats[playerId]!['turnover'] = playerStats[playerId]!['turnover']! + (1 * multiplier);
          break;
        default:
          break;
      }

      if (!undo) {
        actionHistory.add({
          'playerId': playerId,
          'action': action,
          'timestamp': DateTime.now(),
        });
      }
    });
  }

  double _calculatePercentage(int made, int miss) {
    int totalAttempts = made + miss;
    return totalAttempts > 0 ? (made / totalAttempts) * 100 : 0.0;
  }

void _deleteAction(int index) {
  if (index >= 0 && index < actionHistory.length) {
    var action = actionHistory[index];
    int playerId = action['playerId'];
    String actionType = action['action'];

    setState(() {
      _applyAction(playerId, actionType, undo: true); // Annuler l'action
      actionHistory.removeAt(index); // Supprimer l'action de l'historique
    });
  }
}








void _saveStats() async {
  final prefs = await SharedPreferences.getInstance();

  for (int playerId = 1; playerId <= widget.players.length; playerId++) {
    String playerKey = 'stats_${widget.teamName}_${widget.players[playerId - 1]}';
    
    // Charger les statistiques actuelles sauvegardées (s'il y en a)
    String? savedStatsString = prefs.getString(playerKey);
    Map<String, dynamic> savedStats = savedStatsString != null ? jsonDecode(savedStatsString) : {};

    // Cumuler les nouvelles statistiques avec celles existantes
    playerStats[playerId]!.forEach((statKey, statValue) {
      savedStats[statKey] = (savedStats[statKey] ?? 0) + statValue;
    });

    // Sauvegarder les nouvelles statistiques cumulées
    await prefs.setString(playerKey, jsonEncode(savedStats)); // Utilisation de jsonEncode pour sérialiser
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Statistiques cumulées sauvegardées pour l\'équipe ${widget.teamName}!')),
  );
}



void _stopMatch() async {
  final prefs = await SharedPreferences.getInstance();

  // Appel de _saveStats()
  _saveStats();

  // Créer une entrée pour cet historique de match
  String matchHistoryKey = 'history_${widget.teamName}';
  List<String> matchHistory = prefs.getStringList(matchHistoryKey) ?? [];

  String matchEntry = DateTime.now().toString(); // Utiliser la date comme identifiant unique du match
  matchHistory.add(matchEntry);
  await prefs.setStringList(matchHistoryKey, matchHistory);

  // Sauvegarder les statistiques du match pour chaque joueur
  for (int playerId = 1; playerId <= widget.players.length; playerId++) {
    String matchStatsKey = 'match_${widget.teamName}_${widget.players[playerId - 1]}_$matchEntry';
    
    // Stocker les statistiques du match pour chaque joueur
    await prefs.setString(matchStatsKey, jsonEncode(playerStats[playerId])); // Sauvegarder les statistiques sous forme de JSON
  }

  // Afficher un message à l'utilisateur
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Match terminé et statistiques sauvegardées pour ${widget.teamName}!')),
  );

  // Revenir à l'écran précédent
  Navigator.pop(context);
}








  void _showActionHistory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Historique des actions"),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: actionHistory.length,
              itemBuilder: (context, index) {
                var action = actionHistory[index];
                return ListTile(
                  title: Text("Joueur ${action['playerId']} - ${action['action']}"),
                  subtitle: Text(action['timestamp'].toString()),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteAction(index);
                      Navigator.of(context).pop();
                      _showActionHistory();
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text("Fermer"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match en direct'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: _showActionHistory,
            tooltip: 'Historique des actions',
          ),
        
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: _stopMatch,
            tooltip: 'Arrêter le match',
          ),
        ],
      ),
      body: Column(
        children: [
          Text('Équipe: ${widget.teamName}'),
          Expanded(
  child: GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
    ),
    itemCount: widget.players.length,
    itemBuilder: (context, index) {
      int playerId = index + 1;
      var stats = playerStats[playerId]!;

      double freeThrowPct = _calculatePercentage(stats['oneMade']!, stats['oneMiss']!);
      double twoPointPct = _calculatePercentage(stats['twoMade']!, stats['twoMiss']!);
      double threePointPct = _calculatePercentage(stats['threeMade']!, stats['threeMiss']!);
      double fieldGoalPct = _calculatePercentage(
        stats['twoMade']! + stats['threeMade']!,
        stats['twoMiss']! + stats['threeMiss']!,
      );

      return DragTarget<String>(
        onAccept: (data) {
          _applyAction(playerId, data);
        },
        builder: (context, candidateData, rejectedData) {
          return Card(
            color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.players[playerId - 1]),  // Nom réel du joueur
                Text('Points: ${stats['points']}'),
                Text('Rebonds: ${stats['rebounds']}'),
                Text('Assistances: ${stats['assists']}'),
                Text('Balles volées: ${stats['steals']}'),
                Text('Contres: ${stats['blocks']}'),
                Text('LF%: ${freeThrowPct.toStringAsFixed(2)}%'),
                Text('2PT%: ${twoPointPct.toStringAsFixed(2)}%'),
                Text('3PT%: ${threePointPct.toStringAsFixed(2)}%'),
                Text('FG%: ${fieldGoalPct.toStringAsFixed(2)}%'),
              ],
            ),
          );
        },
      );
    },
  ),
),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDraggableRow('rebound', Icons.sports_basketball, Colors.green, 'Ajouter 1 rebond'),
                _buildDraggableRow('assist', Icons.redeem, Colors.blue, 'Ajouter 1 assist'),
                _buildDraggableRow('steal', Icons.lock, Colors.orange, 'Ajouter 1 steal'),
                _buildDraggableRow('block', Icons.block, Colors.red, 'Ajouter 1 block'),
                _buildDraggableRow('oneMade', Icons.filter_1, Colors.purple, 'Ajouter 1 panier à 1pt'),
                _buildDraggableRow('oneMiss', Icons.filter_1_outlined, Colors.purple, 'Tir à 1pt raté'),
                _buildDraggableRow('twoMade', Icons.filter_2, Colors.indigo, 'Ajouter 1 panier à 2pts'),
                _buildDraggableRow('twoMiss', Icons.filter_2_outlined, Colors.indigo, 'Tir à 2pts raté'),
                _buildDraggableRow('threeMade', Icons.filter_3, Colors.brown, 'Ajouter 1 panier à 3pts'),
                _buildDraggableRow('threeMiss', Icons.filter_3_outlined, Colors.brown, 'Tir à 3pts raté'),
                _buildDraggableRow('turnover', Icons.error, Colors.grey, 'Ajouter 1 turnover'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableRow(String action, IconData icon, Color color, String tooltip) {
    return Draggable<String>(
      data: action,
      feedback: Icon(icon, color: color, size: 40),
      childWhenDragging: Icon(icon, color: Colors.black12),
      child: Tooltip(
        message: tooltip,
        child: Icon(icon, color: color, size: 40),
      ),
    );
  }
}
