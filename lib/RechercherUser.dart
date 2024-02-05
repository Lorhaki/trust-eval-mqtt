import 'package:flutter/material.dart';
import 'package:on_essaie_encore/objets/User.dart';
import 'package:on_essaie_encore/pages/SousPages/descriptionUser.dart';


class RechercherUser extends StatefulWidget {
  const RechercherUser({super.key,});

  @override
  State<RechercherUser> createState() => _RechercheUserState();
}

class _RechercheUserState extends State<RechercherUser> {

  final List<User> users = [
      User("Adrien", 50.1, 45.0, 100)
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index){
            return  GestureDetector(
              child: Card(
                child: ListTile(
                  leading: FlutterLogo(size: 56.0),

                  trailing:  Icon(Icons.more_vert),
                ),
              ),
              onTap: (){
                Navigator.push(
                    context, MaterialPageRoute(
                  builder: (context)=> descriptionUser( user: users[index]
                  ),
                ));
              },
            );
          },
        )
    );
  }
}