
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../main.dart';
import '../objets/Utilisateur.dart';
import 'Authentification.dart';
import '../objets/dto/CreationEvent.dart';
import 'MenuDefillant.dart';

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
  int perimetre = 5;

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
                              Position position =  await _determinePosition();
                              //LatLng loc = LatLng(position.latitude, position.longitude);
                              final mqttClient = MqttServerClient.withPort(ipServeur,'zertyuio', 1883);
                              // Connecter le client
                              await mqttClient.connect();
                              mqttClient.subscribe('eventCreer/${idUser}',MqttQos.atLeastOnce);
                              mqttClient.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
                                final recMess = c![0].payload as MqttPublishMessage;
                                final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
                                print('Received message: topic is ${c[0].topic}, event a été créer');
                                const snackBar = SnackBar(
                                  content: Text('evenement a ete cree'),
                                  duration: Duration(seconds: 2), // Durée du message
                                );
                                eventController.text = "";
                                descriptionController.text="";
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                print("connexion echouee");
                              });
                              final builder = MqttClientPayloadBuilder();
                              CreationEvent event = CreationEvent(idUser, type, description, position.longitude, position.latitude, int.parse(duree), perimetre);
                              builder.addString(jsonEncode(event));
                              // Publier un message
                              mqttClient.publishMessage('events/add/${idUser}', MqttQos.atLeastOnce,builder.payload! );
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
