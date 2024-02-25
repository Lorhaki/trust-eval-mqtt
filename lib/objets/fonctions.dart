
import 'dart:math';

import 'package:geolocator/geolocator.dart';

//permet de generer une chaine de caractere aleatoire de taille length
String generateRandomString(int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyzAZERTYUIOPMLKJHGFDSQWXCVBN0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
}

// Fonction pour convertir les degrés en radians
double degreesToRadians(double degrees) {
  return degrees * pi / 180.0;
}

// Fonction pour calculer la distance entre deux points en utilisant la formule de la distance haversine
double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const earthRadiusKm = 6371.0; // Rayon de la Terre en kilomètres

  double dLat = degreesToRadians(lat2 - lat1);
  double dLon = degreesToRadians(lon2 - lon1);

  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(degreesToRadians(lat1)) * cos(degreesToRadians(lat2)) *
          sin(dLon / 2) * sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double distance = earthRadiusKm * c;

  return distance;
}



