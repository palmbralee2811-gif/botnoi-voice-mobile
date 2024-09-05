import 'package:botnoivoice/data/repositories/token_manager.dart';
import 'package:flutter/material.dart';

class CreditsRepositoryImpl with ChangeNotifier {
  String? _credits;

  String? get credits => _credits;

  void setCredits(String? newCredits) {
    _credits = newCredits;
    notifyListeners();
  }

  Future<void> fetchCredits(TokenManager auth) async {
    if (auth.jwtToken != null) {
      final fetchedCredits = await auth.getProfileWithToken(auth.jwtToken);
      setCredits(fetchedCredits);
    }
  }
}
