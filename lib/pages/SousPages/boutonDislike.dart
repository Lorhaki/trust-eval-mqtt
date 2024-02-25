import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:trust_eval/objets/Evenement.dart';

import '../../objets/fonctions.dart';
import '../../main.dart';
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
class DislikeWidget extends StatefulWidget{
  final bool isDisliked;
  final int dislikeCount;
  final Evenement event;

  const DislikeWidget({super.key, required this.isDisliked, required this.dislikeCount, required this.event});


  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState(isDisliked, dislikeCount, event);
}

class _FavoriteWidgetState extends State<DislikeWidget>{
  bool _isDisliked ;
  int _dislikeCount;
  final Evenement _event;

  _FavoriteWidgetState(this._isDisliked, this._dislikeCount, this._event);



  Future<void> _toggleFavorite() async {
    if(calculateDistance(userActu.latitude, userActu.longitude, _event.latitude, _event.longitude) <= _event.perimetre)
    {
      if (_isDisliked) {
        setState(() {
          _isDisliked = false;
          _dislikeCount -= 1;
        });
      } else {
        await mqttClient.connect();
        final builder = MqttClientPayloadBuilder();
        builder.addString(idUser);
        mqttClient.publishMessage('events/faux/${_event.id}', MqttQos.atLeastOnce, builder.payload!);
        setState(() {
          _isDisliked = true;
          _dislikeCount += 1;
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
          icon: _isDisliked  ? const Icon(Icons.thumb_down) : const Icon(Icons.thumb_down),
          color: Colors.red,
          onPressed: _toggleFavorite,
          iconSize: 35,
        ),

        Text('$_dislikeCount',
            style: const TextStyle(
            fontSize: 35,
          ),
        ),
      ],
    );
  }
}

