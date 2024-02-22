import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../main.dart';
import 'MenuDefillant.dart';
import 'SousPages/descriptionEvent.dart';
import 'package:trust_eval/objets/Event.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key,});

  @override
  State<HomePage> createState() => _HomePageState();
}
List<Event> listeEvents = [];

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    getEvents();
    return Center(
      child: ListView.builder(
        itemCount: listeEvents.length,
        itemBuilder: (context, index) {
          final event = listeEvents[index];
          final type = event.type;
          final nom = event.pseudoUser;

          return InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(
                  builder: (context) =>
                      descriptionEvent(event
                      ),
                ));
              },
              child: Card(
                  child: ListTile(
                    leading: const FlutterLogo(size: 56.0),
                    title: Text(type),
                    subtitle: Text(nom.toString()),
                    trailing: const Icon(Icons.more_vert),
                  )
              )
          );
        },
      ),
    );
  }

  Future<void> getEvents() async {
    var temp = Random().nextInt(1000);
    final mqttClient = MqttServerClient.withPort(
        ipServeur, temp.toString(), 1883);
    // Connecter le client
    await mqttClient.connect();
    mqttClient.subscribe('getEvents', MqttQos.atLeastOnce);
    mqttClient.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt = MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message);
      final jsonString = pt;
      print('Received message: topic is ${c[0].topic}, payload is $pt');
      List<dynamic> jsonData = jsonDecode(jsonString);
      listeEvents = jsonData.map((json) => Event.fromJson(json)).toList();


      listeEvents.forEach((objet) {
        print(objet);
      });
    });
    final builder = MqttClientPayloadBuilder();
    // Publier un message
    mqttClient.publishMessage(
        'events/getAll', MqttQos.atLeastOnce, builder.payload!);
  }
}
