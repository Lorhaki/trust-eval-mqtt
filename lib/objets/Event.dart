import "dart:convert";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// Importez votre classe Event ici
import 'event.dart';
class Event {
  String auteur;
  String type;
  String description;
  double localisationX;
  double localisationY;
  String dateCreation;

  bool isFavorite;
  int FavouriteCount;


  Event(this.auteur,this.type,this.description,
      this.localisationX,this.localisationY, this.dateCreation, this.isFavorite,
      this.FavouriteCount);


  factory Event.fromJson(Map<String, dynamic> json)
    {
      return Event(json["auteur"], json["type"], json["description"], json["localisationX"], json["localisationY"], json["dateCreation"], json["isFavorite"], json["FavouriteCount"]);
    }



  }

