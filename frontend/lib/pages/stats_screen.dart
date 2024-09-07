import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatsScreen extends StatefulWidget {
  final String teamName;
  final List<String> players;

  StatsScreen({required this.teamName, required this.players});

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  Map<String, Map<String, dynamic>> playerStats = {};
  Map<String, int> playerMatches = {};

  @override
  void initState() {
    super.initState();
    _loadPlayerStats();
  }

  Future<void> _loadPlayerStats() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, Map<String, dynamic>> stats = {};
    Map<String, int> matches = {};

    for (var player in widget.players) {
      String playerKey = 'stats_${widget.teamName}_$player';
      String matchCountKey = 'matches_${widget.teamName}_$player';
      
      // Charger les statistiques cumulées
      String? statString = prefs.getString(playerKey);

      if (statString != null) {
        stats[player] = _parseStats(statString);
      } else {
        // Initialiser les statistiques si elles n'existent pas
        stats[player] = {
          'points': 0,
          'rebounds': 0,
          'assists': 0,
          'steals': 0,
          'blocks': 0,
          'oneMade': 0,
          'oneMiss': 0,
          'twoMade': 0,
          'twoMiss': 0,
          'threeMade': 0,
          'threeMiss': 0,
          'turnover': 0
        };
      }

      // Charger le nombre de matchs joués
      int matchCount = prefs.getInt(matchCountKey) ?? 0;
      matches[player] = matchCount;
    }

    setState(() {
      playerStats = stats;
      playerMatches = matches;
    });
  }

  Map<String, dynamic> _parseStats(String statString) {
    statString = statString.replaceAll(RegExp(r'[{}]'), '');
    List<String> entries = statString.split(', ');

    Map<String, dynamic> stats = {};
    for (var entry in entries) {
      var splitEntry = entry.split(': ');
      stats[splitEntry[0]] = int.parse(splitEntry[1]);
    }
    return stats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistiques cumulées de ${widget.teamName}'),
      ),
      body: playerStats.isEmpty
          ? Center(child: Text('Aucune statistique disponible pour cette équipe.'))
          : ListView.builder(
              itemCount: widget.players.length,
              itemBuilder: (context, index) {
                String player = widget.players[index];
                var stats = playerStats[player] ?? {};
                int matchCount = playerMatches[player] ?? 0;
                
                // Calcul des moyennes de points
                double averagePoints = matchCount > 0 ? (stats['points'] ?? 0) / matchCount : 0;
                   double averageRebonds = matchCount > 0 ? (stats['rebounds'] ?? 0) / matchCount : 0;
                      double averageAssists = matchCount > 0 ? (stats['assists'] ?? 0) / matchCount : 0;
                         double averageSteals = matchCount > 0 ? (stats['steals'] ?? 0) / matchCount : 0;
                            double averageBlocks = matchCount > 0 ? (stats['blocks'] ?? 0) / matchCount : 0;
                               double averageTurn = matchCount > 0 ? (stats['turnover'] ?? 0) / matchCount : 0;
                               

                return Card(
                  child: ListTile(
                    title: Text(player),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Points cumulés: ${stats['points']}'),
                     
                        Text('Rebonds cumulés: ${stats['rebounds']}'),
                        Text('Assistances cumulées: ${stats['assists']}'),
                        Text('Balles volées cumulées: ${stats['steals']}'),
                        Text('Contres cumulés: ${stats['blocks']}'),
                       Text('LF réussis: ${stats['oneMade']} - LF tirés: ${stats['oneMade'] + stats['oneMiss']}'),

                        Text('2PT réussis: ${stats['twoMade']} - 2PT tirés: ${stats['twoMiss']+stats['twoMade']}'),
                        Text('3PT réussis: ${stats['threeMade']} - 3PT tirés: ${stats['threeMiss']+stats['threeMade']}'),
                        Text('Turnovers cumulés: ${stats['turnover']}'),
                        Text('Points moyens: ${averagePoints.toStringAsFixed(2)}'),
                        Text('Rebnds moyens: ${averageRebonds.toStringAsFixed(2)}'),
                        Text('Passes moyennes: ${averageAssists.toStringAsFixed(2)}'),
                        Text('Steals moyens: ${averageSteals.toStringAsFixed(2)}'),
                        Text('Blocks moyens: ${averageBlocks.toStringAsFixed(2)}'),
                        Text('Turnover moyens: ${averageTurn.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
