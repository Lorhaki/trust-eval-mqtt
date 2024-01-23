import 'package:flutter/material.dart';

class AjoutEvent extends StatefulWidget {
  const AjoutEvent({super.key});

  @override
  State<AjoutEvent> createState() => _AjoutEventState();
}

class _AjoutEventState extends State<AjoutEvent> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("TrustEval"),
            backgroundColor: Colors.red,
          ),
          body:Container(
            margin: EdgeInsets.all(20),
            child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Nom evenement',
                          hintText: 'Exemple de nom',
                          border: OutlineInputBorder()
                      ),
                    )
                  ],
                )
            ),
          )
        )
    );
  }
}
