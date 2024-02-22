
// Importez votre classe Event ici
class Event {
  int auteur;
  String type;
  String description;
  double longitude;
  double latitude;
  String dateCreation;
  bool isFavorite;
  int FavouriteCount;



  Event(this.auteur,this.type,this.description,
      this.longitude,this.latitude, this.dateCreation, this.isFavorite,
      this.FavouriteCount);


  factory Event.fromJson(Map<String, dynamic> json)
    {
      return Event(json["auteur"],
          json["type"],
          json["description"],
          json["longitude"],
          json["latitude"],
          json["dateCreation"],
          json["isFavorite"],
          json["FavouriteCount"]);
    }



  }

