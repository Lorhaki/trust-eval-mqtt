import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';


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
  const Mymap({super.key});

  @override
  State<Mymap> createState() => _MyMarkerMap();
}

class _MyMarkerMap extends State<Mymap> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Events").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData) {
            return const Text("Aucun evenement disponible");
          }

          List<dynamic> events = [];
          for (var element in snapshot.data!.docs) {
            events.add(element);
          }

          return FlutterMap(
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
                circles: events.map((event) {
          final latitude = event['localisationX']!;
          final longitude = event['localisationY']!;
          final perimetre = event['perimetre']!;

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
                markers: events.map((event) {
                  final latitude = event['localisationX']!;
                  final longitude = event['localisationY']!;

                  return Marker(
                    width: 45.0,
                    height: 45.0,
                    point: LatLng(latitude, longitude),
                    builder: (context) => Container(
                      child: IconButton(
                        icon: const Icon(Icons.location_on),
                        color: Colors.red,
                        onPressed: () => {}, // Add placeholder function
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
        Positioned(
          bottom: 20.0, // Adjust the distance from the bottom
          left: 20.0, // Adjust the horizontal position
          child: ElevatedButton(
            onPressed: () async{

              Position position =  await _determinePosition();
              setState(() {
                loc = LatLng(position.latitude, position.longitude);
                //loc = LatLng(50.326085, 3.514633);
              });
            },
            child: const Text("Centrer"),
          ),
        ),
]
    );
  }
}
