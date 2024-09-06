import 'package:flutter/material.dart';
import 'match_screen.dart';  // Importer MatchScreen ici

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Redirection vers MatchScreen avec un matchId (par exemple 1)
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MatchScreen(matchId: 1),
              ),
            );
          },
          child: Text('Aller au Match en direct'),
        ),
      ),
    );
  }
}
