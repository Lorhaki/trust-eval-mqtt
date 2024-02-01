import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
//import 'package:flutter_map/flutter_map.dart';

class Mymap extends StatefulWidget {
  const Mymap({super.key});

  @override
  State<Mymap> createState() => _MyMarkerMap();

}
class _MyMarkerMap extends State<Mymap>{

  final users = [
    {
      "x": "51.0",
      "y": "-0.12",
      "nom":"Loic"
    },
    {
      "x": "-0.12",
      "y": "51.0",
      "nom":"Loic"
    },
    {
      "x": "50.32",
      "y": "3.51",
      "nom":"UPHF"
    }
  ]
  ;
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
            options: MapOptions(
              center: LatLng( 51.0 , -0.12),
              zoom: 12,
            ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(
              markers:users.map((user) {
                final latitude = double.parse(user['x']!);
                final longitude = double.parse(user['y']!);

                return Marker(
                      width: 45.0,
                      height:45.0,
                      point: LatLng(latitude, longitude),
                      builder: (context) => Container(
                      child: IconButton(
                      icon: const Icon(Icons.location_on),
                      color: Colors.red,
                      onPressed: () {
                            },
                       ),
              )
                );
              }).toList(),
              ),
    ],
    );
  }
}



