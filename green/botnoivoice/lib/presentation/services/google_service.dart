import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';

class GoogleService {
  final GoogleLoginProvider googleLoginProvider;

  GoogleService(this.googleLoginProvider);

  Future<String?> getUserIdWithGoogle() async {
    if (googleLoginProvider.isLoggedIn &&
        googleLoginProvider.user?.providerData[0].providerId == 'google.com') {
      String? userId = googleLoginProvider.user?.uid;
      return userId;
    }
    return null;
  }
}
