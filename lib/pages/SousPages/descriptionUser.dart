import 'package:flutter/material.dart';
import 'package:on_essaie_encore/objets/User.dart';

class descriptionUser extends StatelessWidget {
  const descriptionUser({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Profil de "),
        ),
        body: Center(
          child: Row(
            children: [
              SizedBox(width: 15), // Marge gauche
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        this.user.nom,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
              ),
              SizedBox(width: 10),
            ],
          ),
        )
    );
  }
}
