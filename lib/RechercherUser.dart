  import 'dart:convert';

  import 'package:flutter/material.dart';
  import 'package:mqtt_client/mqtt_client.dart';
  import 'package:mqtt_client/mqtt_server_client.dart';
  import 'package:trust_eval/objets/Utilisateur.dart';
  import 'package:trust_eval/pages/SousPages/descriptionUser.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';

  import 'main.dart';

  class RechercherUser extends StatefulWidget {
    const RechercherUser({super.key,});

    @override
    State<RechercherUser> createState() => _RechercheUserState();
  }

  class _RechercheUserState extends State<RechercherUser> {


    @override
    Widget build(BuildContext context) {
      getUtilisateurs();
      return Center(
          child: ListView.builder(
          itemCount: listeUtilisateur.length,
            itemBuilder: (context, index){
              final user = listeUtilisateur[index];
              final pseudo = user.pseudo;
              final email = user.email;

              return InkWell(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(
                      builder: (context)=> descriptionUser( user: user
                      ),
                    ));
                  },
                  child:Card(
                      child: ListTile(
                        leading: const FlutterLogo(size: 56.0),
                        title:  Text(pseudo),
                        subtitle: Text(email),
                        trailing:  const Icon(Icons.more_vert),
                      )
                  )
              );
            },
            ),
      );
          }


    Future<void> getUtilisateurs() async {
      final mqttClient = MqttServerClient.withPort(ipServeur, idUser, 1883);
      // Connecter le client
      await mqttClient.connect();
      mqttClient.subscribe('getUsers', MqttQos.atLeastOnce);
      mqttClient.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        final recMess = c![0].payload as MqttPublishMessage;
        final pt = MqttPublishPayload.bytesToStringAsString(
            recMess.payload.message);
        final jsonString = pt;
        print('Received message: topic is ${c[0].topic}, payload is $pt');
        List<dynamic> jsonData = jsonDecode(jsonString);
        if (mounted) {
          setState(() {
            listeUtilisateur =
                jsonData.map((json) => Utilisateur.fromJson(json)).toList();
          });
        }
      });
      final builder = MqttClientPayloadBuilder();
      // Publier un message

      if(chPage)
        {
          print("send message users/all");
          chPage = false;
          mqttClient.publishMessage(
              'users/all', MqttQos.atLeastOnce, builder.payload!);
        }

    }
    }
