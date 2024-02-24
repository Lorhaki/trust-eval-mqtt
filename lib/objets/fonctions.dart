
import 'dart:math';


String generateRandomString(int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyzAZERTYUIOPMLKJHGFDSQWXCVBN0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
}

