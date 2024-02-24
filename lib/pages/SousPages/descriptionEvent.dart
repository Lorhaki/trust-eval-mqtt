import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:path/path.dart';
import 'package:trust_eval/objets/Utilisateur.dart';
import 'package:trust_eval/pages/SousPages/descriptionUser.dart';

import '../../main.dart';
import '../../objets/Event.dart';
import 'boutonDislike.dart';
import 'boutonLike.dart';
var cont;

class descriptionEvent extends StatelessWidget {
  final Event event;
  const descriptionEvent({required this.event});


  @override
  Widget build(BuildContext context) {
    cont = context;
    getEvents();
    double confiance = (((event.likes - event.dislikes) / (event.likes + event.dislikes)) * 100);
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
                              if (!(mqttClient.connectionStatus!.state != MqttConnectionState.connected))
                                {
                                  final builder = MqttClientPayloadBuilder();
                                  builder.addString(event.pseudoUser);
                                  mqttClient.publishMessage("events/getUser/$idUser", MqttQos.atLeastOnce, builder.payload!);
                                }
                              else
                                print("pas encore connecté");

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
                      FavoriteWidget(isFavorited: false, favoriteCount: event.likes, eventId: event.id),
                      DislikeWidget(isDisliked: false, dislikeCount: event.dislikes, eventId: event.id),
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
    mqttClient.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt = MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message);
      final jsonString = pt;
      print('Received message: topic is ${c[0].topic}, payload is $pt');
      Navigator.push(
          cont, MaterialPageRoute(
        builder: (context) =>
            descriptionUser(user: Utilisateur.fromJson(jsonDecode(jsonString))),
      ));
    });
  }
}

