import 'package:flutter/material.dart';

class AjoutEvent extends StatefulWidget {
  const AjoutEvent({super.key});

  @override
  State<AjoutEvent> createState() => _AjoutEventState();
}

class _AjoutEventState extends State<AjoutEvent> {
  final _formkey = GlobalKey<FormState>();

  final eventController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Container(
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
                      controller: eventController,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: DropdownButtonFormField(
                        items: const[
                          DropdownMenuItem(value: '60', child: Text("1h")),
                          DropdownMenuItem(value: '30', child: Text("30 min")),
                          DropdownMenuItem(value: '10', child: Text("10 min"))
                        ],
                        decoration: const InputDecoration(
                            border: OutlineInputBorder()
                        ),
                        value: '60',
                        onChanged: (value){}
                    ),
                  ),
                  SizedBox(
                      width: double.infinity,
                      height: 20,
                      child: ElevatedButton(
                          onPressed: ()
                          {
                            if(_formkey.currentState!.validate())
                            {
                              final nom = eventController.text;

                              print("ajout de $nom");
                              /*
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Envoi en cours..."))
                                  );
                                  FocusScope.of(context).requestFocus(FocusNode());
                                 */
                            }

                          },
                          child: const Text("Envoyer")
                      )
                  )
                ],
              )
          ),
        )
    );
  }
}
