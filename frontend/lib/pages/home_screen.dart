// home_screen.dart
import 'package:flutter/material.dart';
import 'team_entry_screen.dart';
import '../models/team.dart';
import './team_detail_screen.dart';
import '../services/team_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TeamService _teamService = TeamService();
  List<Team> _teams = [];

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  // Charge les équipes en utilisant le TeamService
  Future<void> _loadTeams() async {
    final teams = await _teamService.loadTeams();
    setState(() {
      _teams = teams;
    });
  }

  // Enregistre les équipes en utilisant le TeamService
  Future<void> _saveTeams() async {
    await _teamService.saveTeams(_teams);
  }

  // Méthode pour ajouter une équipe
Future<void> _addTeam() async {
  final newTeam = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => TeamEntryScreen(existingTeams: _teams),
    ),
  );

  if (newTeam != null && newTeam is Team) {
    setState(() {
      _teams.add(newTeam);
    });
    _saveTeams();
  }
}
void _openTeamDetail(Team team) async {
  // Navigation vers l'écran de détail de l'équipe
  final updatedTeam = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => TeamDetailScreen(team: team), // Change _TeamDetailScreenState to TeamDetailScreen
    ),
  );

  // Si l'équipe a été modifiée, on met à jour la liste d'équipes
  if (updatedTeam != null) {
    setState(() {
      final index = _teams.indexWhere((t) => t.name == updatedTeam.name);
      if (index != -1) {
        _teams[index] = updatedTeam;
      }
    });
    _saveTeams();
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Équipes')),
      body: ListView.builder(
        itemCount: _teams.length,
        itemBuilder: (context, index) {
          final team = _teams[index];
            return ListTile(
          title: Text(team.name),
          onTap: () => _openTeamDetail(team), // Modification ici
        );
      },
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _addTeam,
      child: Icon(Icons.add),
    ),
  );
}
}
