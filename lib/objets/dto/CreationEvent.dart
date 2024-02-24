
// Importez votre classe Event ici
class CreationEvent {
  String auteur;
  String type;
  String description;
  double longitude;
  double latitude;
  int duree;
  int perimetre;


  CreationEvent(this.auteur,this.type,this.description,
      this.longitude,this.latitude, this.duree, this.perimetre);


  Map<String, dynamic> toJson() => {
    'type': type,
    'idUser': auteur,
    'description' : description,
    'latitude': latitude,
    'longitude': longitude,
    'duree': duree,
    'perimetre': perimetre
  };



}

