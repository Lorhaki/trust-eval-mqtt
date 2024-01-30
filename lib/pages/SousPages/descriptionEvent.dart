import 'package:flutter/material.dart';

class descriptionEvent extends StatelessWidget {
  const descriptionEvent({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Description de l'évenement"),
        ),
        body: Center(
         child: Text("Bientot disponible"),
        )
    );
  }
}
