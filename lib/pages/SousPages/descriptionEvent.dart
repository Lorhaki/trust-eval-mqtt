import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:path/path.dart';
import 'package:trust_eval/objets/Utilisateur.dart';
import 'package:trust_eval/objets/fonctions.dart';
import 'package:trust_eval/pages/SousPages/descriptionUser.dart';

import '../../main.dart';
import '../../objets/Evenement.dart';
import 'boutonDislike.dart';
import 'boutonLike.dart';
var cont;
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

class descriptionEvent extends StatelessWidget {
  final Evenement event;
  const descriptionEvent({required this.event});


  @override
  Widget build(BuildContext context) {
    cont = context;
    getEvents();
    double confiance = (((event.likes) / (event.likes + event.dislikes)) * 100);
    chPage = true;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Description de l'événement"),
      ),
      body: Center(
        child: Row(
          children: [
            const SizedBox(width: 10), // Marge gauche
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Type:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            event.type,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Utilisateur:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              if(calculateDistance(userActu.latitude, userActu.longitude, event.latitude, event.longitude) <= event.perimetre)
                                {
                                  if (!(mqttClient.connectionStatus!.state != MqttConnectionState.connected))
                                  {
                                    final builder = MqttClientPayloadBuilder();
                                    builder.addString(event.pseudoUser);
                                    mqttClient.publishMessage("events/getUser/$idUser", MqttQos.atLeastOnce, builder.payload!);
                                  }
                                  else
                                    print("pas encore connecté");
                                }
                              else
                                {
                                  const snackBar = SnackBar(
                                    content: Text('Vous êtes trop loin pour réagir'),
                                    duration: Duration(seconds: 2), // Durée du message
                                  );
                                  ScaffoldMessenger.of(cont).showSnackBar(snackBar);
                                }
                            },
                            child: Text(
                              event.pseudoUser,
                              style: const TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Description:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            event.description,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Confiance:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "$confiance%",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      FavoriteWidget(isFavorited: false, favoriteCount: event.likes, event: event),
                      DislikeWidget(isDisliked: false, dislikeCount: event.dislikes, event: event),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
  Future<void> getEvents() async {
    // Connecter le client
    await mqttClient.connect();
    mqttClient.subscribe('getUserEvent/$idUser', MqttQos.atLeastOnce);
    mqttClient.subscribe('eventDejaReagi/${idUser}',MqttQos.atLeastOnce);
    print('eventDejaReagi/${idUser}');
    mqttClient.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt = MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message);
      final jsonString = pt;
      print('Received message: topic is ${c[0].topic}, payload is $pt');
      final demande = c[0].topic.split('/');
      if(demande[0] == 'getUserEvent')
        {
          Navigator.push(
              cont, MaterialPageRoute(
            builder: (context) =>
                descriptionUser(user: Utilisateur.fromJson(jsonDecode(jsonString))),
          ));
        }
      else
        {
          print("dejareagi");
          const snackBar = SnackBar(
            content: Text('Vous avez deja reagi'),
            duration: Duration(seconds: 2), // Durée du message
          );
          ScaffoldMessenger.of(cont).showSnackBar(snackBar);
        }
    });
  }
}

