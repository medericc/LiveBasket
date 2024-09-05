import 'package:flutter/material.dart';

class MatchScreen extends StatefulWidget {
  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  // Initialiser les scores pour les joueurs
  Map<int, int> rebounds = {1: 0, 2: 0, 3: 0, 4: 0}; // Par exemple, pour 4 joueurs

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match en direct'),
      ),
      body: Column(
        children: [
          // Section des joueurs (DragTarget)
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Par exemple 2 joueurs par ligne
              ),
              itemCount: rebounds.length, // Nombre de joueurs
              itemBuilder: (context, index) {
                int playerId = rebounds.keys.elementAt(index);
                return DragTarget<String>(
                  onAccept: (data) {
                    setState(() {
                      if (data == 'rebound') {
                         rebounds[playerId] = (rebounds[playerId] ?? 0) + 1; // Ajouter 1 rebond
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
                          Text('Rebonds: ${rebounds[playerId]}'),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Section pour les actions de stats (Draggable)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
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
          ),
        ],
      ),
    );
  }
}
