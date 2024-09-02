import 'package:flutter/material.dart';
import 'package:nom_du_projet/pages/add_event_page.dart';
import 'package:nom_du_projet/pages/event_page.dart';
import 'package:nom_du_projet/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  void setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: [
const Text("Acceuil"),
const Text("Liste"),
const Text("Form"),
          ][ _currentIndex],
          
          
          
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            HomePage(),
            EventPage(),
            AddEvent()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: setCurrentIndex,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Planning',
            ),
             BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Ajout',
            ),
          ],
        ),
      ),
    );
  }
}
