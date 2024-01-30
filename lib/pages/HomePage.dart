import 'package:flutter/material.dart';
import 'SousPages/descriptionEvent.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key,});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final events = [
    {
      "speaker": "loic flament",
      "date": "13h à 13h30",
      "subject": "Le code legacy",
      "avatar": "lior"
    },
    {
      "speaker": "adrien blassel",
      "date": "13h à 13h30",
      "subject": "TrustEval",
      "avatar": "coucou"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index){
            final event = events[index];
            final avatar = event['avatar'];
            final speaker = event['speaker'];
            final date = event['date'];
             return  GestureDetector(
               child: Card(
                  child: ListTile(
                    leading: FlutterLogo(size: 56.0),
                    title:  Text('$speaker'),
                    subtitle: Text('$date'),
                    trailing:  Icon(Icons.more_vert),
                  ),
               ),
               onTap: (){
                    print('$speaker');
                    Navigator.push(
                        context, MaterialPageRoute(
                        builder: (context)=>descriptionEvent()
                    ));
               },
                );
          },
        )
    );
  }
}