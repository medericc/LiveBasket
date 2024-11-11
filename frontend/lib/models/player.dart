class Player {
  final String name;
  final int number;
  int points;
  int rebounds;
  int assists;
  int gamesPlayed;

  Player({
    required this.name,
    required this.number,
    this.points = 0,
    this.rebounds = 0,
    this.assists = 0,
    this.gamesPlayed = 0,
  });

  // Méthode pour mettre à jour une statistique spécifique
  void updateStat(String stat) {
    switch (stat) {
      case 'Points':
        points += 1; // Ajouter 1 point quand "Points" est déposé
        break;
      case 'Rebounds':
        rebounds += 1; // Ajouter 1 rebond quand "Rebounds" est déposé
        break;
      case 'Assists':
        assists += 1; // Ajouter 1 assistance quand "Assists" est déposé
        break;
      case 'Games Played':
        gamesPlayed += 1; // Ajouter 1 match joué quand "Games Played" est déposé
        break;
      default:
        break;
    }
  }

  // Convertir un objet Player en JSON pour sauvegarde/chargement
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'number': number,
      'points': points,
      'rebounds': rebounds,
      'assists': assists,
      'gamesPlayed': gamesPlayed,
    };
  }

  // Créer un objet Player à partir d'un JSON
  static Player fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'],
      number: json['number'],
      points: json['points'],
      rebounds: json['rebounds'],
      assists: json['assists'],
      gamesPlayed: json['gamesPlayed'],
    );
  }
}
