import 'dart:html';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:trust_eval/main.dart';
import 'package:trust_eval/objets/Evenement.dart';

import '../../objets/fonctions.dart';
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


class FavoriteWidget extends StatefulWidget {
  final bool isFavorited;
  final int favoriteCount;
  final Evenement event;

  const FavoriteWidget({Key? key, required this.isFavorited, required this.favoriteCount, required this.event}) : super(key: key);

  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState(isFavorited, favoriteCount, event);
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorited;
  int _favoriteCount;
  final Evenement _event;

  _FavoriteWidgetState(this._isFavorited, this._favoriteCount, this._event);

  Future<void> _toggleFavorite() async {

    if(calculateDistance(userActu.latitude, userActu.longitude, _event.latitude, _event.longitude) <= _event.perimetre)
    {
      if (_isFavorited) {
        setState(() {
          _isFavorited = false;
          _favoriteCount -= 1;
        });
      } else {
        await mqttClient.connect();
        final builder = MqttClientPayloadBuilder();
        builder.addString(idUser);
        mqttClient.publishMessage('events/vrai/${_event.id}', MqttQos.atLeastOnce, builder.payload!);
        setState(() {
          _isFavorited = true;
          _favoriteCount += 1;
        });
      }
    }
    else
    {
      const snackBar = SnackBar(
        content: Text('Vous êtes trop loin pour réagir'),
        duration: Duration(seconds: 2), // Durée du message
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: _isFavorited ? const Icon(Icons.thumb_up) : const Icon(Icons.thumb_up),
          color: Colors.blue,
          onPressed: _toggleFavorite,
          iconSize: 35,
        ),
        Text(
          '$_favoriteCount',
          style: const TextStyle(
            fontSize: 35,
          ),
        ),
      ],
    );
  }
}
