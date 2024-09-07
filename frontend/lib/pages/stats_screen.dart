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

  @override
  void initState() {
    super.initState();
    _loadPlayerStats();
  }

  Future<void> _loadPlayerStats() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, Map<String, dynamic>> stats = {};

    for (var player in widget.players) {
      String playerKey = 'stats_${widget.teamName}_$player';
      String? statString = prefs.getString(playerKey);

      if (statString != null) {
        stats[player] = _parseStats(statString);
      } else {
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
    }

    setState(() {
      playerStats = stats;
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
                        Text('LF réussis: ${stats['oneMade']} - LF ratés: ${stats['oneMiss']}'),
                        Text('2PT réussis: ${stats['twoMade']} - 2PT ratés: ${stats['twoMiss']}'),
                        Text('3PT réussis: ${stats['threeMade']} - 3PT ratés: ${stats['threeMiss']}'),
                        Text('Turnovers cumulés: ${stats['turnover']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
