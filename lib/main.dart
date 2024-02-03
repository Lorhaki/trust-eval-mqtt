import 'package:flutter/material.dart';
import 'package:on_essaie_encore/pages/AjoutEvent.dart';
import 'pages/MonProfil.dart';
import 'pages/HomePage.dart';
import 'map.dart';
import 'RechercherUser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,

  );

  runApp(const MyApp());
  
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _currentIndex = 0;

  setCurrentIndex(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
      ),
    );
  }
}