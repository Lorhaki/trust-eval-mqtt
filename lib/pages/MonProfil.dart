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
                     return UserAccountsDrawerHeader(
                         accountName: Text(data['pseudo']),
                         accountEmail: Text(data['confiance'].toString()));
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