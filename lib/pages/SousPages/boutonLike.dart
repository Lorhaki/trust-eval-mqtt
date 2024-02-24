import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:trust_eval/main.dart';

class FavoriteWidget extends StatefulWidget {
  final bool isFavorited;
  final int favoriteCount;
  final String eventId;

  const FavoriteWidget({Key? key, required this.isFavorited, required this.favoriteCount, required this.eventId}) : super(key: key);

  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState(isFavorited, favoriteCount, eventId);
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorited;
  int _favoriteCount;
  final String _eventId;

  _FavoriteWidgetState(this._isFavorited, this._favoriteCount, this._eventId);

  Future<void> _toggleFavorite() async {
    if (_isFavorited) {
      setState(() {
        _isFavorited = false;
        _favoriteCount -= 1;
      });
    } else {
      await mqttClient.connect();
      final builder = MqttClientPayloadBuilder();
      mqttClient.publishMessage('events/vrai/$_eventId', MqttQos.atLeastOnce, builder.payload!);
      setState(() {
        _isFavorited = true;
        _favoriteCount += 1;
      });
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
