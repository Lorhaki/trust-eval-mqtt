import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../../main.dart';

class DislikeWidget extends StatefulWidget{
  final bool isDisliked;
  final int dislikeCount;
  final String eventId;

  const DislikeWidget({super.key, required this.isDisliked, required this.dislikeCount, required this.eventId});


  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState(isDisliked, dislikeCount, eventId);
}

class _FavoriteWidgetState extends State<DislikeWidget>{
  bool _isDisliked ;
  int _dislikeCount;
  final String _eventId;

  _FavoriteWidgetState(this._isDisliked, this._dislikeCount, this._eventId);



  Future<void> _toggleFavorite() async {
    if (_isDisliked) {
      setState(() {
        _isDisliked = false;
        _dislikeCount -= 1;
      });
    } else {
      await mqttClient.connect();
      final builder = MqttClientPayloadBuilder();
      mqttClient.publishMessage('events/vrai/$_eventId', MqttQos.atLeastOnce, builder.payload!);
      setState(() {
        _isDisliked = true;
        _dislikeCount += 1;
      });
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

