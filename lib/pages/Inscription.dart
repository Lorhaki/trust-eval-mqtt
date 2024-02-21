import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:trust_eval/main.dart';
import 'package:trust_eval/pages/Authentification.dart';

import '../objets/Utilisateur.dart';

class MyInsc extends StatefulWidget {
  const MyInsc({super.key});

  @override
  State<MyInsc> createState() => _MyAuthState();
}

class _MyAuthState extends State<MyInsc>{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final pseudoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Page inscription") ,
      ),
      body:  Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: pseudoController,
                  decoration: const InputDecoration(hintText: "Pseudo"),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: "Email"),
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "Password"),
                ),

                ElevatedButton(
                  onPressed: () async {
                        //Implementer le systéme d'inscription avec Mosquitto ICI !!
                    final mqttClient = MqttServerClient.withPort('172.24.16.1','zertyuio', 1883);
                    print(mqttClient.port);
                    // Connecter le client
                    await mqttClient.connect();
                    mqttClient.subscribe('creationReussie/${pseudoController.text}',MqttQos.atLeastOnce);
                    print('creationReussie/${pseudoController.text}');
                    mqttClient.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
                      final recMess = c![0].payload as MqttPublishMessage;
                      final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
                      final jsonString = pt;
                      idUser = int.parse(pt.toString());
                      print('Received message: topic is ${c[0].topic}, payload is $pt');
                      Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context)=> MyAuth()
                      ));
                    });
                    String mess = 'Hello, MQTT!';
                    final builder = MqttClientPayloadBuilder();
                    Utilisateur user = Utilisateur(50, emailController.text, passwordController.text, 0, 0, pseudoController.text);
                    builder.addString(jsonEncode(user));
                    // Publier un message
                    mqttClient.publishMessage('users/add/${pseudoController.text}', MqttQos.atLeastOnce,builder.payload! );
                  },
                  child: const Text("Valider"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async{
    final auth = FirebaseAuth.instance;
    // print(auth.currentUser!.uid + "azeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    auth.signInWithEmailAndPassword(
        email: emailController.text, password: passwordController.text);
  }


}