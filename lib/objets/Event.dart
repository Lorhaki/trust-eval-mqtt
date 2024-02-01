
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
}