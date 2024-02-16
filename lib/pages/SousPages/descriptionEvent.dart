import 'package:flutter/material.dart';
import 'boutonLike.dart';
import 'boutonDislike.dart';

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
              const SizedBox(width: 10), // Marge gauche
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          event['type'],
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                      ),
                      Text(
                           event['utilisateur'],
                            style: const TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                          ),
                      ),
                      Text(
                           event['description'] + "\n"
                          ""),

                      /*Text( "Latitude : " + this.event.toString() + " Longitude : " + this.event.localisationY.toString() + "\n"
                              ),*/
                      Row(
                        children: [
                          const FavoriteWidget(isFavorited : /*event.isFavorite*/ false , favoriteCount: /*event.FavouriteCount*/ 0),
                          const DislikeWidget(isDisliked: false /*event.isDislike*/, dislikeCount: 0 /*event.DislikeCountCount*/),
                        ],
                      )

                    ],
                  )
              ),
              const SizedBox(width: 10),
            ],
          ),
        )
    );
  }
}
