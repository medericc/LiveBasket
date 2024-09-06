import 'package:flutter/material.dart';

class MatchScreen extends StatefulWidget {
  final int matchId; // ID du match en cours (pour charger les stats)
  MatchScreen({required this.matchId});

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  // Structure pour les statistiques des joueurs
  Map<int, Map<String, int>> playerStats = {
    1: {'points': 0, 'rebounds': 0, 'assists': 0, 'steals': 0, 'blocks': 0, 'oneMade': 0, 'oneMiss': 0, 'twoMade': 0, 'twoMiss': 0, 'threeMade': 0, 'threeMiss': 0, 'turnover': 0},
    2: {'points': 0, 'rebounds': 0, 'assists': 0, 'steals': 0, 'blocks': 0, 'oneMade': 0, 'oneMiss': 0, 'twoMade': 0, 'twoMiss': 0, 'threeMade': 0, 'threeMiss': 0, 'turnover': 0},
    3: {'points': 0, 'rebounds': 0, 'assists': 0, 'steals': 0, 'blocks': 0, 'oneMade': 0, 'oneMiss': 0, 'twoMade': 0, 'twoMiss': 0, 'threeMade': 0, 'threeMiss': 0, 'turnover': 0},
    4: {'points': 0, 'rebounds': 0, 'assists': 0, 'steals': 0, 'blocks': 0, 'oneMade': 0, 'oneMiss': 0, 'twoMade': 0, 'twoMiss': 0, 'threeMade': 0, 'threeMiss': 0, 'turnover': 0},
  };

  // Liste pour stocker l'historique des actions
  List<Map<String, dynamic>> actionHistory = [];

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

    // Ajouter l'action dans l'historique si ce n'est pas une annulation
    if (!undo) {
      actionHistory.add({
        'playerId': playerId,
        'action': action,
        'timestamp': DateTime.now(),
      });
    }
  });
}


  // Supprimer une action spécifique
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

  // Sauvegarder les stats temporaires
  void _saveStats() {
    print(playerStats);
    print("Statistiques sauvegardées !");
  }

  // Terminer le match et sauvegarder toutes les stats
  void _stopMatch() {
    print("Match terminé et stats sauvegardées !");
    Navigator.pop(context); // Retour à l'écran précédent
  }

  // Ouvrir la modale avec l'historique des actions
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
                      _deleteAction(index); // Supprimer l'action sélectionnée
                      Navigator.of(context).pop(); // Fermer la modale après suppression
                      _showActionHistory(); // Réouvrir la modale mise à jour
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
             icon: Icon(Icons.history), // Icône de flèche pour l'historique
    onPressed: _showActionHistory, // Ouvrir la modale d'historique
    tooltip: 'Historique des actions',
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveStats, // Sauvegarder les stats en cours
            tooltip: 'Sauvegarder les stats',
          ),
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: _stopMatch, // Terminer le match
            tooltip: 'Arrêter le match',
          ),
        ],
      ),
      body: Column(
        children: [
          // Affichage des statistiques des joueurs
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: playerStats.length,
              itemBuilder: (context, index) {
                int playerId = playerStats.keys.elementAt(index);
                return DragTarget<String>(
                  onAccept: (data) {
                    _applyAction(playerId, data);
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Card(
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Joueur $playerId'),
                          SizedBox(height: 10),
                          Text('Points: ${playerStats[playerId]!['points']}'),
                          Text('Rebonds: ${playerStats[playerId]!['rebounds']}'),
                          Text('Assists: ${playerStats[playerId]!['assists']}'),
                          Text('Steals: ${playerStats[playerId]!['steals']}'),
                          Text('Blocks: ${playerStats[playerId]!['blocks']}'),
                          Text('1pt réussis: ${playerStats[playerId]!['oneMade']}'),
                          Text('1pt ratés: ${playerStats[playerId]!['oneMiss']}'),
                          Text('2pts réussis: ${playerStats[playerId]!['twoMade']}'),
                          Text('2pts ratés: ${playerStats[playerId]!['twoMiss']}'),
                          Text('3pts réussis: ${playerStats[playerId]!['threeMade']}'),
                          Text('3pts ratés: ${playerStats[playerId]!['threeMiss']}'),
                          Text('Turnovers: ${playerStats[playerId]!['turnover']}'),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Boutons pour les actions des joueurs
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
      _buildDraggableRow('rebound', Icons.sports_basketball, Colors.green, 'Ajouter 1 rebond'),
      _buildDraggableRow('assist', Icons.group, Colors.blue, 'Ajouter 1 assist'),
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

  // Fonction utilitaire pour créer un Draggable
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
