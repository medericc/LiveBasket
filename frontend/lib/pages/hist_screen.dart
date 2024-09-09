import 'dart:convert'; // Pour jsonEncode et jsonDecode
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistScreen extends StatefulWidget {
  final String teamName;
  final List<String> players; // Ajout de la liste des joueurs passée depuis TeamsScreen

  HistScreen({required this.teamName, required this.players}); // Assure que les joueurs sont passés

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

  Future<void> _deleteMatchAndStats(String matchEntry) async {
    final prefs = await SharedPreferences.getInstance();

    // Supprime les stats cumulées pour chaque joueur
    for (var player in widget.players) {
      String playerKey = 'stats_${widget.teamName}_$player';
      String matchCountKey = 'matches_${widget.teamName}_$player';

      // Ajuste les stats en fonction du match supprimé
      String? savedStatsString = prefs.getString(playerKey);
      Map<String, dynamic> savedStats = savedStatsString != null ? _parseStats(savedStatsString) : {};

      int matchCount = prefs.getInt(matchCountKey) ?? 0;
      if (matchCount > 0) {
        matchCount--;
        await prefs.setInt(matchCountKey, matchCount);
      }

      // Optionnel : réinitialise ou recalcule les stats
    }

    // Supprime le match de l'historique
    _deleteMatch(matchEntry);




  }

  Future<void> _loadCumulativeStats() async {
    final prefs = await SharedPreferences.getInstance();
  
    // Charge les stats cumulées pour chaque joueur
    for (var player in widget.players) {
      String playerKey = 'stats_${widget.teamName}_$player';
    
      // Charge les stats cumulées sauvegardées
      String? cumulativeStatsString = prefs.getString(playerKey);
      if (cumulativeStatsString != null) {
        Map<String, int> cumulativeStats = Map<String, int>.from(jsonDecode(cumulativeStatsString));
      
        // Mets à jour l'interface utilisateur avec les nouvelles stats
        setState(() {
          // Ajoute la logique pour afficher les stats ou les stocker
        });
      }
    }
  }

  Future<void> _deleteMatch(String matchEntry) async {
    final prefs = await SharedPreferences.getInstance();

    // Supprime l'entrée du match de l'historique
    String matchHistoryKey = 'history_${widget.teamName}';
    List<String> matchHistory = prefs.getStringList(matchHistoryKey) ?? [];
    matchHistory.remove(matchEntry);
    await prefs.setStringList(matchHistoryKey, matchHistory);

    // Supprime les stats de chaque joueur pour ce match
    for (String player in widget.players) {
      String matchStatsKey = 'match_${widget.teamName}_${player}_$matchEntry';

      // Charge les stats du match à supprimer
      String? matchStatsString = prefs.getString(matchStatsKey);
      if (matchStatsString != null) {
        Map<String, int> matchStats = Map<String, int>.from(jsonDecode(matchStatsString));

        // Soustrait les stats du match supprimé des stats cumulées
        String playerKey = 'stats_${widget.teamName}_$player';
        String? cumulativeStatsString = prefs.getString(playerKey);
        Map<String, int> cumulativeStats = cumulativeStatsString != null
            ? Map<String, int>.from(jsonDecode(cumulativeStatsString))
            : {};

        matchStats.forEach((statKey, statValue) {
          cumulativeStats[statKey] = (cumulativeStats[statKey] ?? 0) - statValue;
        });

        // Sauvegarde les stats cumulées mises à jour
        await prefs.setString(playerKey, jsonEncode(cumulativeStats));
      }

      // Supprime les stats spécifiques à ce match
      await prefs.remove(matchStatsKey);
    }

    // Affiche un message pour confirmer la suppression
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Match supprimé et statistiques mises à jour pour ${widget.teamName}.')),
    );

    // Recharge les stats pour refléter les changements
    setState(() {
      _loadCumulativeStats(); // Recharger les stats cumulées
    });
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
                      _cancelMatch(matchEntry); // Appel de la méthode pour annuler le match
                    },
                  ),
                );
              },
            ),
    );
  }

Future<void> _cancelMatch(String matchEntry) async {
  final prefs = await SharedPreferences.getInstance();

  // Supprimer le match de l'historique
  await _deleteMatch(matchEntry);

  // Réinitialiser les stats pour chaque joueur
  for (var player in widget.players) {
    String playerKey = 'stats_${widget.teamName}_$player';
    String matchCountKey = 'matches_${widget.teamName}_$player';

    // Charger les stats sauvegardées
    String? savedStatsString = prefs.getString(playerKey);
    Map<String, dynamic> savedStats = savedStatsString != null ? _parseStats(savedStatsString) : {};

    int matchCount = prefs.getInt(matchCountKey) ?? 0;

    if (matchCount > 0) {
      matchCount--;
      await prefs.setInt(matchCountKey, matchCount);

      // Sauvegarder les nouvelles stats après recalcul
      await prefs.setString(playerKey, jsonEncode(savedStats));
    }
  }

  // Recharger l'historique après la suppression
  setState(() {
    _loadMatchHistory();
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Le match du $matchEntry a été annulé.')),
  );
}


  // Méthode auxiliaire pour analyser les stats sauvegardées
  Map<String, dynamic> _parseStats(String statsString) {
    return jsonDecode(statsString);
  }
}
