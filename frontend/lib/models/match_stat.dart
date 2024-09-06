class MatchStat {
  final int id;
  final int playerId;
  final int teamId;
  final int points;
  final int rebounds;
  final int assists;
  final int steals;
  final int blocks;
  final int twoMiss;
  final int threeMiss;
  final int oneMiss;
  final int oneMade;
  final int twoMade;
  final int threeMade;
  final int turnover;

  MatchStat({
    required this.id,
    required this.playerId,
    required this.teamId,
    required this.points,
    required this.rebounds,
    required this.assists,
    required this.steals,
    required this.blocks,
    required this.oneMiss,
    required this.oneMade,
    required this.threeMiss,
    required this.threeMade,
    required this.twoMade,
    required this.twoMiss,
    required this.turnover,
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
      steals: json['steals'],
      blocks: json['blocks'],
      oneMiss: json['one_miss'],
      oneMade: json['one_made'],
      threeMiss: json['three_miss'],
      threeMade: json['three_made'],
      twoMade: json['two_made'],
      twoMiss: json['two_miss'],
      turnover: json['turnover'],
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
      'steals': steals,
      'blocks': blocks,
      'one_miss': oneMiss,
      'one_made': oneMade,
      'three_miss': threeMiss,
      'three_made': threeMade,
      'two_made': twoMade,
      'two_miss': twoMiss,
      'turnover': turnover,
    };
  }
}
