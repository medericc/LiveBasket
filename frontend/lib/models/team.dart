import 'player.dart';

class Team {
  final int id;
  final String name;
  final List<Player> players;

  Team({
    required this.id,
    required this.name,
    required this.players,
  });

  // Conversion depuis un JSON reçu du backend
  factory Team.fromJson(Map<String, dynamic> json) {
    var playerList = json['players'] as List;
    List<Player> playerItems = playerList.map((i) => Player.fromJson(i)).toList();

    return Team(
      id: json['id'],
      name: json['name'],
      players: playerItems,
    );
  }

  // Conversion vers un JSON pour l'envoi au backend
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'players': players.map((player) => player.toJson()).toList(),
    };
  }
}
