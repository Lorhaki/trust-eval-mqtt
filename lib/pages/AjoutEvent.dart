
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

class AjoutEvent extends StatefulWidget {
  const AjoutEvent({super.key});

  @override
  State<AjoutEvent> createState() => _AjoutEventState();
}

class _AjoutEventState extends State<AjoutEvent> {
  final _formkey = GlobalKey<FormState>();

  final eventController = TextEditingController();
  final descriptionController = TextEditingController();
  String duree = '10';
  String type  = 'retard';
  String nom = 'Par defaut';
  String description = 'Par defaut';
  num perimetre = 5;

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
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Exemple de description',
                          border: OutlineInputBorder()
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty)
                        {
                          return "Nom incompatible";
                        }
                        else
                        {
                          description = value;
                        }
                        return null;
                      },
                      controller: descriptionController,
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
                          DropdownMenuItem(value: 15, child: Text("15 km")),
                          DropdownMenuItem(value: 10, child: Text("10 km")),
                          DropdownMenuItem(value: 5, child: Text("5 km"))
                        ],
                        decoration: const InputDecoration(
                            labelText: 'distance',
                            border: OutlineInputBorder()
                        ),
                        value: perimetre,
                        onChanged: (value){
                          setState(() {
                            perimetre = value!;
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
                          async {
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
                              Position position =  await _determinePosition();
                              LatLng loc = LatLng(position.latitude, position.longitude);
                              eventsRef.add({
                                "confiance" : 50,
                                "duree" : int.parse(duree),
                                "type" : type,
                                "utilisateur" : "Adrien",
                                "nom" : nom,
                                "localisationX": position.latitude,
                                "localisationY": position.longitude,
                                "participation": 0,
                                "perimetre":perimetre,
                                "description": description,
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
