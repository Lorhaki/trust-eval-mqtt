import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("TrustEval"),
            backgroundColor: Colors.red,
          ),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "Voici l'application TrustEval.",
                        style: TextStyle(
                          fontSize: 24,
                  ),
                ),
                Text(
                  "Une application permettant de creer des evenements et de les approuver",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.white),
                label: 'Actualités',
                backgroundColor: Colors.red,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search, color: Colors.white),
                label: 'Recherche',
                backgroundColor: Colors.red,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, color: Colors.white),
                label: 'Profil',
                backgroundColor: Colors.red,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add, color: Colors.white),
                label: 'Ajouter un evenements',
                backgroundColor: Colors.red,
              ),
            ],
          ),
        )
    );
  }
}