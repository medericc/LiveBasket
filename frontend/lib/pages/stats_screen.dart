import 'package:flutter/material.dart';

class Stats extends StatelessWidget {
  final String teamName;
  final List<String> players;

  // Le constructeur reçoit les joueurs et le nom de l'équipe
  Stats({required this.teamName, required this.players});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joueurs de $teamName'),
      ),
      body: players.isEmpty
          ? Center(child: Text('Aucun joueur enregistré pour cette équipe.'))
          : ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(players[index]),
                );
              },
            ),
    );
  }
}
