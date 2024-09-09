import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StatsScreen extends StatefulWidget {
  final String teamName;
  final List<String> players;

  StatsScreen({required this.teamName, required this.players});

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  Map<String, Map<String, int>> cumulativeStats = {};
  Map<String, int> matchCounts = {};

  @override
  void initState() {
    super.initState();
    _loadCumulativeStats();
  }

  Future<void> _loadCumulativeStats() async {
    final prefs = await SharedPreferences.getInstance();

    for (String player in widget.players) {
      String playerKey = 'stats_${widget.teamName}_$player';

      // Charger les statistiques cumulées du joueur
      String? statsString = prefs.getString(playerKey);
      Map<String, int> stats = statsString != null ? Map<String, int>.from(jsonDecode(statsString)) : {};

      setState(() {
        cumulativeStats[player] = stats;

        // Charger le nombre de matchs joués
        String matchHistoryKey = 'history_${widget.teamName}';
        List<String> matchHistory = prefs.getStringList(matchHistoryKey) ?? [];
        matchCounts[player] = matchHistory.length;
      });
    }
  }

  double _calculateAverage(int total, int matches) {
    return matches > 0 ? total / matches : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistiques - ${widget.teamName}'),
      ),
      body: widget.players.isEmpty
          ? Center(child: Text('Aucun joueur enregistré.'))
          : ListView.builder(
              itemCount: widget.players.length,
              itemBuilder: (context, index) {
                String player = widget.players[index];
                Map<String, int> stats = cumulativeStats[player] ?? {};
                int matches = matchCounts[player] ?? 0;

                // Calcul des moyennes par match
                double pointsPerGame = _calculateAverage(stats['points'] ?? 0, matches);
                double reboundsPerGame = _calculateAverage(stats['rebounds'] ?? 0, matches);
                double assistsPerGame = _calculateAverage(stats['assists'] ?? 0, matches);
                double stealsPerGame = _calculateAverage(stats['steals'] ?? 0, matches);
                double blocksPerGame = _calculateAverage(stats['blocks'] ?? 0, matches);

                return Card(
                  child: ListTile(
                    title: Text(player),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Statistiques cumulées:'),
                        Text('Points: ${stats['points'] ?? 0}'),
                        Text('Rebonds: ${stats['rebounds'] ?? 0}'),
                        Text('Assistances: ${stats['assists'] ?? 0}'),
                        Text('Interceptions: ${stats['steals'] ?? 0}'),
                        Text('Contres: ${stats['blocks'] ?? 0}'),
                        SizedBox(height: 10),
                        Text('Moyenne par match (en $matches matchs):'),
                        Text('Points par match: ${pointsPerGame.toStringAsFixed(2)}'),
                        Text('Rebonds par match: ${reboundsPerGame.toStringAsFixed(2)}'),
                        Text('Assistances par match: ${assistsPerGame.toStringAsFixed(2)}'),
                        Text('Interceptions par match: ${stealsPerGame.toStringAsFixed(2)}'),
                        Text('Contres par match: ${blocksPerGame.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
