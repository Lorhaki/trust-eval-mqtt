
// Importez votre classe Event ici
class Evenement {
  int auteur;
  String type;
  String description;
  double longitude;
  double latitude;
  String dateCreation;
  String duree;
  int perimetre;
  String pseudoUser;
  String id;
  int likes;
  int dislikes;



  Evenement(this.auteur,this.type,this.description,
      this.longitude,this.latitude, this.dateCreation,
      this.duree, this.perimetre, this.pseudoUser, this.id, this.likes, this.dislikes);


  factory Evenement.fromJson(Map<String, dynamic> json)
    {
      return Evenement(json["idUser"],
          json["type"],
          json["description"],
          json["longitude"],
          json["latitude"],
          json["heureDebut"],
      json["duree"],
      json["perimetre"],
      json["pseudoUser"],
      json["id"].toString(),
      json["likes"],
      json["dislikes"]);
    }



  }

