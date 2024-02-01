import 'package:flutter/material.dart';
import 'boutonLike.dart';
import 'package:on_essaie_encore/objets/Event.dart';
class descriptionEvent extends StatelessWidget {
  const descriptionEvent({super.key, required this.event});
  final Event event;

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
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nom de l'evenement:" + this.event.type + "\n"
                          "Auteur: " + this.event.auteur + "\n"
                          "Description: " + this.event.description + "\n"
                          ""),
                      FavoriteWidget(isFavorited : event.isFavorite , favoriteCount: event.FavouriteCount)
                    ],
                  )),
            ],
          ),
        )
    );
  }
}
