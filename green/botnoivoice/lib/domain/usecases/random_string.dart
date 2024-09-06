import 'dart:math';

/// Generate a random string of numbers
String randomStringOfNumbers(int length) {
  const characters = '0123456789';

  final random = Random();
  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => characters.codeUnitAt(
        random.nextInt(characters.length),
      ),
    ),
  );
}

/// Generate a random string of capital letters
String randomStringOfCapitals(int length) {
  const characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  final random = Random();
  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => characters.codeUnitAt(
        random.nextInt(characters.length),
      ),
    ),
  );
}
