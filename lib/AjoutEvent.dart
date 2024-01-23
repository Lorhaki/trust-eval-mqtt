import 'package:flutter/material.dart';

class AjoutEvent extends StatefulWidget {
  const AjoutEvent({super.key});

  @override
  State<AjoutEvent> createState() => _AjoutEventState();
}

class _AjoutEventState extends State<AjoutEvent> {
  final _formkey = GlobalKey<FormState>();

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
                key: _formkey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Nom evenement',
                            hintText: 'Exemple de nom',
                            border: OutlineInputBorder()
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty)
                            {
                              return "Nom incompatible";
                            }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                        width: double.infinity,
                        height: 20,
                        child: ElevatedButton(
                            onPressed: () => print("click button"),
                            /*{
                              if(_formkey.currentState!.validate())
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Envoi en cours..."))
                                  );
                                }
                            },*/
                            child: Text("Envoyer")
                        )
                    )
                  ],
                )
            ),
          )
        )
    );
  }
}
