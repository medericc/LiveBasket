import 'package:flutter/material.dart';

class MatchScreen extends StatefulWidget {
  final int matchId;  // ID du match en cours (pour charger les stats)
  MatchScreen({required this.matchId});

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  // Structure pour les statistiques des joueurs
  Map<int, Map<String, int>> playerStats = {
    1: {'points': 0, 'rebounds': 0, 'assists': 0, 'oneMade': 0, 'twoMade': 0, 'threeMade': 0, 'turnover': 0},
    2: {'points': 0, 'rebounds': 0, 'assists': 0, 'oneMade': 0, 'twoMade': 0, 'threeMade': 0, 'turnover': 0},
    3: {'points': 0, 'rebounds': 0, 'assists': 0, 'oneMade': 0, 'twoMade': 0, 'threeMade': 0, 'turnover': 0},
    4: {'points': 0, 'rebounds': 0, 'assists': 0, 'oneMade': 0, 'twoMade': 0, 'threeMade': 0, 'turnover': 0},
  };

  // Méthode pour sauvegarder les stats temporairement
  void _saveStats() {
    print(playerStats);
    print("Statistiques sauvegardées !");
  }

  // Méthode pour terminer le match et sauvegarder toutes les stats
  void _stopMatch() {
    print("Match terminé et stats sauvegardées !");
    Navigator.pop(context);  // Retour à l'écran précédent
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match en direct'),
        actions: [
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
                    setState(() {
                      if (data == 'rebound') {
                        playerStats[playerId]!['rebounds'] = (playerStats[playerId]!['rebounds'] ?? 0) + 1;
                      } else if (data == 'assist') {
                        playerStats[playerId]!['assists'] = (playerStats[playerId]!['assists'] ?? 0) + 1;
                      } else if (data == 'oneMade') {
                        playerStats[playerId]!['points'] = (playerStats[playerId]!['points'] ?? 0) + 1;
                        playerStats[playerId]!['oneMade'] = (playerStats[playerId]!['oneMade'] ?? 0) + 1;
                      } else if (data == 'twoMade') {
                        playerStats[playerId]!['points'] = (playerStats[playerId]!['points'] ?? 0) + 2;
                        playerStats[playerId]!['twoMade'] = (playerStats[playerId]!['twoMade'] ?? 0) + 1;
                      } else if (data == 'threeMade') {
                        playerStats[playerId]!['points'] = (playerStats[playerId]!['points'] ?? 0) + 3;
                        playerStats[playerId]!['threeMade'] = (playerStats[playerId]!['threeMade'] ?? 0) + 1;
                      } else if (data == 'turnover') {
                        playerStats[playerId]!['turnover'] = (playerStats[playerId]!['turnover'] ?? 0) + 1;
                      }
                    });
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
                          Text('1pt: ${playerStats[playerId]!['oneMade']}'),
                          Text('2pt: ${playerStats[playerId]!['twoMade']}'),
                          Text('3pt: ${playerStats[playerId]!['threeMade']}'),
                          Text('Turnovers: ${playerStats[playerId]!['turnover']}'),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Draggable<String>(
                      data: 'rebound',
                      feedback: Icon(Icons.sports_basketball, size: 50, color: Colors.orange),
                      childWhenDragging: Icon(Icons.sports_basketball, size: 50, color: Colors.grey),
                      child: Icon(Icons.sports_basketball, size: 50, color: Colors.orange),
                    ),
                    SizedBox(width: 20),
                    Text('Glisser pour ajouter 1 rebond'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Draggable<String>(
                      data: 'assist',
                      feedback: Icon(Icons.handshake, size: 50, color: Colors.blue),
                      childWhenDragging: Icon(Icons.handshake, size: 50, color: Colors.grey),
                      child: Icon(Icons.handshake, size: 50, color: Colors.blue),
                    ),
                    SizedBox(width: 20),
                    Text('Glisser pour ajouter 1 assist'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Draggable<String>(
                      data: 'oneMade',
                      feedback: Icon(Icons.looks_one, size: 50, color: Colors.green),
                      childWhenDragging: Icon(Icons.looks_one, size: 50, color: Colors.grey),
                      child: Icon(Icons.looks_one, size: 50, color: Colors.green),
                    ),
                    SizedBox(width: 20),
                    Text('Glisser pour ajouter 1 panier à 1pt'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Draggable<String>(
                      data: 'twoMade',
                      feedback: Icon(Icons.looks_two, size: 50, color: Colors.red),
                      childWhenDragging: Icon(Icons.looks_two, size: 50, color: Colors.grey),
                      child: Icon(Icons.looks_two, size: 50, color: Colors.red),
                    ),
                    SizedBox(width: 20),
                    Text('Glisser pour ajouter 1 panier à 2pts'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Draggable<String>(
                      data: 'threeMade',
                      feedback: Icon(Icons.threesixty, size: 50, color: Colors.purple),
                      childWhenDragging: Icon(Icons.threesixty, size: 50, color: Colors.grey),
                      child: Icon(Icons.threesixty, size: 50, color: Colors.purple),
                    ),
                    SizedBox(width: 20),
                    Text('Glisser pour ajouter 1 panier à 3pts'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Draggable<String>(
                      data: 'turnover',
                      feedback: Icon(Icons.sync_problem, size: 50, color: Colors.black),
                      childWhenDragging: Icon(Icons.sync_problem, size: 50, color: Colors.grey),
                      child: Icon(Icons.sync_problem, size: 50, color: Colors.black),
                    ),
                    SizedBox(width: 20),
                    Text('Glisser pour ajouter 1 turnover'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
