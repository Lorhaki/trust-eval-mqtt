import 'package:flutter/material.dart';
import 'package:on_essaie_encore/objets/Event.dart';
import 'SousPages/descriptionEvent.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key,});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<Event> events = [
    Event(  "adrien",
        "incendie",
        "l'ecole à pris feu",
        51.50,
        51.2,
        "22 fevrier",
        false,
        22),
    Event(  "Loic",
        "incendie",
        "l'ecole à pris feu",
        51.4,
        51.3,
        "22 fevrier",
        false,
        78)

  ];
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index){
            return  GestureDetector(
              child: Card(
                child: ListTile(
                  leading: FlutterLogo(size: 56.0),
                  title:  Text(events[index].auteur),
                  subtitle: Text(events[index].type),
                  trailing:  Icon(Icons.more_vert),
                ),
              ),
              onTap: (){
                Navigator.push(
                    context, MaterialPageRoute(
                  builder: (context)=> descriptionEvent( event: events[index]
                  ),
                ));
              },
            );
          },
        )
    );
  }
}