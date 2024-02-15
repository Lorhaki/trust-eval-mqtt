import 'package:flutter/material.dart';
import 'package:trust_eval/pages/SousPages/descriptionUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RechercherUser extends StatefulWidget {
  const RechercherUser({super.key,});

  @override
  State<RechercherUser> createState() => _RechercheUserState();
}

class _RechercheUserState extends State<RechercherUser> {


  @override
  Widget build(BuildContext context) {
    return Center(
        child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
              return const CircularProgressIndicator();
              }
              if(!snapshot.hasData){
              return const Text("Aucun utilisateur disponible");
              }

              List<dynamic> users = [];
              for (var element in snapshot.data!.docs) {
              users.add(element);
              }

          return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index){
            final user = users[index];
            final pseudo = user['pseudo'];
            final email = user['mail'];

            return InkWell(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(
                    builder: (context)=> descriptionUser( user: user
                    ),
                  ));
                },
                child:Card(
                    child: ListTile(
                      leading: const FlutterLogo(size: 56.0),
                      title:  Text(pseudo),
                      subtitle: Text(email),
                      trailing:  const Icon(Icons.more_vert),
                    )
                )
            );
          },

          );
        }
        ),
    );
  }
}