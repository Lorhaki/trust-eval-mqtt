import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:trust_eval/main.dart';
import 'package:trust_eval/objets/fonctions.dart';
import 'package:trust_eval/pages/AjoutEvent.dart';
import 'MonProfil.dart';
import 'HomePage.dart';
import 'package:trust_eval/map.dart';
import 'package:trust_eval/RechercherUser.dart';

class MyMenu extends StatefulWidget {
  const MyMenu({super.key});

  @override
  State<MyMenu> createState() => _MyMenuState();
}

class _MyMenuState extends State<MyMenu> {

  int _currentIndex = 0;

  setCurrentIndex(int index) async {
    chPage = true;
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("TrustEval"),
        ),
        body: [
         const HomePage(),
          const RechercherUser(),
          const MyProfile(),
          const AjoutEvent(),
          const Mymap(),
        ][_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setCurrentIndex(index),
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,

          elevation: 40,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Actualités',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Recherche',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Ajouter un evenements',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Carte',

            ),
          ],
        ),
      );
  }
}