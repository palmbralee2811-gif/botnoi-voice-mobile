import 'package:botnoivoice/data/repositories/auth_repository_impl.dart';
import 'package:flutter/material.dart';

class CreditsRepositoryImpl with ChangeNotifier {
  String? _credits;

  String? get credits => _credits;

  void setCredits(String? newCredits) {
    _credits = newCredits;
    notifyListeners();
  }

  Future<void> fetchCredits(AuthenticationRepositoryImpl auth) async {
    final fetchedCredits = await auth.getProfileWithToken(auth.jwtToken);
    setCredits(fetchedCredits);
  }
}
