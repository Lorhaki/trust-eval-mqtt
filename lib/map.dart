import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
//import 'package:flutter_map/flutter_map.dart';

class Mymap extends StatelessWidget {
  const Mymap({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
            options: MapOptions(
              center: LatLng( 51.0 , -0.12),
              zoom: 12,
            ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            )
          ],
        )
      ],
    );

  }
}


