import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:trust_eval/main.dart';
import 'package:trust_eval/pages/SousPages/descriptionEvent.dart';

import 'objets/Evenement.dart';

LatLng loc = LatLng(50.326085, 3.514633);

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

class Mymap extends StatefulWidget {
  const Mymap({Key? key}) : super(key: key);

  @override
  State<Mymap> createState() => _MyMarkerMap();
}

class _MyMarkerMap extends State<Mymap> {
  @override
  Widget build(BuildContext context) {
    getEvents();
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            center: loc,
            zoom: 12,
          ),
          children: [
            TileLayer(
              urlTemplate:
              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            CircleLayer(
              circles: listeEvents.map((event) {
                final latitude = event.latitude;
                final longitude = event.longitude;
                final perimetre = event.perimetre;

                return CircleMarker(
                  point: LatLng(latitude, longitude),
                  radius: perimetre * 100.toDouble(),
                  useRadiusInMeter: true,
                  borderColor: Colors.black,
                  borderStrokeWidth: 2,
                  color: Colors.blue.withOpacity(0.2),
                );
              }).toList(),
            ),
            MarkerLayer(
              markers: listeEvents.map((event) {
                final latitude = event.latitude;
                final longitude = event.longitude;

                return Marker(
                  width: 45.0,
                  height: 45.0,
                  point: LatLng(latitude, longitude),
                  builder: (context) => Container(
                    child: IconButton(
                      icon: const Icon(Icons.location_on),
                      color: Colors.red,
                      onPressed: () => {
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) =>
                              descriptionEvent(event: event),
                        )),

                      }, // Add placeholder function
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        Positioned(
          bottom: 20.0, // Adjust the distance from the bottom
          left: 20.0, // Adjust the horizontal position
          child: ElevatedButton(
            onPressed: () async {
              Position position = await _determinePosition();
              setState(() {
                loc = LatLng(position.latitude, position.longitude);
              });
            },
            child: const Text("Centrer"),
          ),
        ),
      ],
    );
  }

  Future<void> getEvents() async {
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
      if(mounted)
      {
        setState(() {
          listeEvents = jsonData.map((json) => Evenement.fromJson(json)).toList();
        });
      }

    });
    final builder = MqttClientPayloadBuilder();

    // Publier un message
    if(chPage)
    {
      print("send message events/all");
      chPage = false;
      mqttClient.publishMessage(
          'events/all', MqttQos.atLeastOnce, builder.payload!);
    }

  }
}
