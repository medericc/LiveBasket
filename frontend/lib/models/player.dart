class Player {
  final int id;
  final String name;
  final int number;
  final int teamId;

  Player({
    required this.id,
    required this.name,
    required this.number,
    required this.teamId,
  });

  // Conversion depuis un JSON reçu du backend
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      number: json['number'],
      teamId: json['team_id'],
    );
  }

  // Conversion vers un JSON pour l'envoi au backend
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'team_id': teamId,
    };
  }
}
