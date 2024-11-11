import 'player.dart';
import 'dart:convert';
class Team {
  String name;
  List<Player> players;

  Team({required this.name, required this.players});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'players': players.map((player) => player.toJson()).toList(),
    };
  }

  static Team fromJson(Map<String, dynamic> json) {
    return Team(
      name: json['name'],
      players: (json['players'] as List)
          .map((playerJson) => Player.fromJson(playerJson))
          .toList(),
    );
  }
}