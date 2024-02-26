import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:trust_eval/main.dart';
import 'package:trust_eval/pages/Authentification.dart';



import '../objets/Utilisateur.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  connexion() async{
    // Connecter le client
    await mqttClient.connect();
    mqttClient.subscribe('getUser/$idUser',MqttQos.atLeastOnce);
    mqttClient.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      final jsonString = pt;
      Map<String, dynamic> jsonObject = jsonDecode(jsonString);
      print('Received message: topic is ${c[0].topic}, payload is $pt');
      setState(() {
        userActu = Utilisateur.fromJson(jsonObject);
      });
    });
    String mess = idUser.toString();
    final builder = MqttClientPayloadBuilder();
    builder.addString(mess);
    if(chPage)
      {
        mqttClient.publishMessage('users/get', MqttQos.atLeastOnce,builder.payload! );
      }
  }

  @override
  Widget build(BuildContext context) {
    connexion();
    String pseudo = userActu.pseudo;
    String email = userActu.email;
    String confiance = userActu.scoreConfiance.toString();
    String participation = userActu.participation.toString();
    String nbEvent = userActu.nbEvent.toString();
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title:  Text("Pseudo: $pseudo"),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.mail),
                title:  Text("Email: $email"),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.favorite),
                title:  Text("Confiance: $confiance%"),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.handshake),
                title:  Text("Participation: $participation"),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.flag),
                title:  Text("Nombre event créés: $nbEvent" ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                  idUser = "0";
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyAuth()),
                );
                  Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: const Text("Se déconnecter"),
            ),
          ],
        ),
      ),
    );
  }
}

