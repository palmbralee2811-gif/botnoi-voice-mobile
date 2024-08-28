import 'package:botnoivoice/Authentication/authentication_provider.dart';
import 'package:flutter/material.dart';

class CreditsProvider with ChangeNotifier {
  String? _credits;

  String? get credits => _credits;

  void setCredits(String? newCredits) {
    _credits = newCredits;
    notifyListeners();
  }

  Future<void> fetchCredits(Authentication auth) async {
    final fetchedCredits = await auth.getProfileWithToken(auth.jwtToken);
    setCredits(fetchedCredits);
  }
}
