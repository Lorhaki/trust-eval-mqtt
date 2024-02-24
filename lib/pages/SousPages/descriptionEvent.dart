import 'package:flutter/material.dart';

import '../../objets/Event.dart';
import 'boutonDislike.dart';
import 'boutonLike.dart';

class descriptionEvent extends StatelessWidget {
  final Event event;

  const descriptionEvent({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Description de l'événement"),
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
                    event.type,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    event.pseudoUser,
                    style: const TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    "${event.description}\n",
                  ),
                  Row(
                    children: [
                      FavoriteWidget(isFavorited: false, favoriteCount: event.likes, eventId: event.id),
                      DislikeWidget(isDisliked: false, dislikeCount: event.dislikes, eventId: event.id),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}

