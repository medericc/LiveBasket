class MatchStat {
  final int id;
  final int playerId;
  final int teamId;
  final int points;
  final int rebounds;
  final int assists;

  MatchStat({
    required this.id,
    required this.playerId,
    required this.teamId,
    required this.points,
    required this.rebounds,
    required this.assists,
  });

  // Conversion depuis un JSON reçu du backend
  factory MatchStat.fromJson(Map<String, dynamic> json) {
    return MatchStat(
      id: json['id'],
      playerId: json['player_id'],
      teamId: json['team_id'],
      points: json['points'],
      rebounds: json['rebounds'],
      assists: json['assists'],
    );
  }

  // Conversion vers un JSON pour l'envoi au backend
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'player_id': playerId,
      'team_id': teamId,
      'points': points,
      'rebounds': rebounds,
      'assists': assists,
    };
  }
}
