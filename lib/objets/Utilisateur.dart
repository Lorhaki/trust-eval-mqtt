import 'package:cloud_firestore/cloud_firestore.dart';

class Utilisateur {
  double scoreConfiance;
  String pseudo;
  String email;
  String mdp;
  int participation;
  int nbEvent;
  double latitude;
  double longitude;

  Utilisateur(this.scoreConfiance, this.email, this.mdp, this.nbEvent, this.participation, this.pseudo, this.latitude, this.longitude);


  Map<String, dynamic> toJson() => {
    'pseudo': pseudo,
    'email': email,
    'mdp' : mdp,
    'confiance': 50,
    'participation': 0,
    'nbEvent': 0,
    'latitude': latitude,
    'longitude': longitude
  };

  factory Utilisateur.fromJson(Map<String, dynamic> json)
  {
    return Utilisateur(json["confiance"],
        json["email"],
        json["mdp"],
        json["nbEvents"],
        json["participation"],
        json["pseudo"],
    json["latitude"],
    json["longitude"]);
  }


}