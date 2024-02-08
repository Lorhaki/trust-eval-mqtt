import 'package:flutter/material.dart';
import 'package:on_essaie_encore/objets/User.dart';

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
            padding:  EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 40),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title:  Text("Pseudo: " + user['pseudo']),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.mail),
                    title:  Text("Email: " + user['mail']),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.favorite),
                    title:  Text("Confiance: " + user['confiance'].toString()+ "%"),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.handshake),
                    title:  Text("Participation: " + user['participation'].toString()),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.flag),
                    title:  Text("Nombre event créés: " + user['nbevents'].toString() ),
                  ),
                ),
              ],
            ),
          )
        )
    );
  }
}
