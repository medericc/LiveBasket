// services/team_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/team.dart';

class TeamService {
  static const String _teamsKey = 'teams';

  // Méthode pour charger les équipes depuis les préférences
  Future<List<Team>> loadTeams() async {
    final prefs = await SharedPreferences.getInstance();
    final teamsJson = prefs.getStringList(_teamsKey) ?? [];
    return teamsJson.map((teamString) {
      final teamMap = json.decode(teamString);
      return Team.fromJson(teamMap);
    }).toList();
  }

  // Méthode pour sauvegarder les équipes dans les préférences
  Future<void> saveTeams(List<Team> teams) async {
    final prefs = await SharedPreferences.getInstance();
    final teamsJson = teams.map((team) => json.encode(team.toJson())).toList();
    await prefs.setStringList(_teamsKey, teamsJson);
  }
}
