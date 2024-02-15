import 'package:flutter/material.dart';

class descriptionUser extends StatelessWidget {
  const descriptionUser({super.key, required this.user});
  final dynamic user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Profil de "),
        ),
        body: Center(
          child:  Padding(
            padding:  const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title:  Text("Pseudo: " + user['pseudo']),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.mail),
                    title:  Text("Email: " + user['mail']),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.favorite),
                    title:  Text("Confiance: ${user['confiance']}%"),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.handshake),
                    title:  Text("Participation: ${user['participation']}"),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.flag),
                    title:  Text("Nombre event créés: ${user['nbevents']}" ),
                  ),
                ),
              ],
            ),
          )
        )
    );
  }
}
