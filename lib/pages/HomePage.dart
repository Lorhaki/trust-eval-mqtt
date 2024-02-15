import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'SousPages/descriptionEvent.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key,});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Events").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const CircularProgressIndicator();
          }

          if(!snapshot.hasData){
            return const Text("Aucun evenement disponible");
          }

          List<dynamic> events = [];
          for (var element in snapshot.data!.docs) {
            events.add(element);
          }

            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index){
                final event = events[index];
                final type = event['type'];
                final nom = event['nom'];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(
                        builder: (context)=> descriptionEvent( event: event
                    ),
                    ));
                  },
                    child:Card(
                            child: ListTile(
                                 leading: const FlutterLogo(size: 56.0),
                                title:  Text(type),
                                subtitle: Text(nom),
                                trailing:  const Icon(Icons.more_vert),
                )
                )
                );
              },

            );
        }
      ),
    );
  }
}