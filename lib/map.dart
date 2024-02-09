import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Mymap extends StatefulWidget {
  const Mymap({super.key});

  @override
  State<Mymap> createState() => _MyMarkerMap();
}

class _MyMarkerMap extends State<Mymap> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Events").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData) {
            return Text("Aucun evenement disponible");
          }

          List<dynamic> events = [];
          snapshot.data!.docs.forEach((element) {
            events.add(element);
          });

          return FlutterMap(
            options: MapOptions(
              center: LatLng(51.0, -0.12),
              zoom: 12,
            ),
            children: [
              TileLayer(
                urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: events.map((event) {
                  final latitude = double.parse(event['localisationX']!);
                  final longitude = double.parse(event['localisationY']!);

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
    );
  }
}
