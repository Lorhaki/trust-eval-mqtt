import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final currentUser = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Users")
                  .where("uid", isEqualTo:  currentUser.currentUser!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                if (snapshot.hasData) {
                 return ListView.builder(
                   itemCount: snapshot.data!.docs.length,
                   shrinkWrap: true,
                   itemBuilder: (context,i){
                     var data = snapshot.data!.docs[i];
                     String pseudo = data['pseudo'];
                     String email = data['mail'];
                     String confiance = data['confiance'].toString();
                     String participation = data['participation'].toString();
                     String nbEvent = data['nbevents'].toString();
                     return Padding(
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
                                 title:  Text("Pseudo: " + pseudo),
                                 ),
                              ),
                           Card(
                             child: ListTile(
                               leading: Icon(Icons.mail),
                               title:  Text("Email: " + email),
                             ),
                           ),
                           Card(
                             child: ListTile(
                               leading: Icon(Icons.favorite),
                               title:  Text("Confiance: " + confiance+ "%"),
                             ),
                           ),
                           Card(
                             child: ListTile(
                               leading: Icon(Icons.handshake),
                               title:  Text("Participation: " + participation),
                             ),
                           ),
                           Card(
                             child: ListTile(
                               leading: Icon(Icons.flag),
                               title:  Text("Nombre event créés: " + nbEvent ),
                             ),
                           ),
                         ],
                       ),
                     );
                     },
                 );
                  // var data = snapshot.data!.docs;
                } else{ return Text("Il n'y a pas de données pour cet utilisateur , celui à mal été instancié ERROR");
                }
         }
          ),
          ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: const Text("Se déconnecter"),
          ),
        ],
      ),
    );
  }
}