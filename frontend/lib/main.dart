import 'package:flutter/material.dart';
import 'models/player.dart';
import 'models/team.dart';
import 'models/match_stat.dart';
import 'pages/main_screen.dart';
import 'pages/home_screen.dart';
import 'pages/team_screen.dart';
import 'pages/hist_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basketball Stats',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Initialisation de l'index sélectionné à 0
  int _selectedIndex = 0;

  // Liste des options de widgets pour la BottomNavigationBar
  final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    TeamsScreen(),
    
  ];

  // Méthode pour changer l'index lorsqu'un élément est tapé
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basketball Stats App'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Teams',
          ),
        
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
