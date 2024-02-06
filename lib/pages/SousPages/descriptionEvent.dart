import 'package:flutter/material.dart';
import 'boutonLike.dart';
import 'package:on_essaie_encore/objets/Event.dart';


class descriptionEvent extends StatelessWidget {
  const descriptionEvent({super.key, required this.event});
  final dynamic event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("Description de l'évenement"),
        ),
        body: Center(
          child: Row(
            children: [
              SizedBox(width: 10), // Marge gauche
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          this.event['type'],
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                      ),
                      Text(
                           this.event['utilisateur'],
                            style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                          ),
                      ),
                      Text(
                           this.event['description'] + "\n"
                          ""),

                      /*Text( "Latitude : " + this.event.toString() + " Longitude : " + this.event.localisationY.toString() + "\n"
                              ),*/
                      FavoriteWidget(isFavorited : /*event.isFavorite*/ false , favoriteCount: /*event.FavouriteCount*/ 0)
                    ],
                  )
              ),
              SizedBox(width: 10),
            ],
          ),
        )
    );
  }
}
