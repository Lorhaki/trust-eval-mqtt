import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AjoutEvent extends StatefulWidget {
  const AjoutEvent({super.key});

  @override
  State<AjoutEvent> createState() => _AjoutEventState();
}

class _AjoutEventState extends State<AjoutEvent> {
  final _formkey = GlobalKey<FormState>();

  final eventController = TextEditingController();
  String duree = '10';
  String type  = 'retard';
  String nom = 'Par defaut';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Container(
          margin: const EdgeInsets.all(20),
          child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
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
                        else
                          {
                            nom = value;
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
                            labelText: 'durée',
                            border: OutlineInputBorder()
                        ),
                        value: duree,
                        onChanged: (value){
                          setState(() {
                            duree = value!;
                          });
                        }
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: DropdownButtonFormField(
                        items: const[
                          DropdownMenuItem(value: 'retard', child: Text("Retard d'un professeur")),
                          DropdownMenuItem(value: 'personalisé', child: Text("Personalisé")),
                          DropdownMenuItem(value: 'ru', child: Text("Queue au RU"))
                        ],
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          labelText: 'type'
                        ),
                        value: type,
                        onChanged: (value){
                          setState(() {
                            type = value!;
                          });
                        }
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

                              //print("ajout de $nom de $duree");
                              /*
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Envoi en cours..."))
                                  );
                                  FocusScope.of(context).requestFocus(FocusNode());
                                 */
                              CollectionReference eventsRef =  FirebaseFirestore.instance.collection("Events");
                              eventsRef.add({
                                "confiance" : 50,
                                "duree" : int.parse(duree),
                                "type" : type,
                                "utilisateur" : "Adrien",
                                "nom" : nom
                              });
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
