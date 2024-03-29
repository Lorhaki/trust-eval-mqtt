import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:trust_eval/objets/fonctions.dart';
import 'package:trust_eval/pages/HomePage.dart';
import 'package:trust_eval/pages/MenuDefillant.dart';
import '../objets/Evenement.dart';
import '../objets/Utilisateur.dart';
import 'Inscription.dart';
import 'package:trust_eval/main.dart';

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

class MyAuth extends StatefulWidget {
  const MyAuth({super.key});

  @override
  State<MyAuth> createState() => _MyAuthState();
}

class _MyAuthState extends State<MyAuth>{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Page de connexion") ,
      ),
      body:  Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: Column(
              children: [
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
                      if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty && passwordController.text.length > 6){
                        login();
                      }
                    },
                    child: const Text("Connexion"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context)=> MyInsc()
                    ),
                    /*final auth = FirebaseAuth.instance;
                    auth.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text
                    );
                      await Future.delayed(const Duration(seconds: 2));
                      CollectionReference user =  FirebaseFirestore.instance.collection("Users");
                      user.add({
                        "mail" : emailController.text,
                        "uid" : FirebaseAuth.instance.currentUser!.uid.characters.string,
                        "confiance" : 50
                      */);
                    },
                  child: const Text("Inscription"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async{
    Position position = await _determinePosition();
    final donneesConnexion = {
      'mail': emailController.text,
      'mdp': passwordController.text,
      'latitude': position.latitude,
      'longitude': position.longitude
    };
    var temp = generateRandomString(20);
    final mqttClient = MqttServerClient.withPort(ipServeur,idUser.toString(), 1883);
    // Connecter le client
    await mqttClient.connect();
    mqttClient.subscribe('connexionReussie/$temp',MqttQos.atLeastOnce);
    mqttClient.subscribe('connexionEchouee/$temp',MqttQos.atLeastOnce);
    mqttClient.subscribe('versMenu/$temp',MqttQos.atLeastOnce);
    print('versMenu/$temp');

    //print('connexionEchouee/${temp}');
    //print('creationReussie/');
    mqttClient.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final demande = c[0].topic.split('/');
      if(demande[0] == 'connexionReussie')
        {
          final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
          final jsonString = pt;
          Map<String, dynamic> data = jsonDecode(jsonString);
          print('Received message: topic is ${c[0].topic}, payload is $pt');
          final builder = MqttClientPayloadBuilder();
          builder.addString(jsonEncode(temp));
          mqttClient.publishMessage("users/cheminMenu/$temp", MqttQos.atLeastOnce,builder.payload!);
          idUser = data['id'].toString();
          userActu = Utilisateur.fromJson(data);
        }
      else  if(demande[0] == 'versMenu')
        {
          passwordController.text = "";
          emailController.text = "";
          final pt = MqttPublishPayload.bytesToStringAsString(
              recMess.payload.message);
          final jsonString = pt;
          print('Received message: topic is ${c[0].topic}, payload is $pt');
          List<dynamic> jsonData = jsonDecode(jsonString);
          listeEvents = jsonData.map((json) => Evenement.fromJson(json)).toList();
          Navigator.push(
              context, MaterialPageRoute(
              builder: (context)=> MyMenu()
          ));
        }
      else
        {
          passwordController.text = "";
          emailController.text = "";
          const snackBar = SnackBar(
            content: Text('est pas le bon mot de passe ou le bon mail'),
            duration: Duration(seconds: 2), // Durée du message
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          print("connexion echouee");
        }
    });
    final builder = MqttClientPayloadBuilder();
    builder.addString(jsonEncode(donneesConnexion));
    // Publier un message
    mqttClient.publishMessage('users/connexion/$temp', MqttQos.atLeastOnce,builder.payload! );


  }
}
