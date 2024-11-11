import 'package:flutter/material.dart';
import 'pages/home_screen.dart';
import 'pages/match.dart';
import 'pages/team_screen.dart'; // Ajouter l'import de team_screen
import 'pages/player_screen.dart'; // Ajouter l'import de player_screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basket Stats',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(), // Démarrage sur MyHomePage avec la barre de navigation
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0; // Indice de l'écran sélectionné

  // Liste des écrans pour la navigation
  final List<Widget> _screens = [
    HomeScreen(),  // L'écran d'accueil
    MatchScreen(), // L'écran du match
    TeamScreen(),  // L'écran des équipes
  ];

  // Fonction pour changer d'écran en fonction de l'indice sélectionné
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basket Stats'),
      ),
      body: _screens[_currentIndex], // Affiche l'écran sélectionné
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Indice de l'écran sélectionné
        onTap: _onItemTapped, // Fonction pour changer l'écran
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_basketball),
            label: 'Match',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Teams',
          ),
        ],
      ),
    );
  }
}
