import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistScreen extends StatefulWidget {
  final String teamName;
  final List<String> players; // Add players list to pass from TeamsScreen

  HistScreen({required this.teamName, required this.players}); // Ensure players are passed

  @override
  _HistScreenState createState() => _HistScreenState();
}

class _HistScreenState extends State<HistScreen> {
  List<String> matchHistory = [];

  @override
  void initState() {
    super.initState();
    _loadMatchHistory();
  }

  Future<void> _loadMatchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    String matchHistoryKey = 'history_${widget.teamName}';
    List<String> history = prefs.getStringList(matchHistoryKey) ?? [];
    setState(() {
      matchHistory = history;
    });
  }

  // This is the method you provided, which deletes a match and adjusts player stats
  Future<void> _deleteMatchAndStats(String matchEntry) async {
    final prefs = await SharedPreferences.getInstance();

    // Remove cumulative stats for each player
    for (var player in widget.players) {
      String playerKey = 'stats_${widget.teamName}_$player';
      String matchCountKey = 'matches_${widget.teamName}_$player';

      // Adjust stats based on removed match
      String? savedStatsString = prefs.getString(playerKey);
      Map<String, dynamic> savedStats = savedStatsString != null ? _parseStats(savedStatsString) : {};

      int matchCount = prefs.getInt(matchCountKey) ?? 0;
      if (matchCount > 0) {
        matchCount--;
        await prefs.setInt(matchCountKey, matchCount);
      }

      // Optionally reset or recalculate stats for this player
      // await prefs.setString(playerKey, recalculatedStats.toString());
    }

    // Delete the match from the history
    _deleteMatch(matchEntry);
  }

  // Delete the match from SharedPreferences
  Future<void> _deleteMatch(String matchEntry) async {
    final prefs = await SharedPreferences.getInstance();
    String matchHistoryKey = 'history_${widget.teamName}';

    setState(() {
      matchHistory.remove(matchEntry);
    });

    // Update the match history in SharedPreferences
    await prefs.setStringList(matchHistoryKey, matchHistory);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Match supprimé de l\'historique.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historique des matchs de ${widget.teamName}'),
      ),
      body: matchHistory.isEmpty
          ? Center(child: Text('Aucun match stoppé pour cette équipe.'))
          : ListView.builder(
              itemCount: matchHistory.length,
              itemBuilder: (context, index) {
                String matchEntry = matchHistory[index];
                return ListTile(
                  title: Text('Match terminé le $matchEntry'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteMatchAndStats(matchEntry); // Call new method to delete match and stats
                    },
                  ),
                );
              },
            ),
    );
  }

  // Helper method to parse saved stats (you need to implement this)
  Map<String, dynamic> _parseStats(String statsString) {
    // Implement the parsing logic based on your stored stats structure
    return {};
  }
}
